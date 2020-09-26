class Walker {
  int i_x;
  int i_y;

  int num_w;
  int num_h;

  Walker(int _num_w, int _num_h) {
    num_w = _num_w;
    num_h = _num_h;
    i_x = floor(random(_num_w));
    i_y = floor(random(_num_h));
  }

  void update() {
    int pick = floor(random(4)); // 0,1,2,3
    // 0 --> y + 1
    // 1 --> x + 1
    // 2 --> y - 1
    // 3 --> x - 1
    if (pick == 0) {
      // pick 내부의 조건문은 워커가 그리드 밖으로 벗어나는 것을
      // 막기위함인데, 지금 현재 코드가 적용된 방식은 별로 좋지 
      // 않습니다. 그 이유는, 화면 가장자리에 놓여있을때 화면 밖으로
      // 나가는 pick이 일어난 경우, 해당 pick은 무시되고
      // 다시 뽑혀야지만 이동이 가능하기 때문입니다.
      if (i_y != num_h-1) {
        i_y++;
      }
    } else if (pick == 1) {
      if (i_x != num_w-1) {
        i_x++;
      }
    } else if (pick == 2) {
      if (i_y != 0) {
        i_y--;
      }
    } else if (pick == 3) {
      if (i_x != 0) {
        i_x--;
      }
    }
  }
}
