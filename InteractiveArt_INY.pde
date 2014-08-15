/*****************************************************
            インタラクティブアート実習
                 岩崎、中川、山田
*****************************************************/


/*** ライブラリのインポート ***/
import gab.opencv.*;
import java.awt.Rectangle;
import SimpleOpenNI.*;
import processing.video.*;
import ddf.minim.*;


/*** オブジェクト作成 ***/
FaceDetection face;        //- 顔認識処理クラス
Goast goast;               //- 幽霊クラス
Kinect kinect;             //- キネクト操作クラス

PImage kinect_image;       //- Kinectからの映像をキャプチャーする
PImage scr_image;          //- スクリーン用に変換したkinectのキャプチャイメージ
float detection_sec;       //- 顔認識を何秒ごとに実行するか
float face_update_sec;     //- 幽霊画像を何秒ごとに更新するか
int detection_num;         //- 何度目の顔認識の画像を使うか
int detection_count;       //- 連続何度目の顔認識か
int update_frame;          //- 幽霊画像を更新した時のフレームカウントを保存しておく
boolean detection_flg;     //- 顔認識が成功したかどうか
boolean goast_flg;         //- 幽霊が作成されたかどうか
int frameleft, frameright; //- 位置合わせ用の位置を記憶しておく

Minim minim;               //- 幽霊を出現させるときの音
AudioPlayer bgm;


/*------------------------------------------------------------------------------------------------*/

void setup(){
    
    /*---------- 画面基本設定 ----------*/
    size(960, 620, OPENGL);     
    frameRate(30);
    colorMode(RGB, 256, 256, 256, 100);
    rectMode(CORNER);
    
    /*---------- インスタンス化 ----------*/
    face = new FaceDetection(this, 960, 620);
    goast = new Goast();
    kinect = new Kinect(this, 640, 480, 30);
    
    /*---------- その他変数 ----------*/
    kinect_image = createImage(640, 480, ARGB);
    scr_image = createImage(960, 620, ARGB);
    detection_sec = 1;
    face_update_sec = 30;
    frameCount = int((face_update_sec - 5) * 30);
    detection_num = 1;
    detection_count = 0;
    update_frame = 0;
    detection_flg = false;
    goast_flg = false;
    frameleft = (width - (height * 3 / 4)) / 2;
    frameright = (width + (height * 3 / 4)) / 2;
    minim = new Minim(this);
    bgm = minim.loadFile("bgm.mp3");
}

void draw(){
    
    /*---------- 入力処理 ----------*/
    
    //- kinectからの映像をキャプチャーする
    kinect_image = kinect.getRGB();
    //- リサイズする（ scr_image には kinect_image のクローンを渡す）
    scr_image = kinect_image.get();
    scr_image.resize(width, height);
    
    
    /*---------- 内部処理 ----------*/
            
    //- 顔認識はすごく時間がかかるので detection_sec 秒ごとに実行する
    if(frameCount % (30 * detection_sec) == 0){
        println("Face Detection : " + frameCount);
        
        //- 顔認識用の画像を入力しておく
        face.inputImage(scr_image.get());
        
        //- 顔認識処理
        detection_flg = face.detect();
        
        //- 顔認識が連続で何回成功したかをカウントしておく
        if(detection_flg) detection_count++;
        else detection_count = 0;
        
        //- 幽霊の視線目標位置の更新
        if(face.getFace() != null && goast_flg){
            goast.updateTarget(face.getFace());
        }
    }else{
        detection_flg = false;
    }
    
    //- 幽霊画像処理（顔認識が指定した回数連続して成功し、かつ設定したフレームカウントを超えるフレームでのみ実行）
    if(detection_flg && detection_count >= detection_num && (frameCount - update_frame) >= (30 * face_update_sec)){
        //goast.updateFace(kinect_image.get().pixels, kinect.getDepthMap(), face.getFace(), face.getLeftEye(), face.getRightEye(),kinect_image.width, kinect_image.height, scr_image.width, scr_image.height);
        goast.updateGoastPos(frameleft, frameright);
        //- 幽霊画像を更新した時のフレームカウントを保存しておく
        update_frame = frameCount;
        goast_flg = true;
        bgm.rewind();
        bgm.play();
    }
    if((frameCount - update_frame) >= (30 * face_update_sec)){
        goast_flg = false;
    }
    
    /*---------- 出力処理 ----------*/
    
    //- 背景
    background(0);
    
    //- テスト用イメージ出力
    //image(scr_image, 0, 0);

//    face.outFaceFrame();
    
    //- 幽霊画像が作成されているときは表示する
    if(goast_flg) goast.outGoastFace();
    
    //- 位置合わせ用ライン
    stroke(255, 128, 0);
    strokeWeight(3);
    line(frameleft, 0, frameleft, height);
    line(frameright, 0, frameright, height);
    
    /*---------- 更新処理 ----------*/
    kinect.update();
}

void stop(){
  bgm.close();  //サウンドデータを終了
  minim.stop();
  super.stop();
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
