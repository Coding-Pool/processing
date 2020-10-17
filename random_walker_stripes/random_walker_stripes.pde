
int num_w = 5;
int num_h = 5;

float w;
float h;

float margin = 160;

Walker wk;

void setup() {
  size(800, 800);
  
  // 직사각형의 너비, 높이를 계산할때 여백을 빼고 계산한다.
  w = (width - margin) / num_w;
  h = (height - margin) / num_h;
  wk = new Walker(num_w, num_h);

  strokeCap(ROUND);
  strokeJoin(ROUND);
  
  //frameRate(5);
}

void draw() {
  background(255);
  strokeWeight(1.5);
  fill(255);
  /*
  for (int i=0; i<num_w * num_h; i++) {
    int i_x = i % num_w; // i를 num_w로 나눈 나머지.
    int i_y = floor( i / num_w ); // i를 num_w로 나눈 몫.
    // 여백의 절반만큼 옮겨주어야지 화면 중앙에 위치할 수 있다.
    rect(i_x * w + margin * 0.5, i_y * h + margin * 0.5, w, h);
  }
  */
  stroke(0);
  strokeWeight(10);
  for (int i=0; i<(num_w + 1) * (num_h + 1); i++) {
    int i_x = i % (num_w + 1); // i를 num_w로 나눈 나머지.
    int i_y = floor( i / (num_w + 1) ); // i를 num_w로 나눈 몫.
    if(wk.filled[i]==false) point(i_x * w + margin * 0.5, i_y * h + margin * 0.5);
  }

  if (!wk.is_finished) {
    wk.update();
  }else{
    wk = new Walker(num_w, num_h);
  }

  drawTrace();

  //fill(0);
  //ellipse(wk.c_x * w + margin * 0.5, wk.c_y * h + margin * 0.5, 12, 12);
}

