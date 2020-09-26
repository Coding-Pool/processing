
int num_w = 5;
int num_h = 5;

float w;
float h;

float margin = 160;

Walker wk;

void setup(){
  size(800,800);
  // 직사각형의 너비, 높이를 계산할때 여백을 빼고 계산한다.
  w = (width - margin) / num_w;
  h = (height - margin) / num_h;
  wk = new Walker(num_w, num_h);
}

void draw(){
  background(255);
  strokeWeight(2);
  fill(255);
  for(int i=0; i<num_w * num_h; i++){
    int i_x = i % num_w; // i를 num_w로 나눈 나머지.
    int i_y = floor( i / num_w ); // i를 num_w로 나눈 몫.
    // 여백의 절반만큼 옮겨주어야지 화면 중앙에 위치할 수 있다.
    rect(i_x * w + margin * 0.5, i_y * h + margin * 0.5, w, h);
  }
  
  fill(0);
  ellipse(wk.i_x * w + margin * 0.5, wk.i_y * h + margin * 0.5, 12, 12);
}

void mousePressed(){
  //마우스를 클릭할때마다 이동합니다.
  wk.update();
}
