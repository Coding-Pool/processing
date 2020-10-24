
SpringNode spn[];
int num = 100;

float spring_k = 0.5;
float spring_l = 20;

void setup(){
  size(800,800); 
  spn = new SpringNode[num];
  for(int i=0; i<spn.length; i++){
    spn[i] = new SpringNode(i, num);
  }
  
  strokeJoin(BEVEL);
}

void draw(){
  background(255);
  
  for(int i=0; i<spn.length; i++){
    PVector prev = (i==0)? spn[spn.length-1].pos : spn[i-1].pos;
    PVector next = (i==spn.length-1)? spn[0].pos : spn[i+1].pos;
    spn[i].cal_force(prev,next);
    spn[i].reflect();
    spn[i].update();
  }
  
  noFill();
  strokeWeight(2);
  beginShape();
  for(int i=0; i<spn.length; i++){
    float x = spn[i].pos.x;
    float y = spn[i].pos.y;
    vertex(x, y);
  }
  endShape(CLOSE);
}
