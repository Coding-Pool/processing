class Bouncer {

  float cx, cy;
  PVector vel;
  float force_acc = 1.5;

  Bouncer() {
    cx = width/2;
    cy = height/2;

    float random_angle = random(2 * PI);
    vel = new PVector(force_acc * cos(random_angle), force_acc * sin(random_angle));
  }

  void update(float pol_x[], float pol_y[]) {

    // https://stackoverflow.com/questions/5227num7num/minimal-perpendicular-vector-between-a-point-and-a-line

    float norm_x = width;
    float norm_y = height;

    float min_x = 0;
    float min_y = 0;

    for (int i=0; i<num; i++) {
      float x1 = pol_x[i];
      float y1 = pol_y[i];

      float x2 = (i!=num-1)? pol_x[i+1] : pol_x[0];
      float y2 = (i!=num-1)? pol_y[i+1] : pol_y[0];

      PVector D = new PVector(x2 - x1, y2 - y1);
      PVector P = new PVector(cx, cy);
      PVector A = new PVector(x1, y1);
      PVector X = new PVector();

      D.normalize();

      //caution! when you assign P.sub(A), the value of P also gets manipulated
      PVector P_A =  P.sub(A);
      float P_A_dot_D = P_A.dot(D);
      X = A.add(D.mult(P_A_dot_D));
      PVector norm = new PVector(cx, cy).sub(X);
      //insure that the closest edge is used
      if (dist(X.x, X.y, x1, y1) <= dist(x1, y1, x2, y2) &&
        dist(X.x, X.y, x2, y2) <= dist(x1, y1, x2, y2)) {
        if (norm.mag() < dist(norm_x, norm_y, 0, 0)) {
          norm_x = norm.x;
          norm_y = norm.y;
          min_x = X.x;
          min_y = X.y;
        }
      }
    }

    PVector min_norm = new PVector(norm_x, norm_y);

    if (min_norm.mag() < r * 0.1) {
      //https://math.stackexchange.com/questions/1num261/how-to-get-a-reflection-vector
      min_norm.normalize();
      vel.sub(min_norm.mult(2 * vel.dot(min_norm)));
    }

    cx += vel.x;
    cy += vel.y;

    float speed_bar = 10;
    stroke(255, 0, 0);
    line(min_x, min_y, cx, cy);
    line(cx, cy, cx+vel.x*speed_bar, cy+vel.y*speed_bar);
    stroke(0);
  }

  void display() {  
    ellipse(cx, cy, r, r);
  }
}
