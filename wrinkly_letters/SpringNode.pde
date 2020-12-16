class SpringNode {
  PVector pos; // 노드의 위치
  PVector vel; // 노드의 이동 속도
  PVector cen_f; // 안쓰고 있으니 신경쓰지 말 것.
  // 반사되는 힘의 크기 계산할때 쓰려고 설정한 값. 
  // 실제 코드내에서는 여기다가 값을 곱해서 쓰고 있어서 큰 의미는 없음 
  float ref_f = 4;
  // 노드가 시작인지 끝인지, 중간일 경우 (중간일 경우는 안쓰는 것 같음)
  int is_strt_end;
  // 몇번째 패스인지
  int path_num;
  // 몇번째 점인지
  int num;

  SpringNode(float _x, float _y, int _start_end, int _p_num, int _num) {
    is_strt_end = _start_end;
    path_num = _p_num;
    num = _num;
    pos = new PVector(_x, _y);
    vel = new PVector();
    /*
    cen_f = new PVector(_x-width*0.5, _y-height*0.5);
   
    float cen_f_mag = cen_f.mag();
    float cen_f_n = noise(cos(cen_f.x / cen_f_mag), sin(cen_f.y / cen_f_mag)) * 25.0;
    
    cen_f.normalize();
    cen_f.mult(cen_f_n * 1.0 / (cen_f_mag + 0.01));
    */
  }

  // F = -KX 
  // 용수철로 연결되어 있다고 가정 (후크?의 법칙)
  void cal_force(PVector prev_node, PVector next_node) {
    //현재 점에서 이전점을 이은 벡터
    PVector prev_dir = new PVector(prev_node.x - pos.x, prev_node.y - pos.y);
    //현재 점에서 다음점을 이은 벡터
    PVector next_dir = new PVector(next_node.x - pos.x, next_node.y - pos.y);

    // 이전점, 다음점까지 거리
    float prev_dis = prev_dir.mag();
    float next_dis = next_dir.mag();

    // F = -KX 적용된 부분
    float prev_X = spring_l - prev_dis;
    float next_X = spring_l - next_dis;

    float prev_F = - prev_X * spring_k;
    float next_F = - next_X * spring_k;

    // 힘으로 쓰기 위해 크기 위에서 계산한 값으로 재조정
    prev_dir.normalize();
    next_dir.normalize();
    
    prev_dir.mult(prev_F);
    next_dir.mult(next_F);

    // 계산된 힘벡터를 더해주는 부분
    vel.add(prev_dir);
    vel.add(next_dir);
    
    // 현재점의 위치가 이전점과 다음점의 중점을 향해 이동하도록 설정
    // 결과적으로 전체가 더 곡선에 가까운 형태가 된다.
    // 이전 점과 다음 점을 클래스 전역에서 쓸 수 있는 변수에 배정하지 않아서
    // 여기에서 계산중 (코드 정리한다면 여기도 기능별로 맞는 함수 안에 옮기는게 좋을듯)
    pos.x += ((prev_node.x + next_node.x) * 0.5 - pos.x) * 0.5;
    pos.y += ((prev_node.y + next_node.y) * 0.5 - pos.y) * 0.5;
  }

  void reflect() {
    
    // 마우스 주변에 있는 점들에 작용하는 척력
    if (dist(pos.x, pos.y, mouseX, mouseY) < 50) {
      PVector dir = new PVector(pos.x-mouseX, pos.y-mouseY);
      dir.setMag(ref_f);
      vel.add(dir);
    }
    
    
    // 선이 가능한 겹치지 않도록 하기 위해 점들끼리 밀어내게 함
    // 현재 점을 제외한 모든 점들과의 거리 확인, 일정 거리 아래의 경우 척력 작용
    for (int i=0; i<spn.size(); i++) {
      if (num != i && dist(spn.get(i).pos.x, spn.get(i).pos.y, pos.x, pos.y) < 10) {
        PVector ref_dir = new PVector(pos.x - spn.get(i).pos.x, pos.y - spn.get(i).pos.y);
        ref_dir.normalize();
        ref_dir.mult(ref_f * 4.0);
        vel.add(ref_dir);
      }
    }
      
    // 화면 가장자리에 도달했을 경우 반사되도록 하는 부분
    // 지금은 가운데로 몰리고 있어서 화면 가장자리에 도달하는 경우가 없음
    if (pos.x < 0) {
      vel.x += ref_f;
    }

    if (pos.x > width) {
      vel.x -= ref_f;
    }

    if (pos.y < 0) {
      vel.y += ref_f;
    }

    if (pos.y > height) {
      vel.y -= ref_f;
    }
  }

  void update() {
    // 화면 중앙으로 점점 응축되도록 설정하는 부분
    pos.x += (width * 0.5 - pos.x) * 0.004;
    pos.y += (height * 0.5 - pos.y) * 0.004;
    
    // 속도가 무한정 커지지 않도록 조정
    vel.limit(2.0);
    // 위치에 계산된 속도 더해주기.
    pos.add(vel);
  }
}
