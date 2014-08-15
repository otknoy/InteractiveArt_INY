
class FaceDetection{
    //- 顔認識用のOpenCVオブジェクト
    private OpenCV ocvf;
    //- 目認識用のOpenCVオブジェクト
    //private OpenCV ocve;
    //- 顔の位置と大きさを記憶する
    private Rectangle face;
    //- 目の位置と大きさを記憶する
    //private Rectangle lefteye;
    //private Rectangle righteye;
    
    //- コンストラクタ
    FaceDetection(PApplet app, int w, int h){
        //- 顔認識
        ocvf = new OpenCV(app, w, h);
        ocvf.loadCascade(OpenCV.CASCADE_FRONTALFACE);
        //- 目認識
        //ocve = new OpenCV(app, w, h);
        //ocve.loadCascade(OpenCV.CASCADE_EYE);
    }
    
    /*---------- 情報取得 ----------*/
    
    //- 顔の位置と大きさを取得
    Rectangle getFace(){
        return face;
    }
    
    //- 左目の位置と大きさを取得
    /*Rectangle getLeftEye(){
        return lefteye;
    }*/

    //- 右目の位置と大きさを取得
    /*Rectangle getRightEye(){
        return righteye;
    }*/
    
    //- 顔部分の画像を取得する
    PImage getFaceImage(){
        return ocvf.getInput().get(face.x, face.y, face.width, face.height);
    }
    
    
    /*---------- 情報操作 ----------*/
    
    //- RGBイメージを受け取る
    void inputImage(PImage rgb){
        ocvf.loadImage(rgb);
    }
    
    //- 顔領域のみ描画
    void outFaceFrame(){
        if(face == null) return;
        noFill();
        stroke(0, 255, 0);
        strokeWeight(3);
        
        //- 顔領域の描画
        rect(face.x, face.y, face.width, face.height);
    }   
    
    //- 顔認識結果を画面上に描画する
    void outFace(){
        noFill();
        stroke(0, 255, 0);
        strokeWeight(3);
        
        //- 顔領域の描画
        rect(face.x, face.y, face.width, face.height);
        //- 目領域の描画
        //ellipse(lefteye.x, lefteye.y, lefteye.width, lefteye.height);
        //ellipse(righteye.x, righteye.y, righteye.width, righteye.height);   
    }
    
    //- 顔認識処理全般(目認識も組み合わせて精度を上げる)
    boolean detect(){
        //- 画像が入力されていない時は false を返す
        if(ocvf.getInput() == null){
            println("画像が入力されていません");
            return false;
        }

        //- 顔認識
        if(faceDetect() == false){
            println("顔が検出されません");
            return false;   
        }     
        
        //- 目認識
        /*if(eyeDetect() == false){
            println("目が検出されません");
            return false;
        }
        
        //- 正確性判断
        if(checkFace() == false){
            println("正確性がありません");
            return false;
        }*/
        
        return true;
    }
    
    //- 顔認識
    boolean faceDetect(){
        
        //- 検出された顔を全て保存
        Rectangle[] faces = ocvf.detect();
        
        //- 顔が検出されなかった時は false を返す
        if(faces.length <= 0) return false;
        
        //- 検出された顔の中で一番大きい顔(近くにある顔)をユーザに指定する
        for(int i = 0, max = 0; i < faces.length; i++){
            if(max < faces[i].width * faces[i].height){
                //- 最大値更新
                max = faces[i].width * faces[i].height;
                //- ユーザ指定更新
                face = faces[i];
            }
        }
        
        //- 顔が検出されたとき
        return true;
    }
    
    //- 目認識
    /*boolean eyeDetect(){
        //- 画像を読み込む
        ocve.loadImage(ocvf.getInput().get());
        
        //- 検出された目を全て保存
        Rectangle[] eyes = ocve.detect();
        //- 2つの目を保存
        Rectangle[] eye = new Rectangle[2];
        
        //- 目が検出されなかった時は false を返す
        if(eyes.length <= 0){
            return false;
        }
            
        //- 検出された目で顔領域内にあるものを先着順に2つだけ保存しておく(大抵の場合はそれが両目になる)
        for(int i = 0, j = 0; i < eyes.length; i++){
            //- 目が顔領域内の上半分にあるかどうか
            if(face.contains(eyes[i]) && eyes[i].y < face.y + face.height / 2){
                   //- あるときは保存しておく
                   eye[j] = eyes[i];
                   //- 目の座標を左上角ではなく中心にしておく
                   eye[j].x += eye[j].width / 2;
                   eye[j].y += eye[j].height / 2;
                   j++;
             }
             
             //- 2つ目が検出されたとき
             if(j == 2){
                 if(eye[0].x < eye[1].x){
                     lefteye = eye[0];
                     righteye = eye[1];
                 }else{
                     lefteye = eye[1];
                     righteye = eye[0];
                 }
                 return true;
             }
         }
         //- 顔領域内に2つ目が検出されなかった場合
         return false;
    }
    
    //- 目の位置と大きさによって顔認識の正確性を調べる
    boolean checkFace(){
         //- 両目の距離が極端に近くないか確認
        if(lefteye.x > (face.x + face.width / 2) || (face.x + face.width / 2) > righteye.x) return false;
         
        //- 両目の垂直方向の位置が極端にずれていないか確認
        if(abs(lefteye.y - righteye.y) > 20) return false;
         
        //- 両目のサイズが極端にずれていないか確認
        if(abs(lefteye.width - righteye.width) > max(lefteye.width, righteye.width) / 2) return false;
         
        //- 正しいと思える場合
        return true;
    }*/
}
    
    
    
    
    
    
    
    
