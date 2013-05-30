import processing.pdf.*;
import controlP5.*;

ControlP5 cp5;
int myColor = color(0,0,0);

int amountDivision = 100;
int bottomLine = 1050;
int sliderTicks1 = 100;
int sliderTicks2 = 30;
Slider abc;

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

int rec = 0;  //a switch to export PDF
int num = 0;  //a number of file

void setup(){
  colorMode(RGB,100);
  size(xx, yy);
  background(0,0,0);
  noStroke();
  fill(0,0,0);
  rect(0,0,xx,100);
  
  cp5 = new ControlP5(this);
  cp5.addSlider("amountDivision")
   .setPosition(100,30)
   .setRange(5,100)
  ;
   
   cp5.addSlider("bottomLine")
   .setPosition(100,50)
   .setRange(100,1200);
  
  strokeWeight(1);
  
  
  //次はここから、画像を読み込み
  img = loadImage("sample2.png");
  image(img, 0, 100);
  filter(THRESHOLD, 1);
  //
   
   cy = yy / ci;
  
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
  
  }else{
    //方眼用紙
    strokeWeight(1);
    stroke(0,100,100);
    
    cy = amountDivision;
    rx = cutx[1] - 2 * cy;
    ry = cuty[1] - 2 * cy;
   
    for (int i=0;i<yy;i=i+cy){
      line(0,ry + i,xx,ry +i);
      line(0,ry - i,xx,ry -i);
      line(rx + i,0, rx + i,yy);
      line(rx - i,0, rx - i,yy);
    }

    
    //setting drawing outline
      noFill();
      stroke(255,0,0);
      strokeWeight(3);
      strokeJoin(MITER);
      beginShape();
      
        ccy = cy * 2;
        
        //draw outline
        for(int j=1; j<bottomLine;j=j+ccy){
          vertex(cutx[j], cuty[j]);
        }
        for(int j=bottomLine; j>0; j=j-ccy){
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
      
      if (rec == 1){
          beginRecord(PDF, "test"+num+".pdf");
          //setting drawing outline
          noFill();
          stroke(255,0,0);
          strokeWeight(3);
          strokeJoin(MITER);
          beginShape();
      
          ccy = cy*2;
        
          //draw outline
          for(int j=1; j<bottomLine;j=j+ccy){
            vertex(cutx[j], cuty[j]);
          }
          for(int j=bottomLine; j>0; j=j-ccy){
            vertex(cutx[j], cuty[j]);
          }
          vertex(cutx[1], cuty[1]);
        
          endShape();
          endRecord();
          rec = 0;
          num++ ;
       }

  }
}


void mouseDragged() {
    background(255,255,255);
    noStroke();
    fill(0,0,0);
    rect(0,0,width,100);

}

void mouseReleased() {
    background(255,255,255);
    img = loadImage("sample2.png");
    image(img, 0, 100);
    filter(THRESHOLD, 1);
    noStroke();
    fill(0,0,0);
    rect(0,0,width,100);
}

void keyPressed(){
  if (key == 's'){  //Key press "s"
    rec = 1;
    //endRecord();  //Saving file as a PDF
  }
}
