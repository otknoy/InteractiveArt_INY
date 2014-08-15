
class Goast{
    //- 幽霊に加工した顔画像
    private PImage goastface;
    //- 幽霊の目画像
    private PImage goasteye;
    //- 幽霊マスク
    private PImage mask;
    //- 幽霊の座標
    private float[] goast_pos;
    //- 顔の座標(中心)
    private int[] face_pos;
    //- 左目の座標(中心)
    private float[] left_pos;
    private float[] left_pos_tar;
    private float[] left_pos_pre;
    //- 右目の座標(中心)
    private float[] right_pos;
    private float[] right_pos_tar;
    private float[] right_pos_pre;
    //- 顔画像の透明度カウント
    private float face_alp;
    //- 幽霊の視線目標座標
    private float[] eye_target;
    //- 視線目標の範囲
    private float target_range;
    //- 幽霊の視線移動量
    private float aim;
    //- 目の移動範囲
    private float aim_range;

    
    //- コンストラクタ
    Goast(){
        goastface = createImage(200, 200, ARGB);
        goasteye = loadImage("goasteye.png");
        goasteye.resize(20, 20);
        mask = loadImage("mask.png");
        goast_pos = new float[]{0, 0};
        face_pos = new int[2];
        left_pos = new float[2];
        right_pos = new float[2];
        left_pos_tar = new float[2];
        right_pos_tar = new float[2];
        left_pos_pre = new float[2];
        right_pos_pre = new float[2];
        face_alp = 0;
        eye_target = new float[]{0, 0};
        target_range = 300;
        aim = 0;
        aim_range = 15;
    }
    
    /*---------- 情報操作 ----------*/
    
    //- 幽霊の位置を更新
    void updateGoastPos(int left_border, int right_border){
        goast_pos[0] = random(left_border, right_border - goastface.width);
        goast_pos[1] = random(0, 100);
    }

    //- 視線目標座標の更新
    void updateTarget(Rectangle face){
        //- 顔領域の中心座標取得
        float face_x = face.x + face.width / 2;
        float face_y = face.y + face.height / 2;
        //- 幽霊の顔の中心の座標
        float goast_x = face_pos[0] + goast_pos[0];
        float goast_y = face_pos[1] + goast_pos[1];
        //- 幽霊の顔の中心と顔認識された顔の中心の距離
        float distance = dist(goast_x, goast_y, face_x, face_y);
        //- 幽霊と顔認識の位置との角度(ラジアン)
        float rad;
        if(goast_y >= face_y){
            rad = atan((goast_y - face_y) / abs(goast_x - face_x));
        }else{
            rad = atan(abs(goast_x - face_x) / (face_y - goast_y));
        }
        
        //- 距離を目の移動距離にマッピングする
        distance = map(distance, 0, target_range, 0, aim_range);
        if(distance > aim_range) distance = aim_range;
        
        //- 目の目標座標
        eye_target[0] = distance * sin(rad);
        eye_target[1] = distance * cos(rad);
        if(face_x < goast_x) eye_target[0] *= (-1);
        if(face_y < goast_y) eye_target[1] *= (-1);
        
        //- 目の視線移動量の初期化
        aim = 0;
        left_pos_pre[0] = left_pos_tar[0];
        left_pos_pre[1] = left_pos_tar[1];
        right_pos_pre[0] = right_pos_tar[0];
        right_pos_pre[1] = right_pos_tar[1];
    }    
    
    //- 幽霊の顔画像を表示する
    void outGoastFace(){
        if(goastface == null) return;

        //- 実際の目の位置
        left_pos_tar[0] = lerp(left_pos_pre[0], left_pos[0] + eye_target[0], aim);
        left_pos_tar[1] = lerp(left_pos_pre[1], left_pos[1] + eye_target[1], aim);
        right_pos_tar[0] = lerp(right_pos_pre[0], right_pos[0] + eye_target[0], aim);
        right_pos_tar[1] = lerp(right_pos_pre[1], right_pos[1] + eye_target[1], aim);
        if(aim < 0.957) aim += 0.033;
  
        //- 目の座標
        float[] leye = new float[]{left_pos_tar[0] + goast_pos[0], left_pos_tar[1] + goast_pos[1]};
        float[] reye = new float[]{right_pos_tar[0] + goast_pos[0], right_pos_tar[1] + goast_pos[1]};

        //- 幽霊の顔と目を描画
        tint(255, face_alp);
        image(goastface, goast_pos[0], goast_pos[1]);
        imageMode(CENTER);
        image(goasteye, leye[0], leye[1]);
        image(goasteye, reye[0], reye[1]);
        imageMode(CORNER);
        noTint();
      
        //- 透明度カウント
        if(face_alp < 100) face_alp += 0.5;
      
        //- 幽霊の視線目標の表示
//        ellipse(left_pos[0] + goast_pos[0] + eye_target[0], left_pos[1] + goast_pos[1] + eye_target[1], 20, 20);
//        ellipse(right_pos[0] + goast_pos[0] + eye_target[0], right_pos[1] + goast_pos[1] + eye_target[1], 20, 20);
      
//        rectMode(CENTER);
//        rect(face_pos[0] + goast_pos[0], face_pos[1] + goast_pos[1], 100, 100);
//        rectMode(CORNER);
//        ellipse(left_pos[0] + goast_pos[0], left_pos[1] + goast_pos[1], 20, 20);
//        ellipse(right_pos[0] + goast_pos[0], right_pos[1] + goast_pos[1], 20, 20);
    }
    
