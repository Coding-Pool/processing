class Walker {
  int i_x, i_y;
  int index;
  IntList pickList;
  boolean filled[];

  float c_x, c_y;
  float t_x, t_y;

  float ease = 0.2;

  int num_w, num_h;

  ArrayList<Point> trace;

  boolean is_finished = false;

  Walker(int _num_w, int _num_h) {
    num_w = _num_w + 1;
    num_h = _num_h + 1;

    pickList = new IntList();
    trace = new ArrayList<Point>();

    i_x = floor(random(_num_w));
    i_y = floor(random(_num_h));

    index = i_x + i_y * num_w;

    t_x = float(i_x);
    t_y = float(i_y);

    c_x = t_x;
    c_y = t_y;

    trace.add(new Point(t_x, t_y));

    filled = new boolean[num_w * num_h];
    for (int i=0; i< num_w * num_h; i++) {
      filled[i] = false;
    }

    filled[index] = true;
  }

  void check() {
    int up = - num_w;
    int right = 1;
    int down = num_w;
    int left = - 1;

    pickList.clear();

    if (i_x < num_w - 1) {
      if (!filled[index+right]) {
        pickList.append(right);
      }
    }

    if (i_x > 0) {
      if (!filled[index+left]) {
        pickList.append(left);
      }
    }

    if (i_y < num_h - 1) {
      if (!filled[index+down]) {
        pickList.append(down);
      }
    }

    if (i_y > 0) {
      if (!filled[index+up]) {
        pickList.append(up);
      }
    }
  }

  void pick() {
    int pick = floor(random(pickList.size()));
    index += pickList.get(pick);
    filled[index] = true; 
    t_x = index % num_w;
    t_y = floor( index / num_w );
  }

  void update() {
    if (dist(t_x, t_y, c_x, c_y) > 0.001) {
      c_x += (t_x - c_x) * ease;
      c_y += (t_y - c_y) * ease;
    } else {
      c_x = t_x;
      c_y = t_y;

      i_x = int(t_x);
      i_y = int(t_y);

      trace.add(new Point(t_x, t_y));

      check();
      if (pickList.size() > 0) {
        pick();
      } else {
        is_finished = true;
      }
    }
  }
}
