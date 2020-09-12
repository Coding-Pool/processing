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

int count = 0; // 일정한 주기로 선분의 위치를 바꿔줄게요.
boolean collided = false; 
// 선과의 거리가 갑자기 속도의 방향이 반사되는 조건의 범위내에 들 경우,
// 계속 반사되어 엄청 빠르게 고개를 돌리는 듯한 현상이 있었는데요
// 한번 반사된 경우, 다시 어느정도 거리가 확보되기전까지는 반사가 일어나지 않도록 만들었습니다.

void setup(){
  size(600,600);
  strokeCap(BEVEL);
  
  P_x = width/2;
  P_y = height/2;
  
  float angle = random(2 * PI);
  float r = 2;
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
  
  // 매 프레임별로 count 값을 업데이트 시켜주고,
  // count가 일정 값보다 커지면 다시 값을 0으로 바꿔준다음
  // AB 값을 업데이트 합니다.
  count++;
  if(count > 200){
    A_x = random(width);
    A_y = random(height);
  
    B_x = random(width);
    B_y = random(height);
    AB.set(B_x - A_x, B_y - A_y);
    count = 0;
  }
  
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
  
  // println(XP.mag()); 
  
  // ref = D - 2 * (N 내적 D) * N
  // N이 선분 AB에 대한 수직벡터.
  // D가 입사되는 속도벡터
  // ref이 반사되는 속도벡터
  // D를 N에 대해 각각 수직이고 평행인 벡터로 분해시켰다고 가정할때,
  // N과 수직인 성분은 그대로 두고, 평행인 성분을 거꾸로 뒤집어주면 (수직벡터와 같은 방향으로 맞춰주는 것) 반사됩니다.
  // 평행인 성분을 뒤집어주기 위해, 위의 공식은 평행인 성분과 방향은 반대이면서 크기가 2배인 벡터를 더해줍니다.
  // N과 평행인 D의 성분을 D 벡터에서 분리해내기 위해 위에서 내적을 썼던 방식과 비슷하게
  // D와 N의 내적 값으로 평행한 벡터의 크기를 구하고,
  // 그것을 N에 곱해서 방향을 부여합니다.
  // 하지만 여기서 D와 N의 사잇각이 둔각이어서 현재 상태로는 수직벡터와 같은 방향이 아닙니다.
  // -1 을 곱해주고, 더해주었을때 반대 방향으로 같은 크기과 되도록 2를 곱해줍니다.
  // 위까지 계산한 내용을 D에 그대로 더해주면 반사되는 속도 벡터를 얻을 수 있습니다.
  PVector N = XP; // XP에 바로 normalize()를 적용하면 아래 조건문에서 값을 쓸 수 없어서
  N.normalize(); //크기가 1인 수직벡터
  PVector D = new PVector(vx, vy);
  PVector ref = D.add( N.mult( -2 * (N.dot(D)) ) );
  
  // 원래는 조건문에서 XP 값을 직접 쓰려고 했는데, 위에서 XP를 만든 직후랑
  // N에 넘겨주고 N을 가지고 연산을 한 이후랑 값이 다르네요
  // println(XP.mag());
  
  // println(dist(X.x,X.y,P_x,P_y));
  
  if(dist(X.x,X.y,P_x,P_y) < R * 0.5){
    //여기는 X->P의 크기가 일정 크기보다 작아졌을 경우에 실행되는 코드
    //즉 선분에 대해 반사되는 속도를 계산하는 코드가 들어가야합니다.
    
    //직선 AB가 아니라 선분 AB에 반사되도록.
    //진선 AB에 투영된 점X
    // AX 크기, BX 크기 둘다 선분 AB의 길이보다 작을 경우
    // A-------X---------------B
    // X-------A---------------B
    // A---------------B-------X
    // 위의 세가지 상황을 상상하면 이해하기 편할 것 같아요.
    // R이 더해진 이유는 원의 중심은 범위내에 없지만,
    // 원의 가장자리가 닿는 경우를 잡으려고 넣었어요.
    if(dist(A_x,A_y,X.x,X.y) < dist(A_x,A_y,B_x,B_y) + R * 0.5 && 
    dist(B_x,B_y,X.x,X.y) < dist(A_x,A_y,B_x,B_y) + R * 0.5){
      // 이 조건문 안의 코드는 충돌하지 않았을 경우에만 실행
      if(!collided){ 
        collided = true; // 충돌했다!
        vx = ref.x;
        vy = ref.y;
      }
    }
  }else{
    // 충돌하지 않은 상태로 돌아오는 것은 거리가 확보된 이후입니다.
    collided = false;
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
  if(dist(A_x,A_y,X.x,X.y) < dist(A_x,A_y,B_x,B_y) && 
    dist(B_x,B_y,X.x,X.y) < dist(A_x,A_y,B_x,B_y)){
    stroke(255,0,0);
    line(X.x,X.y,P_x,P_y);
  }
  stroke(0);
  ellipse(P_x,P_y,R,R);
  line(A_x,A_y,B_x,B_y);
  
  //속도벡터를 그려주는 선이에요
  stroke(0,0,255);
  //속도벡터를 그려줄때 크기를 조절하기 편하게 크기가 1인 벡터로 바꾸어줄거에요
  float v_mag = sqrt(vx * vx + vy * vy);
  line(P_x,P_y,P_x + (vx/v_mag) * (R * 0.5 + 20),P_y + (vy/v_mag) * (R * 0.5 + 20));
}
