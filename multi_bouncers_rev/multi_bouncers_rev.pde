// 이동하고 변을 만나면 반사되는 원의 정보들을 저장하기 위한 클래스
// 여러개이기 때문에 [] 배열 (array) 의 형태로 사용.
Bouncer bs[];

// 선분들의 정보를 담기 위한 클래스.
// 선분의 시작점, 끝점의 xy좌표를 가지고 있도록 만들었습니다.
Edge eds[];

// 원들의 개수
int bs_num = 10;

// 변들의 개수
int eds_num = 10;

void setup() {
  size(800, 800);
  strokeCap(MITER);
  blendMode(MULTIPLY);
  noFill();
  
  // bs_num 개수만큼의 Bouncer 클래스 오브젝트를 만든다.
  bs = new Bouncer[bs_num];
  for (int i=0; i<bs_num; i++) {
    bs[i] = new Bouncer();
  }
  
  // eds_num 개수만큼의 Edge 클래스 오브젝트를 만든다.
  eds = new Edge[eds_num];
  
  // eds_num에서 4를 빼주는 것은 창의 가장자리를 포함하기 위해서이다.
  for (int i=0; i<eds_num-4; i++) {
    
    // 각 변의 첫번째 점
    float x_1 = random(0,width);
    float y_1 = random(0,height);
    
    // 각 변의 두번째 점
    float x_2 = random(0,width);
    float y_2 = random(0,height);
    
    //선분의 시작점 끝점 입력.
    eds[i] = new Edge(x_1, y_1, x_2, y_2);
  }
  
  eds[eds_num-1] = new Edge(0,0,width,0);
  eds[eds_num-2] = new Edge(width,0,width,height);
  eds[eds_num-3] = new Edge(width,height,0,height); 
  eds[eds_num-4] = new Edge(0,height,0,0);
}

void draw() {
  background(255);
  
  //원 그려주고 원 관련 정보 계산
  for (int i=0; i<bs_num; i++) {
    bs[i].update();
  }
  
  // 마우스 위치
  stroke(255,0,0);
  ellipse(mouseX,mouseY,20,20);

  // 선분 그려주기
  strokeWeight(20);
  stroke(0);
  for (int i=0; i<eds_num-4; i++) {
    float x_1 = eds[i].x_1;
    float y_1 = eds[i].y_1;
    float x_2 = eds[i].x_2;
    float y_2 = eds[i].y_2;
    line(x_1, y_1, x_2, y_2);
  }
  
  
}
