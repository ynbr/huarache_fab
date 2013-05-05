int num=30;
int[] rx = new int[num];
int[] ry = new int[num];

void setup()
{
  PImage img = loadImage("socks.jpg");
  size(img.width, img.height);
  image(img, 0, 0);
 
  colorMode(HSB, 360, 1.0, 1.0);
  loadPixels();
  for (int y = 0; y < img.height; y+=20)
  {
    // 行の左端ピクセルの明度を入れておく
    float prevValue = brightness(img.pixels[y * img.width + 1]);
    for (int x = 1; x < img.width; x+=40)
    {
      // (x, y)ピクセルの明度を取り出す
      float curValue = brightness(img.pixels[y * img.width + x]);
      // 一つ前(左)ピクセルとの明るさの差(絶対値)を取る
      float value = abs(curValue - prevValue);
      if (value==0){
       num=30;
      }else{
        for (int i =0;i<1;  i++){
          rx[i]=x;
          ry[i]=y;
          println(ry[i]+", "+ rx[i]);
      }
      
      prevValue = curValue;
 }
      // 明るさの差(絶対値)を明度に設定
      pixels[y * img.width + x] = color(0, 0, value);

    }

  updatePixels();
  
  }
}


void draw(){
  colorMode(RGB);
  stroke(255,0,0);
  line(rx[13],ry[13],rx[13],ry[13]);
}
