
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
  
  strokeJoin(ROUND);
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
  ellipse(wk.i_x * w + margin * 0.5, wk.i_y * h + margin * 0.5, 14, 14);
  
  noFill();
  strokeWeight(12);
  beginShape();
  for(int i=0; i<wk.trail.size(); i++){
    //trail에 있는 x,y 좌표는 0~num_w의 범위를 가지는 정수여서 현재 화면에
    //배치된 그리드에 맞게 위치값을 계산
    float tr_x = wk.trail.get(i).x * w + margin * 0.5;
    float tr_y = wk.trail.get(i).y * h + margin * 0.5;
    vertex(tr_x,tr_y);
  }
  vertex(wk.i_x * w + margin * 0.5, wk.i_y * h + margin * 0.5);
  endShape();
  
  wk.update();
}

void mousePressed(){
  //마우스를 클릭할때마다 새로운 목표지점 설정
  wk.pick_target();
}
