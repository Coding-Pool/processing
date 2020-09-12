float R = 200;

void setup() {
  // P2D를 안써도 상관이 없더군요.
  size(600, 600); 

  // 픽셀 밀도를 현재 디스플레이 밀도와 맞춰줍니다.
  pixelDensity(displayDensity());

  // "투명도 곱하기" 와 비슷한한 기능이에요. 
  // RGB 색상을 더하면 하얀 값이 나오지만, 
  // 만약 RGB이 0~1 사이 값이라고 가정할때, 두 값이 서로 곱해진다면
  // 많이 곱해질수록 점점 작아져서 검은색에 가까워집니다.
  blendMode(MULTIPLY);
  strokeWeight(80);
}

void draw() {
  background(255);

  // 화면상에서 움직이는 원1
  // sin 함수에 현재 프레임 카운트 값을 넣어주어서 위치를 업데이트합니다.
  // sin 함수는 0에서 값이 0이기 때문에 초기에 3개의 원이 같은 위치에서 시작하지만
  // 만약 여기에서 cos 함수를 사용했다면 시작하는 위치가 달랐을거에요
  // 원1과 원2의 x좌표에는 각각 sin함수 값을 각각 1 과 -1을 곱한 값이 더해집니다 (반대방향)
  // 원1과 원2의 y좌표에는 동일한 값이 더해집니다.
  stroke(0, 255, 255);
  ellipse(width*0.5 + 70 * sin(frameCount * 0.01), height*0.5 - 70 * sin(frameCount * 0.01), R, R);

  // 화면상에서 움직이는 원2
  stroke(255, 0, 255);
  ellipse(width*0.5 - 70 * sin(frameCount * 0.01), height*0.5 - 70 * sin(frameCount * 0.01), R, R);

  // 화면상에서 고정되어 있는 원
  stroke(255, 255, 0);
  ellipse(width*0.5, height*0.5, R, R);
}