void drawTrace() {
  int num_l = 5;
  float step = 0.1;
  noFill();
  strokeWeight(8.5);
  beginShape(LINES);
  for (int i=0; i<wk.trace.size()-1; i++) {
    //middle line
    vertex(wk.trace.get(i).x * w + margin * 0.5, wk.trace.get(i).y * h + margin * 0.5);
    vertex(wk.trace.get(i+1).x * w + margin * 0.5, wk.trace.get(i+1).y * h + margin * 0.5);

    PVector Dir = new PVector(wk.trace.get(i+1).x - wk.trace.get(i).x, wk.trace.get(i+1).y - wk.trace.get(i).y, 0);
    PVector Up = new PVector(0, 0, 1);
    PVector N = Dir.cross(Up);

    
    for (int j=1; j<num_l; j++) {
      PVector strt_N = (i<2)? new PVector(0, 0) : new PVector(wk.trace.get(i).x - wk.trace.get(i-1).x, wk.trace.get(i).y - wk.trace.get(i-1).y);
      PVector end_N = (i==wk.trace.size()-2)? new PVector(wk.trace.get(i+1).x - wk.t_x, wk.trace.get(i+1).y - wk.t_y) : new PVector(wk.trace.get(i+1).x - wk.trace.get(i+2).x, wk.trace.get(i+1).y - wk.trace.get(i+2).y); 

      strt_N.normalize();
      end_N.normalize();

      if (i>1) strt_N.add(new PVector(wk.trace.get(i).x - wk.trace.get(i+1).x, wk.trace.get(i).y - wk.trace.get(i+1).y));
      end_N.add(new PVector(wk.trace.get(i+1).x - wk.trace.get(i).x, wk.trace.get(i+1).y - wk.trace.get(i).y));

      if ((strt_N.x == 0 && strt_N.y == 0) || i==1) strt_N.add(N);
      if ((end_N.x == 0 && end_N.y == 0)) end_N.add(N);

      if (wk.is_finished && i==wk.trace.size()-2) end_N.set(N.x, N.y);

      strt_N.mult(j*step*N.dot(strt_N));
      end_N.mult(j*step*N.dot(end_N));

      vertex((wk.trace.get(i).x+strt_N.x) * w + margin * 0.5, (wk.trace.get(i).y+strt_N.y) * h + margin * 0.5);
      vertex((wk.trace.get(i+1).x+end_N.x) * w + margin * 0.5, (wk.trace.get(i+1).y+end_N.y) * h + margin * 0.5);

      vertex((wk.trace.get(i).x-strt_N.x) * w + margin * 0.5, (wk.trace.get(i).y-strt_N.y) * h + margin * 0.5);
      vertex((wk.trace.get(i+1).x-end_N.x) * w + margin * 0.5, (wk.trace.get(i+1).y-end_N.y) * h + margin * 0.5);

      if (j==num_l-1) {
        if (i==1) {
          vertex((wk.trace.get(i).x+strt_N.x) * w + margin * 0.5, (wk.trace.get(i).y+strt_N.y) * h + margin * 0.5);
          vertex((wk.trace.get(i).x-strt_N.x) * w + margin * 0.5, (wk.trace.get(i).y-strt_N.y) * h + margin * 0.5);
        }
        if (wk.is_finished && i==wk.trace.size()-2) {
          vertex((wk.trace.get(i+1).x+end_N.x) * w + margin * 0.5, (wk.trace.get(i+1).y+end_N.y) * h + margin * 0.5);
          vertex((wk.trace.get(i+1).x-end_N.x) * w + margin * 0.5, (wk.trace.get(i+1).y-end_N.y) * h + margin * 0.5);
        }
      }
    }
  }

  if (!wk.is_finished && wk.trace.size() > 1) {
    vertex(wk.trace.get(wk.trace.size()-1).x * w + margin * 0.5, wk.trace.get(wk.trace.size()-1).y * h + margin * 0.5);
    vertex(wk.c_x * w + margin * 0.5, wk.c_y * h + margin * 0.5);

    PVector Dir = new PVector(wk.t_x - wk.trace.get(wk.trace.size()-1).x, wk.t_y - wk.trace.get(wk.trace.size()-1).y, 0);
    Dir.normalize();
    PVector Up = new PVector(0, 0, 1);
    PVector N = Dir.cross(Up);

    for (int j=1; j<num_l; j++) {
      PVector strt_N = new PVector(wk.trace.get(wk.trace.size()-1).x - wk.trace.get(wk.trace.size()-2).x, wk.trace.get(wk.trace.size()-1).y - wk.trace.get(wk.trace.size()-2).y);
      PVector end_N = new PVector(0, 0); 
      
      PVector tmp = new PVector(wk.trace.get(wk.trace.size()-1).x - wk.c_x, wk.trace.get(wk.trace.size()-1).y - wk.c_y);
      
      strt_N.add(tmp.normalize());
      
      if ((strt_N.x == 0 && strt_N.y == 0) || wk.trace.size() < 3){ 
        strt_N.set(N);
      }
      end_N.add(N);

      strt_N.mult(j*step*N.dot(strt_N));
      end_N.mult(j*step*N.dot(end_N));

      vertex((wk.trace.get(wk.trace.size()-1).x+strt_N.x) * w + margin * 0.5, (wk.trace.get(wk.trace.size()-1).y+strt_N.y) * h + margin * 0.5);
      vertex((wk.c_x+end_N.x) * w + margin * 0.5, (wk.c_y+end_N.y) * h + margin * 0.5);

      vertex((wk.trace.get(wk.trace.size()-1).x-strt_N.x) * w + margin * 0.5, (wk.trace.get(wk.trace.size()-1).y-strt_N.y) * h + margin * 0.5);
      vertex((wk.c_x-end_N.x) * w + margin * 0.5, (wk.c_y-end_N.y) * h + margin * 0.5);
      
      if (j==num_l-1) {
        if(wk.trace.size()<3){
          vertex((wk.trace.get(wk.trace.size()-1).x+strt_N.x) * w + margin * 0.5, (wk.trace.get(wk.trace.size()-1).y+strt_N.y) * h + margin * 0.5);
          vertex((wk.trace.get(wk.trace.size()-1).x-strt_N.x) * w + margin * 0.5, (wk.trace.get(wk.trace.size()-1).y-strt_N.y) * h + margin * 0.5);
        }
        vertex((wk.c_x+end_N.x) * w + margin * 0.5, (wk.c_y+end_N.y) * h + margin * 0.5);
        vertex((wk.c_x-end_N.x) * w + margin * 0.5, (wk.c_y-end_N.y) * h + margin * 0.5);
      }
    }
  }

  endShape();
}
