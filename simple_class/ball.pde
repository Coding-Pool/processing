class ball {

  PVector pos;
  PVector vel;
  float R;
  
  float col_r, col_g, col_b; // 이런 식의 변수 선언도 가능합니다

  // 이부분이 셋업 비슷한것인데, 클래스의 이름과 반드시 동일하게 적어주어야 합니다.
  ball() {
    R = random(12,50);
    float px = random(R * 0.5, width - R * 0.5);
    float py = random(R * 0.5, height - R * 0.5);
    
    // 이 부분은 이전에도 다뤘던 랜덤한 방향의 랜덤한 크기의 속도를 만들어주는 부분입니다.
    float speed_angle = random(2 * PI);
    float speed_mag = random(4);
    float vx = speed_mag * cos(speed_angle);
    float vy = speed_mag * sin(speed_angle);
    pos = new PVector(px, py);
    vel = new PVector(vx, vy);
    
    //이부분은 스터디때 안했는데, 색도 랜덤하게 뽑아보도록 하죠.
    col_r = random(255);
    col_g = random(255);
    col_b = random(255);
  }
  
  // 클래스 내에서 설정한 값들을 업데이트하기 위한 함수
  // 임의로 아무 이름으로 지어도 상관없습니다.
  void update() {
    
    if (pos.x < R * 0.5 || pos.x > width - R * 0.5) {
      vel.x *= -1;
    }

    if (pos.y < R * 0.5 || pos.y > height - R * 0.5) {
      vel.y *= -1;
    }
    
    pos.add(vel);
  }

  // 클래스 내부의 값을 기반으로 그림을 그리는 부분
  void display() {
    //선 색과 칠 색 간단하게 바꿔봤어요!
    stroke(255-col_r, 255-col_g, 255-col_b); // 칠 색 반전
    fill(col_r,col_g,col_b);
    ellipse(pos.x, pos.y, R, R);
  }
}
