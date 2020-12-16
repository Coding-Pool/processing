// geomerative 라이브러리 불러오기
import geomerative.*;

// geomerative 라이브러리 내의 클래스
RFont font;
RGroup font_grp;
RPoint[][] font_pnts;

// 스프링노드 클래스 타입의 어레이리스트
ArrayList<SpringNode> spn;
// 패스별로 가진 점의 개수 카운팅
int spn_num[];

// 스프링 탄성계수
float spring_k = 0.4;
// 스프링 원래 길이 (아무런 힘도 받지 않았을때)
float spring_l = 2;

// 수직 중앙배치를 위해 제일 작은 y값, 제일 큰 y값을 기록하기 위한 변수
float min_y = 0, max_y = 0;
// 위의 min_y, max_y 로 문자의 수직 길이를 측정
float shape_h = 0;

// 사용할 문자열
String str = "쭈,글,탱";
// 문자열 나누기
String[] split_str = split(str, ",");

// 리셋하고 글자 바꿔주는 간격을 설정하는 부분
int reset_count = 0;
int reset_term = 150;
// 리셋될때마다 다음 문자열 참조
int curr_str_num = 0;

void setup() {
  size(800, 800);
  pixelDensity(1);
  smooth();
  frameRate(50); 
  println(split_str[0]);

  // geomerative 쓰려면 써야되는 부분
  RG.init(this);
  // 서체의 형태를 그려줄때 5픽셀 (단위는 불확실) 간격으로 점을 그려준다.
  // (괄호에 들어간 값이 작아질수록 더 촘촘해진다)
  RG.setPolygonizerLength(5);
  // 서체 불러오기, 서체 크기 지정
  font = new RFont("GothicA1-Black.ttf", 750);
  // 텍스트 좌우 정렬 설정을 가운데 정렬로 설정.
  font.setAlign(RFont.CENTER);

  // 현재 문자열의 형태를 가져오고, 스프링노드 클래스에서 형태의 위치정보들 활용
  reset_txt();

  strokeJoin(BEVEL);
  stroke(0);
  strokeWeight(1.2);
}

void reset_txt() {
  min_y = 0;
  max_y = 0;
  shape_h = 0;

  // 문자열을 geomerative RGroup 클래스로 변환
  font_grp = font.toGroup(split_str[curr_str_num]);
  // RGroup 클래스에서 패스별로 점을 얻어내기
  font_pnts = font_grp.getPointsInPaths();

  // 패스 개수대로 반복문
  for (int j=0; j<font_pnts.length; j++) {
    // 패스 내에 있는 점의 개수대로 반복문
    for (int i=0; i<font_pnts[j].length; i++) {
      // 현재 목차에서 y 값이 더 작은지 큰지 비교해서 
      // 반복문이 끝나면 최대값, 최소값이 배정되어 있다.
      if (min_y > font_pnts[j][i].y) {
        min_y = font_pnts[j][i].y;
      } else if (max_y < font_pnts[j][i].y) {
        max_y = font_pnts[j][i].y;
      }
    }
  }

  // 문자 형태의 수직길이들 중 최대값
  shape_h = max_y - min_y;

  //println(shape_h, max_y, min_y);

  // 새로운 SpringNode 타입 어레이리스트 선언
  spn = new ArrayList<SpringNode>();
  // 패스 개수만큼 칸을 가진 배열. 여기에 각 패스에 포함된 점의 개수를 저장
  spn_num = new int[font_pnts.length];
  int curr_num = 0;
  for (int j=0; j<font_pnts.length; j++) {
    int num = 0;
    for (int i=0; i<font_pnts[j].length; i++) {

      // 글자의 형태를 대략 화면 중앙배치하기 위한 부분
      float x = font_pnts[j][i].x + width * 0.5 - 30;
      if (curr_str_num == 2) x -= 50;
      float y = font_pnts[j][i].y + height * 0.5 + shape_h * 0.5 - max_y;

      // 현재 패스내에서 첫번째 점인지, 중간인지, 마지막 점인지 노드에 저장.
      // 첫번째 점인 경우 0, 중간인 경우 1, 마지막인 경우 2 
      // (스프링노드 선언해주는 부분 괄호에 들어가는 변수 중 3번째)
      if (i==0) spn.add(new SpringNode(x, y, 0, j, curr_num));
      if (i!=0 && i!=font_pnts[j].length-1) spn.add(new SpringNode(x, y, 1, j, curr_num));
      if (i==font_pnts[j].length-1) spn.add(new SpringNode(x, y, 2, j, curr_num));
      num++;
      curr_num++;
    }
    spn_num[j] = num;
    //spn_nun[j] = font_pnts[j].length;
  }
  
  // spn_num은 굳이 필요하지 않고, 비효율적이지만 일단 남겨두었습니다.
  
}

