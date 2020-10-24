class SpringNode {
  PVector pos;
  PVector vel;
  float ref_f = 4;
  
  SpringNode(int _i, int _num) {
    float angle = _i * 2 * PI / _num;
    float cx = width * 0.5 + 300 * cos(angle);
    float cy = height * 0.5 + 300 * sin(angle);
    pos = new PVector(cx,cy);
    vel = new PVector();
  }
  
  // F = KX
  void cal_force(PVector prev_node, PVector next_node){
    PVector prev_dir = new PVector(prev_node.x - pos.x, prev_node.y - pos.y);
    PVector next_dir = new PVector(next_node.x - pos.x, next_node.y - pos.y);
    
    float prev_dis = prev_dir.mag();
    float next_dis = next_dir.mag();
    
    float prev_X = spring_l - prev_dis;
    float next_X = spring_l - next_dis;
    
    float prev_F = - prev_X * spring_k;
    float next_F = - next_X * spring_k;
    
    prev_dir.normalize();
    next_dir.normalize();
    
    prev_dir.mult(prev_F);
    next_dir.mult(next_F);
    
    vel.add(prev_dir);
    vel.add(next_dir);
  }
  
  void reflect(){
    if(dist(pos.x,pos.y,mouseX,mouseY) < 200){
      PVector dir = new PVector(pos.x-mouseX,pos.y-mouseY);
      float mag = dir.mag();
      dir.setMag(ref_f);
      vel.add(dir);
    }
    
    if(pos.x < 0){
      vel.x += ref_f;
    }
    
    if(pos.x > width){
      vel.x -= ref_f;
    }
    
    if(pos.y < 0){
      vel.y += ref_f;
    }
    
    if(pos.y > height){
      vel.y -= ref_f;
    }
  }
  
  void update(){
    vel.limit(3);
    pos.add(vel);
  }
  
}
