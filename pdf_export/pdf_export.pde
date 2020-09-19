// 프로세싱 내부 라이브러리에서 PDF export 라이브러리를 불러옴.
import processing.pdf.*;

// 형태를 그리는데 사용할 디테일
int num = 100;

void setup() {
  size(600, 600);
  background(255);

  // PDF 저장 시작. strokeJoin(), strokeWeight(), stroke() 등의
  // 스타일을 지정한 내용이 저장되는 pdf에도 적용이 되려면
  // beginRecord() 뒤에 적용이 되어있어야 합니다.
  // "capture/####.pdf" -> capture 폴더에 프레임 번호를 이름으로 
  // 가진 pdf 파일로 저장이 됩니다. capture라는 이름의 폴더가 
  // 없다면 만들고 그 디렉토리에 파일을 저장합니다.
  beginRecord(PDF, "capture/####.pdf");

  stroke(255, 0, 0);
  strokeWeight(3);
  // noise로 고리형태 그리기. 
  // vertex(), curveVertex(), bezierVertex() 등의 기능은
  // 형태를 그리기 시작하고 끝낼때 beginShape()과 endShape()을 써주어야 합니다.
  beginShape();
  for (int i=0; i<num; i++) {
    float angle = i * 2 * PI / num;

    // noise로 그린 고리형태가 닫혀있으려면 noise()에 좌표를 입력할때
    // 2차원 평면상의 원을 그리는 점들을 만들어서 입력.
    float n_x = 1+cos(angle)*0.2;
    float n_y = 1+sin(angle)*0.2;

    // noise()는 프로세싱에서 기본으로 제공하는 perlin noise 함수 값을
    // 이용하는 기능입니다. noise는 연속적이면서 무작위한 값을 뽑아줍니다.
    // noise()는 최대 3개의 값 x,y,z를 받아들일 수 있고,
    // 저는 이것을 연속하게 무작위한 값들이 분포해있는 3차원의
    // 노이즈 공간 속에서 입력한 좌표의 값을 가져온다고 상상합니다.
    // 입력된 좌표가 가까울수록 더 유사한 무작위한 값을 얻을수 있습니다.
    float r = noise(n_x, n_y) * 300 + 50;
    float x = width * 0.5 + r * cos(angle);
    float y = height * 0.5 + r * sin(angle);
    vertex(x, y);
  }
  endShape(CLOSE);

  // PDF 저장을 끝냅니다.
  endRecord();
}
