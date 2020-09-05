//
/*
1. 원 그리기
2. 원 움직이기 
  2-1. 원이 화면 중앙에서 시작
  2-2. 무작위한 방향으로 이동 -> 360도의 방향중 하나 선택
3. 원이 이동을 하다가 화면 가장자리에 이르면 진행경로에 따라서 반사되어나온다.
  3-1. 원의 위치가 화면 가장자리에 이르렀을때 -> P_x의 경우 0보다 작아지거나 width보다 커지는 경우
  3-2. vx의 경우에는 위와 같은 조건일때 진행하던 것과 반대방향으로 이동을 해야한다. -> vx에 -1 곱해준다. 
*/

/*
1. 선분을 그린다.
2. 원이 선분과 닿았을 경우 진행경로가 반사된다.
3. 선분의 시작점에 끝점까지 이어지는 벡터
4. 선분의 시작점에서 원의 위치까지 이어지는 벡터
*/

float P_x; // P
float P_y;
float R = 100;

float vx; // 여기의 두 변수가 x방향의 속도와 y방향의 속도를 보관합니다.
float vy;

float A_x; // A
float A_y;

float B_x; // B
float B_y;

PVector AB; // 선분벡터
PVector AP; // 선분의 시작점과 원의 중심을 이은 벡터

void setup(){
  size(600,600);
  strokeCap(BEVEL);
  
  P_x = width/2;
  P_y = height/2;
  
  float angle = random(2 * PI);
  float r = 3;
  vx = r * cos(angle);
  vy = r * sin(angle);
  
  // 선분을 구성하는 두점의 위치를 무작위하게 뽑는다.
  A_x = random(width);
  A_y = random(height);
  
  B_x = random(width);
  B_y = random(height);
  
  AB = new PVector(B_x - A_x, B_y - A_y); // A->B 방향과 크기를 가진 벡터
  AP = new PVector(P_x - A_x, P_y - A_y); // A->P 방향과 크기를 가진 벡터
  //AP 벡터 방향이 잘못 계산되어있었는데 지적해주셔서 감사합니다!
}

void draw(){
  background(255);
  
  // A->P의 경우, P의 값이 매번 바뀌기 때문에 새로 업데이트 
  AP.set(P_x - A_x, P_y - A_y); 
  
  // A->P 벡터를 A->B벡터위에 내적을 이용해
  // 투영 (저는 수직으로 내려서 A->B위에 A->P의 그림자가 진다고 상상합니다)
  // 투영을 하기 위해서는 A->B의 크기가 1이 되어야한다.
  // 위의 가정에 대한 근거는 내적의 정의 ||AP|| * ||AB|| * cos(theta) 에서 찾을 수 있다.
  // 위에서 ||AP|| 는 벡터 ||AP||의 길이 (선분 AP의 길이와 동일합니다.) 이고,
  // theta는 A->P와 A->B사이의 사잇각입니다.
  // 다시 ||AP|| * ||AB|| * cos(theta) 로 돌아와서, ||AB||의 값이 1이라고 가정한다면,
  // ||AP|| * cos(theta) 가 되고, 이는 점 P에서 선분 AB로 내린 수선의 발?이 X라고 가정할때,
  // 선분 AP, AX, XP 세 개의 변을 가지는 직각삼각형에서 (theta는 여기서 AP와 AX의 사잇각)
  // (||AP|| * cos(theta)의 값은) 선분 AX의 길이가 됩니다. 
  
  AB.normalize(); //A->B를 방향은 일정하되 크기는 1인 벡터로 바꾸어줍니다.
  
  // AX의 길이를 구하기 위해 크기가 1이된 A->B 와 그대로인 A->P의 내적값을 구해줍니다.
  float AX_length = AP.dot(AB);
  // 점 A의 위치를 이용하기 위해 새로 만들어줍니다.
  PVector A = new PVector(A_x, A_y);
  // A + AB * AX_length 라고 생각하면 되고, 이는 두가지 부분으로 나누어 생각할 수 있습니다.
  // AB * AX_length 는 A->B 와 방향은 같되 크기가 AX와 동일한 벡터, 즉 A->X 벡터가 됩니다.
  // A->X 벡터를 A에 더해주면 X의 좌표를 구할 수 있습니다.
  PVector X = A.add(AB.mult(AX_length));
  // X->P 가 저희가 AB와 P사이 거리를 판단하기 위해 필요한 벡터입니다. 
  PVector XP = new PVector(P_x-X.x, P_y-X.y);
  
  if(XP.mag() < R * 0.5){
    //여기는 X->P의 크기가 일정 크기보다 작아졌을 경우에 실행되는 코드
    //즉 선분에 대해 반사되는 속도를 계산하는 코드가 들어가야합니다.
  }
  
  if(P_x < R * 0.5 || P_x > width - R * 0.5){
    vx = vx * -1;
  }
  
  if(P_y < R * 0.5 || P_y > height - R * 0.5){
    vy = vy * -1;
  }
  
  P_x = P_x + vx;
  P_y = P_y + vy;
  
  strokeWeight(20);
  stroke(255,0,0);
  line(X.x,X.y,P_x,P_y);
  stroke(0);
  ellipse(P_x,P_y,R,R);
  line(A_x,A_y,B_x,B_y);
}
