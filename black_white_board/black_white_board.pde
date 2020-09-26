//흑백이 교차되며 반복되는 정사각 그리드

int num = 102;
float w;

void setup() {
  size(600, 600);
  background(255);
  // 여기서 정사각형 하나의 너비를 계산할때, 
  // int 인 width와 num을 float로 바꾸어주지 않으면
  // 스터디 세션에서 경험했던 것처럼 딱 떨어지는 숫자가
  // 아닐 경우 오차가 (크게) 생깁니다.
  w = float(width) / float(num);
  noStroke();
  for (int i=0; i<num*num; i++) {
    // i를 num로 나눈 나머지.
    int i_x = i % num; // 23 -> 3
    // i를 num로 나눈 몫.
    int i_y = floor( i / num ); // 34 -> 3
    // 색이 흑색일 경우, 백색일 경우
    
    fill(0);
    
    //이 조건은은 열의 개수가 짝수일때만 체스보드처럼 무늬가 생김.
    //if((i + (i_y % 2)) % 2 == 0) fill(255);
    
    // --> 대안 : i_x, i_y가 동시에 홀수이거나 짝수인 경우로 판단.
    if ((i_x % 2 == 0 && i_y % 2 == 0) || 
      (i_x % 2 == 1 && i_y % 2 == 1)) fill(255);
    rect(i_x * w, i_y * w, w, w);
  }
}
