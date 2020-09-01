//draw ellipse moving in a polygon

float pol_x[];
float pol_y[];

int num = 20;

float r = 10;

Bouncer bcr[];

int bcr_num = 10;

void setup() {
  size(800, 800);
  strokeWeight(2.0);
  pixelDensity(displayDensity());
  smooth();
  strokeJoin(BEVEL);
  randomSeed(4);
  pol_x = new float[num];
  pol_y = new float[num];
  for (int i=0; i<num; i++) {
    float rand_r = random(50, 400);
    pol_x[i] = width/2 + rand_r * cos(i*2*PI/num);
    pol_y[i] = height/2 + rand_r * sin(i*2*PI/num);
  }

  bcr = new Bouncer[bcr_num];
  for (int i=0; i<bcr_num; i++) {
    bcr[i] = new Bouncer();
  }
}

void draw() {
  background(255);

  stroke(0);
  beginShape();
  for (int i=0; i<num; i++) {
    vertex(pol_x[i], pol_y[i]);
  }
  endShape(CLOSE);

  fill(255);
  for (int i=0; i<bcr_num; i++) {
    bcr[i].update(pol_x, pol_y);
    bcr[i].display();
  }
  
  //saves frames to to "capture" folder.
  //if there is no such directory in the same hierachy as the pde file,
  //this code will create a new directory
  /*
  saveFrame("capture/#####.jpg");
  if(frameCount > 2400){
   exit();
  }
  */
}
