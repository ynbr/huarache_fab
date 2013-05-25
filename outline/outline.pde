/*
できてること
- 右点左点の取得
- PDFとして出力
- 点を一つのラインとして出力

これからやること
- 切断する数の調整
- 画像から点の取得（今はp5上で描写）
*/

import processing.pdf.*;

//dpi size
int dpi = 72;
//paper size, mm
float px= 210 ;
float py= 297 ;
//inch to mm, inch = mm *0.03937
int xx= int(px*0.03937*dpi);
int yy= int(py*0.03937*dpi);

int start = 0;
int[] cutx = new int[700];
int[] cuty = new int[700];
int i = 0 ;
int xxx = 150;  //coordiantes of text

int ci = 33; //amout of slice
int cy = 0;  //
int ccy = 0;  //

void setup(){
  colorMode(RGB,100);
  size(xx, yy);
  beginRecord(PDF, "test1.pdf");
  background(255,255,255);
  strokeWeight(1);
  
  noSmooth();  //ギザギザ（二値化）
  fill(0,0,0);
  strokeJoin(MITER);
  beginShape();
    vertex(150, 100);
    vertex(100, 580);
    vertex(500, 550);
    vertex(450, 130);
   endShape();
  cy = yy / ci;
}


void draw(){
  if (start == 0){  //一回しか点を取らない
  loadPixels();
  for (int y = 0; y < height; y=y+10){
    // 行の左端ピクセルの明度を入れておく
    float prevValue = brightness(pixels[y * width + 1]);
    
    for (int x = 1; x < width; x++){
      // (x, y)ピクセルの明度を取り出す
      float curValue = brightness(pixels[y * width + x]);
      // 一つ前(左)ピクセルとの明るさの差(絶対値)を取る
      float value = abs(curValue - prevValue);

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
    textSize(12);
    strokeWeight(1);
    stroke(0,100,100);
    for (int i=0;i<601;i=i+10){
      line(0,i,600,i);
      line(i,0, i,600);
    }
    
    //setting drawing outline
      noFill();
      stroke(255,0,0);
      strokeWeight(3);
      strokeJoin(MITER);
      beginShape();
      
        ccy=cy - 1;
        
        //draw outline
        for(int j=1; j<80;j=j+2){
          vertex(cutx[j], cuty[j]);
        }
        for(int j=80; j>0; j=j-2){
          vertex(cutx[j], cuty[j]);
        }
        vertex(cutx[1], cuty[1]);
        
      endShape();
      /*write dots coordinates
        text(cutx[i]+","+cuty[i], 10, xxx);
        xxx = xxx +20;
      */
      
      endRecord();  //Saving file as a PDF
      //exit();
  }
}

