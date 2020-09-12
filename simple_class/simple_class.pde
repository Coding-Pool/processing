
// 여러개의 원이 무작위한 위치에서 생성되어 각기 다른 속도를 가지고 움직이는 예제
// 원들이 벽에 반사되어 나온다.

ball b[]; // 새로운 클래스 오브젝트를 만들건데 이것을 array로 만들거다.
int num = 100;

void setup() {
  size(800, 800);
  pixelDensity(displayDensity());
  strokeWeight(10);
  b = new ball[num]; // 몇개나 만들것인지.
  // 만들어준 개수 만큼의 클래스 오브젝트를 "시작"해줍니다.
  for (int i=0; i<num; i++) {
    //새로 만들어준 클래스의 setup() 비슷한 것이라고 생각하시면 됩니다.
    b[i] = new ball();
  }
}

void draw() {
  background(255);
  for (int i=0; i<num; i++) {
    // ball 클래스로 이루어진 array 형태의 b에서 i번째 요소를 가지고 온다.
    // i번째 요소에서 update() 와 display() 실행.
    b[i].update();
    b[i].display();
  }
}
