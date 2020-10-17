class Walker {
  int i_x;
  int i_y;

  int num_w;
  int num_h;
  
  ArrayList<PVector> pick = new ArrayList<PVector>();

  Walker(int _num_w, int _num_h) {
    num_w = _num_w;
    num_h = _num_h;
    i_x = floor(random(_num_w));
    i_y = floor(random(_num_h));
  }

  void update() {
    
    //--> 4가지 방향 만듦
    //left
    PVector lft = new PVector(-1,0);
    //up
    PVector up = new PVector(0,1);
    //right
    PVector rght = new PVector(1,0);
    //down
    PVector dwn = new PVector(0,-1);
    
    pick.clear();
    
    //--> IntList, ArrayList 등을 써서 4가지 방향에 대한 정보를 리스트에 저장
    //--> 특정 방향으로 이동이 가능한지 먼저 확인을 한 후,
    //--> List에 방향에 대한 정보를 더해줄지 말지 결정
    
    if(i_x < num_w){
      //--> right 방향 리스트에 추가
      pick.add(rght);
    }
    
    if(i_y < num_h){
      //--> up 방향 리스트에 추가
      pick.add(up);
    }
    
    if(i_x > 0){
      //--> left 방향 리스트에 추가
      pick.add(lft);
    }
    
    if(i_y > 0){
      //--> down 방향 리스트에 추가
      pick.add(dwn);
    }
    
    //--> List의 길이 만큼의 랜덤한 양의 정수 뽑기
    int rand = floor(random(pick.size()));
    
    //--> 위에서 뽑힌 숫자를 List에서 참조할 목차번호로 활용
    PVector dir = pick.get(rand);
    
    //--> 뽑힌 방향대로 이동. 
    i_x += dir.x;
    i_y += dir.y;
  }
}
