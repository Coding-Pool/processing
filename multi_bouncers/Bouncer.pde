class Bouncer {

  PVector pos; // 원의 위치
  PVector vel; // 원의 이동 속도
  float r; // 원의 반지름
  boolean collided = false; // 충돌 여부 확인 -> 아직 제대로 작동 안함!
  
  Bouncer() {
    r = 25;
    pos = new PVector(width*0.5, height*0.5);

    // 랜덤한 방향과 크기를 가지는 속도 벡터 생성
    float vel_mag = random(1, 4);
    float vel_angle = random(2*PI);
    vel = new PVector(cos(vel_angle)*vel_mag, sin(vel_angle)*vel_mag);
  }

  // 모든 변들의 위치와 자신의 위치를 대조해서 반사될지 여부를 판단하는 부분
  void check_edges() {

    // 변들과의 거리들 중 최소값을 구하기 위해 비교하기 위한 초기값 지정
    // 매우 큰 아무 값 지정
    float comp_l = width * 20.0;

    // 거리가 최소일 경우에 원에서 해당 선분으로 내린 
    // 수선의 발의 좌표를 저장하기 위한 변수
    float min_x = 0;
    float min_y = 0;
    
    for (int i=0; i<eds_num; i++) {
      
      // 이부분의 코드는 이전 예제를 참조해주세요 (아래 링크)
      // https://github.com/Coding-Pool/processing/blob/master/bouncer_line/bouncer_line.pde
      
      float A_x = eds[i].x_1;
      float A_y = eds[i].y_1;
      float B_x = eds[i].x_2;
      float B_y = eds[i].y_2;

      float P_x = pos.x;
      float P_y = pos.y;

      PVector AB = new PVector(B_x - A_x, B_y - A_y); // A->B 방향과 크기를 가진 벡터
      PVector AP = new PVector(P_x - A_x, P_y - A_y); // A->P 방향과 크기를 가진 벡터

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

      PVector N = new PVector(P_x-X.x, P_y-X.y);
      N.normalize(); //크기가 1인 수직벡터
      PVector D = new PVector(vel.x, vel.y);
      PVector ref = D.add( N.mult( -2 * (N.dot(D)) ) ); //반사되는 속도벡터

      if (dist(A_x, A_y, X.x, X.y) < dist(A_x, A_y, B_x, B_y) + r * 0.5 && 
        dist(B_x, B_y, X.x, X.y) < dist(A_x, A_y, B_x, B_y) + r * 0.5) {
        
        if ( comp_l > dist(X.x, X.y, P_x, P_y) ) {
          // 현재 확인하고 있는 선분과의 거리가 이전에 comp_l에
          // 저장된 값보다 작으면 해당 값을 comp_l에 기록합니다.
          comp_l = dist(X.x, X.y, P_x, P_y);
          // 더 작은 값을 찾았을 경우의 수선의 발의 좌표도 기록 -> 나중에 선분 그리기 위해서
          min_x = X.x;
          min_y = X.y;
        }
        
        if (dist(X.x, X.y, P_x, P_y) < r * 0.5) {
          if (!collided) { 
            collided = true; // 충돌했다!
            vel.x = ref.x;
            vel.y = ref.y;
          }
        } else {
          // 충돌하지 않은 상태로 돌아오는 것은 거리가 확보된 이후입니다.
          collided = false;
        }
      }
    }

    strokeWeight(10);
    stroke(0, 0, 255);
    // for구문 안에서 조건에 충족하는 점을 찾지 못했을 경우 0,0으로 직선이 그려지는 것 방지.
    if(min_x != 0 && min_y != 0){
      line(min_x, min_y, pos.x, pos.y);
    }
  }

  void update() {
    //--> 자신의 위치와 모든 변들의 위치를 비교해서 속도를 바꿀지 말지 결정.
    check_edges();
    pos.add(vel);
    strokeWeight(10);
    // 속도 그려주는 선
    stroke(255,0,0);
    line(pos.x,pos.y,pos.x+vel.x*20,pos.y+vel.y*20);
    // 원 그리기
    stroke(0);
    ellipse(pos.x, pos.y, r, r);
  }
}
