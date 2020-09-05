//
/*
1. 원 그리기
2. 원 움직이기 
  2-1. 원이 화면 중앙에서 시작
  2-2. 무작위한 방향으로 이동 -> 360도의 방향중 하나 선택
3. 원이 이동을 하다가 화면 가장자리에 이르면 진행경로에 따라서 반사되어나온다.
  3-1. 원의 위치가 화면 가장자리에 이르렀을때 -> cx의 경우 0보다 작아지거나 width보다 커지는 경우
  3-2. vx의 경우에는 위와 같은 조건일때 진행하던 것과 반대방향으로 이동을 해야한다. -> vx에 -1 곱해준다. 
*/
float cx;
float cy;
float R = 100;

float vx;
float vy;

void setup(){
  size(600,600);
  cx = width/2;
  cy = height/2;
  
  // 360도는 degree이고 여기에서는 radian 단위를 쓰는데,
  // 2 * PI는 360도와 동일합니다.
  // PI 는 원주율로, 3.1415..... 식으로 영원히 이어집니다.
  float angle = random(2 * PI);
  float r = 3;
  vx = r * cos(angle);
  vy = r * sin(angle);

}

void draw(){
  background(255);
  
  // x축과 방향이 일치하는 벽을 만났을때, 
  // 속도의 x 성분에 -1을 곱해줍니다.
  if(cx < R * 0.5 || cx > width - R * 0.5){
    vx = vx * -1;
  }
  
  if(cy < R * 0.5 || cy > height - R * 0.5){
    vy = vy * -1;
  }
  
  cx = cx + vx;
  cy = cy + vy;
  
  strokeWeight(20);
  ellipse(cx,cy,R,R);
}
