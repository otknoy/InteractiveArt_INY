
class Kinect{
    //- OpenNIを扱うための変数＝Kinect処理
    private SimpleOpenNI oni;
    
    //- コンストラクタ
    Kinect(PApplet app, int w, int h, int fps){
        //- OpenNI
        oni = new SimpleOpenNI(app, SimpleOpenNI.RUN_MODE_MULTI_THREADED);
        oni.setMirror(false);                      //- 左右反転処理を無効化（プロジェクターで投影する際、左右反転するため、ここでデジタル的に左右反転しなくてよい）
        oni.enableDepth(w, h, fps);                //- 深度センサーをオン
        oni.enableRGB(w, h, fps);                  //- RGBカメラをオン
        oni.alternativeViewPointDepthToImage();    //- 深度カメラとRGBカメラの視点を合わせる
    }
    
    //- RGBカメラの画像を取得
    PImage getRGB(){
        return oni.rgbImage();
    }
    
    //- DepthMapの画像を取得
    int[] getDepthMap(){
        return oni.depthMap();
    }
    
    //- 映像の更新
    void update(){
        oni.update();
    }
}

