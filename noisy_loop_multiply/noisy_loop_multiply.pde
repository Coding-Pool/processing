
int num = 100;

void setup() {
  size(600, 600);
  // 색 값을 곱해서 더 어두운 색상이 나오도록 해주는 모드
  // 인쇄시 여러 색상을 겹쳐서 인쇄했을때 겹친 부분이
  // 더 어두워지는 것과 유사한 원리
  blendMode(MULTIPLY);
  background(255);

  strokeWeight(20);
  // 선들이 연결될때 모서리 부분이 직선으로 깍이는 스타일 지정
  strokeJoin(BEVEL);
}

void draw() {
  background(255);

  // noise()는 프로세싱에서 기본으로 제공하는 perlin noise 함수 값을
  // 이용하는 기능입니다. noise는 연속적이면서 무작위한 값을 뽑아줍니다.
  // noise()는 최대 3개의 값 x,y,z를 받아들일 수 있고,
  // 저는 이것을 연속하게 무작위한 값들이 분포해있는 3차원의
  // 노이즈 공간 속에서 입력한 좌표의 값을 가져온다고 상상합니다.
  // 입력된 좌표가 가까울수록 더 유사한 무작위한 값을 얻을수 있습니다.
  
  // 닫힌 고리 형태를 그리기 위해 noise()에
  // 좌표평면에 그릴 경우 원이 되는 점들을 순차적으로 넣어주고 있습니다.
  // 이것을 위해 noise()에 입력되는 값 중 n_x, n_y 값을 쓰고 있고,
  // z 값은 프레임별로 변화가 있는 값 frameCount를 넣어 애니메이션을 주고 있습니다.
  
  // n_x, n_y의 경우, 원의 중심이 0,0 보다 큰 값을 가지도록 지정해주고 있는데,
  // 이는 이렇게 하지 않을 경우 대칭인 형태가 나와버립니다.
  
  // 고리 1, 2, 3은 각각 noise()에 입력되는 원 좌표의 중심이
  // 매우 작은 숫자만큼 이동이 되어있는데,
  // 이는 매우 조금씩 다른 고리를 그리기 위함입니다.
  
  // 고리 1
  stroke(255, 255, 0);
  beginShape();
  for (int i=0; i<num; i++) {
    float angle = i * 2 * PI / num;
    float n_x = 1+cos(angle)*0.2;
    float n_y = 1+sin(angle)*0.2;

    float r = noise(n_x, n_y, frameCount * 0.004) * 300 + 50;
    float x = width * 0.5 + r * cos(angle);
    float y = height * 0.5 + r * sin(angle);
    vertex(x, y);
  }
  endShape(CLOSE);

  // 고리 2
  stroke(255, 0, 255);
  beginShape();
  for (int i=0; i<num; i++) {
    float angle = i * 2 * PI / num;
    float n_x = (1+0.02)+cos(angle)*0.2;
    float n_y = (1+0.02)+sin(angle)*0.2;

    float r = noise(n_x, n_y, frameCount * 0.004) * 300 + 50;
    float x = width * 0.5 + r * cos(angle);
    float y = height * 0.5 + r * sin(angle);
    vertex(x, y);
  }
  endShape(CLOSE);

  // 고리 3
  stroke(0, 255, 255);
  beginShape();
  for (int i=0; i<num; i++) {
    float angle = i * 2 * PI / num;
    float n_x = (1+0.04)+cos(angle)*0.2;
    float n_y = (1+0.04)+sin(angle)*0.2;

    float r = noise(n_x, n_y, frameCount * 0.004) * 300 + 50;
    float x = width * 0.5 + r * cos(angle);
    float y = height * 0.5 + r * sin(angle);
    vertex(x, y);
  }
  endShape(CLOSE);
}