void draw() {
  background(255);
  
  // geomerative 라이브러리로 얻은 형태 확인
  /*
  stroke(255, 0, 0);
  for (int j=0; j<font_pnts.length; j++) {
    beginShape();
    for (int i=0; i<font_pnts[j].length; i++) {
      vertex(font_pnts[j][i].x + width * 0.5 - 30, font_pnts[j][i].y + height * 0.5 + shape_h * 0.5 - max_y);
    }
    endShape(CLOSE);
  }
  */
  
  // 리셋 하기 위한 카운트
  reset_count++;
  
  // 카운트가 미리 설정한 값 (reset_term) 보다 커졌을 경우
  if (reset_count > reset_term) {
    reset_count = 0;
    
    // 문자열을 순차적으로 바꿔주고, 다시 처음부터 반복하기 위한 부분
    if (curr_str_num < split_str.length - 1) {
      curr_str_num++;
    } else {
      curr_str_num = 0;
    }
    
    // 다음 문자열을 선택해서 리셋
    reset_txt();
  }

  // 탄성, 그외 몇가지 경우들에 따라 각 점이 받는 힘 계산, 위치 업데이트
  for (int i=0; i<spn.size(); i++) {
    PVector prev = new PVector();
    PVector next = new PVector();
    
    // 현재 패스의 마지막 점인 경우나 첫번째 점인 경우,
    // 이전점 다음점을 (i-1), (i+1) 으로 참조할 수 없어서 적절한 값을 배정해주는 부분
    if (spn.get(i).is_strt_end == 0) {
      int pth_length = spn_num[spn.get(i).path_num];
      prev = spn.get(i+(pth_length-1)).pos;
      next = spn.get(i+1).pos;
    } else if (spn.get(i).is_strt_end == 2) {
      int pth_length = spn_num[spn.get(i).path_num];
      prev = spn.get(i-1).pos;
      next = spn.get(i-(pth_length-1)).pos;
    } else {
      prev = spn.get(i-1).pos;
      next = spn.get(i+1).pos;
    }
    
    // 이전 점, 다음 점의 좌표를 이용해서 현재 점이 받을 힘 계산
    spn.get(i).cal_force(prev, next);
    // 화면 가장자리 도달했을 경우, 혹은 다른와의 거리가 너무 가까워졌을때 반사
    spn.get(i).reflect();
    // 위치 업데이트
    spn.get(i).update();
  }

  // 원점을 이동할때, 프레임별로 기준점 이동이 동일하도록
  // translate() 같은 것을 썼을때, 그 원점 변형이 pushMatrix() ~ popMatrix() 범위 내에서만 일어나도록
  pushMatrix();
  
  // 화면 중앙을 기준으로 확대하기 위한 부분
  // 원점 이동
  translate(width * 0.5, height * 0.5);
  // 원점으로 기준으로 화면을 스케일링
  // 리셋 전까지 질문 어느ㅈ
  scale(1.0 + 0.7 * reset_count / reset_term);


  if (render_mode == 0) {
    // 렌더 모드 0의 경우, 흑색으로 채워진 형태를 그린다.
    fill(0);
    // 패스로 그려진 형태의 겹친 영역이 투명해지는데,
    // 결과적으로 속공간만 투명해지는 효과를 얻는다.
    beginShape();
    for (int i=0; i<spn.size(); i++) {
      if (i!=0 && spn.get(i).is_strt_end == 0) beginContour();
      // translate에서 이동된 좌표를 상쇄해주기 위한 부분
      float x = spn.get(i).pos.x - width * 0.5;
      float y = spn.get(i).pos.y - height * 0.5;
      vertex(x, y);
      if (spn.get(i).is_strt_end == 2 && spn.get(i).path_num != 0) endContour();
    }
    endShape(CLOSE);
  } else {
    
    // 렌더 모드 1의 경우, 색이 칠해지지 않은 직선과 원을 그린다.
    noFill();
    beginShape();
    for (int i=0; i<spn.size(); i++) {
      if (i!=0 && spn.get(i).is_strt_end == 0) beginShape();
      float x = spn.get(i).pos.x - width * 0.5;
      float y = spn.get(i).pos.y - height * 0.5;
      vertex(x, y);
      if (spn.get(i).is_strt_end == 2) endShape(CLOSE);
    }

    noFill();
    for (int i=0; i<spn.size(); i++) {   
      float x = spn.get(i).pos.x  - width * 0.5;
      float y = spn.get(i).pos.y  - height * 0.5;
      ellipse(x, y, 6, 6);
    }
  }
  popMatrix();
}

int render_mode = 0;

void keyPressed() {
  // 렌더 모드를 바꿔주기
  if (render_mode == 0) {
    // 렌더 모드 번호가 0일 경우, 1로
    render_mode = 1;
  } else {
    // 렌더 모드 번호가 1일 경우, 0으로
    render_mode = 0;
  }
}
