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

// 다각형을 그릴때 화면 중심을 기준으로 랜덤한 반지름을 뽑고,
// 그 반지름을 가지고 형태를 그려줄 것이기 때문에 
// 반지름의 값을 보관하기 위한 float array
float eds_r[];

void setup() {
  size(800, 800);
  strokeCap(MITER);
  
  // bs_num 개수만큼의 Bouncer 클래스 오브젝트를 만든다.
  bs = new Bouncer[bs_num];
  for (int i=0; i<bs_num; i++) {
    bs[i] = new Bouncer();
  }
  
  // eds_num 개수만큼의 Edge 클래스 오브젝트를 만든다.
  eds = new Edge[eds_num];
  // eds_num 개수만큼의 반지름 값을 담기위한 준비. float array 만들기.
  eds_r = new float[eds_num];

  // 랜덤한 반지름 값들 준비.
  for (int i=0; i<eds_num; i++) {
    eds_r[i] = random(80, width*0.5);
  }

  for (int i=0; i<eds_num; i++) {
    float angle = i * 2 * PI / eds_num;

    // 변을 처음 그려줄때, 닫힌 다각형을 그리려는 것이 목적이었기 때문에,
    // 한 변을 이루는 두개의 점들중 시작점은 이전 변의 끝점과 동일하고,
    // 끝점은 다음 변의 시작점과 동일해야한다.
    // 그래서 x_1, y_1은 현재 i 값에 해당하는 각과 반지름을 이용,
    // x_2, y_2는 i + 1 값에 해당하는 각과 반지름을 이용.

    float r_1 = eds_r[i];
    
    // 마지막 변의 경우 참조할수 있는 다음변이 없는데, 
    // 닫힌 다각형이 되려면 0번째와 같으면 되므로 0번째를 "다음변"으로 취급.
    // 변수 = (조건)? 참일 경우 값 : 거짓일 경우 값
    // 위와 같은 문법 구조.
    float r_2 = (i==eds_num-1)? eds_r[0] : eds_r[i+1];
   
    // 각 변의 첫번째 점
    float x_1 = width*0.5 + r_1 * cos(angle);
    float y_1 = height*0.5 + r_1 * sin(angle);
    // 각 변의 두번째 점
    float x_2 = width*0.5  + r_2 * cos(angle + 2 * PI / eds_num);
    float y_2 = height*0.5 + r_2 * sin(angle + 2 * PI / eds_num);
    
    //선분의 시작점 끝점 입력.
    eds[i] = new Edge(x_1, y_1, x_2, y_2);
  }
}

void draw() {
  background(255);
  
  //원 그려주고 원 관련 정보 계산
  for (int i=0; i<bs_num; i++) {
    bs[i].update();
  }

  // 선분 그려주기
  strokeWeight(20);
  for (int i=0; i<eds_num; i++) {
    float x_1 = eds[i].x_1;
    float y_1 = eds[i].y_1;
    float x_2 = eds[i].x_2;
    float y_2 = eds[i].y_2;
    line(x_1, y_1, x_2, y_2);
  }
}