    //- 幽霊の顔画像を更新する
    void updateFace(int[] input, int[] depth, Rectangle face, Rectangle leye, Rectangle reye, int k_w, int k_h, int s_w, int s_h){
        //- 顔の中心の座標と大きさを取得
        float face_x = face.x + face.width / 2;
        float face_y = face.y + face.height / 2;
        float face_w = face.width;
        float face_h = face.height;
        //- 座標の位置合わせ(スクリーンサイズとキネクトの映像サイズが異なるので、その差をマッピングする)
        face_x = map(face_x, 0, s_w, 0, k_w);
        face_y = map(face_y, 0, s_h, 0, k_h);
        //- 同様に大きさもマッピングしておく
        face_w = face_w * k_w / s_w;
        face_h = face_h * k_h / s_h;
        
        //- 顔の中心の座標における深度を取得(異常な深度の取得を避けるために顔中心の周り j pixel 分の深度の平均を使う)
        int face_depth = 0;
        int depth_sum = 0;
        int pixel_num = 0;
        for(int j = 3; pixel_num < (j * 2 + 1) * (j * 2 + 1); pixel_num++){
            int x = int(face_x - j + (pixel_num % (j * 2 + 1)));
            int y = int(face_y + (int(pixel_num / (j * 2 + 1)) - j));
            depth_sum += depth[x + y * k_w];
        }
        //- 深度の平均値を保存
        face_depth = depth_sum / pixel_num;
        println("Face Depth = " + face_depth);
        
        //- 人物の背景を透過させた画像を作成
        PImage img = createImage(k_w, k_h, ARGB);
        img.loadPixels();
        for(int i = 0; i < input.length; i++){
            if(face_depth - 300 < depth[i] && depth[i] < face_depth + 300){
                img.pixels[i] = input[i];
            }else{
                img.pixels[i] = color(255, 255, 255, 100);
            }
        }
        img.updatePixels();
        
        //- 顔の周りだけトリミングする
        img = img.get(int(face_x - face_w), int((face_y - face_h / 2) - face_h / 1.5), int(face_w * 2), int(face_h * 2));
        //- リサイズしておく
        int img_w = img.width;
        int img_h = img.height;
        img.resize(goastface.width, goastface.height);
        //- 顔部分の画像を保存する
        goastface = img;
     
        //- 顔認識と目の位置をマッピングしておく
        face_pos[0] = int(face_w);
        face_pos[1] = int(face_h * 7 / 6);
        
        left_pos[0] = face_pos[0] - (face_x - map(leye.x, 0, s_w, 0, k_w));
        left_pos[1] = face_pos[1] - (face_y - map(leye.y, 0, s_h, 0, k_h));
        right_pos[0] = face_pos[0] + (map(reye.x, 0, s_w, 0, k_w) - face_x);
        right_pos[1] = face_pos[1] - (face_y - map(reye.y, 0, s_h, 0, k_h));
        
        face_pos[0] = int(map(face_pos[0], 0, img_w, 0, goastface.width));
        face_pos[1] = int(map(face_pos[1], 0, img_h, 0, goastface.height));
        
        left_pos[0] = left_pos_tar[0] = left_pos_pre[0] = map(left_pos[0], 0, img_w, 0, goastface.width);
        left_pos[1] = left_pos_tar[1] = left_pos_pre[1] = map(left_pos[1], 0, img_h, 0, goastface.height);
        right_pos[0] = right_pos_tar[0] = right_pos_pre[0] = map(right_pos[0], 0, img_w, 0, goastface.width);
        right_pos[1] = right_pos_tar[1] = right_pos_pre[1] = map(right_pos[1], 0, img_h, 0, goastface.height);
        
                
        //- ネガ処理しておく
        goastface.mask(mask);
        goastface.filter(INVERT); 
        
        //- 透明度カウントを初期化
        face_alp = 0;
    }
}
