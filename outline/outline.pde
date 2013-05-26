/*
できてること
- 右点左点の取得
- PDFとして出力
- 点を一つのラインとして出力
- 切断する数の調整

これからやること
- 画像から点の取得（今はp5上で描写）
*/

import processing.pdf.*;
PImage img;

//dpi size
int dpi = 72;
//paper size, mm
float px= 210 ;
float py= 297 ;
//inch to mm, inch = mm *0.03937
int xx= int(px*0.03937*dpi);
int yy= int(py*0.03937*dpi);

int start = 0;
int[] cutx = new int[9000];
int[] cuty = new int[7000];
int i = 0 ;
int xxx = 150;  //coordiantes of text

int ci = 10; //amout of slice
int cy = 0;  //pixel between lines
int ccy = 0;

int ry = 0;  // axisline
int rx = 0;


void setup(){
  colorMode(RGB,100);
  size(xx, yy);
  background(255,255,255);
  strokeWeight(1);
  
  //次はここから、画像を読み込み
  img = loadImage("sample3.png");
  image(img, 0, 0);
  filter(THRESHOLD, 1);
  //
  
  beginRecord(PDF, "test1.pdf");
  
  /*
  noSmooth();  //ギザギザ（二値化）
  fill(0,0,0);
  noStroke(); 
  strokeJoin(MITER);
  beginShape();
    vertex(150, 100);
    vertex(100, 680);
    vertex(500, 550);
    vertex(450, 130);
   endShape();
   */
   
   cy = yy / ci;
   println(cy);
  
}


void draw(){
  if (start == 0){  //一回しか点を取らない
  loadPixels();
  for (int y = 0; y < height; y++){
    // 行の左端ピクセルの明度を入れておく
    float prevValue = brightness(pixels[y * width + 1]);
    for (int x = 1; x < width; x++){
      // (x, y)ピクセルの明度を取り出す
      float curValue = brightness(pixels[y * width + x]);
      // 一つ前(左)ピクセルとの明るさの差(絶対値)を取る
      float value = abs(curValue - prevValue);
// println(value);
      if(value==0){
        }else{
          i++;
          cutx[i] = x;  //点の座標を取得
          cuty[i] = y;  //点の座標を取得
        }
      
      prevValue = curValue;
    }
  }
  
  updatePixels();
  start = 1;
//  background(255,255,255);  //clear rect
  }else{
    
    //方眼用紙
    strokeWeight(1);
    stroke(0,100,100);
    rx = cutx[1] - 2 * cy;
    ry = cuty[1] - 2 * cy;
    
    for (int i=0;i<yy;i=i+cy){
      line(0,ry + i,xx,ry +i);
      line(rx + i,0, rx + i,yy);
    }
    
    //setting drawing outline
      noFill();
      stroke(255,0,0);
      strokeWeight(3);
      strokeJoin(MITER);
      beginShape();
      
        ccy = cy*2;
        
        //draw outline
        for(int j=1; j<1050;j=j+ccy){
          vertex(cutx[j], cuty[j]);
        }
        for(int j=1050; j>0; j=j-ccy){
          vertex(cutx[j], cuty[j]);
        }
        vertex(cutx[1], cuty[1]);
        
      endShape();
      /*write dots coordinates
      textSize(16);
      text(yy, 100, 50);
      text(xx, 100, 100);
      text(cutx[i]+","+cuty[i], 10, xxx);
      xxx = xxx +20;
      */
      
      
      
      //exit();
  }
}

void keyPressed(){
  if (key == 's'){  //Key press "s"
    endRecord();  //Saving file as a PDF
  }
}

