# Day 4 v2 — Kibana Dashboard 직접 만들기

Day 4는 `products` 20,000건을 확인한 뒤, Kibana Lens와 Dashboard에서 공통 화면을 직접 만들고 같은 설계 절차를 개인 PBL에 적용하는 날입니다.

## 파일 구성

- `student-workbook.md`: 개념, 화면 역할, 차트 선택 기준, 단계별 실습
- `KIBANA_9_5_STEP_BY_STEP.md`: Data View부터 각 패널·Control·검증·내보내기까지 실제 클릭 순서
- `CHART_GALLERY.md`: 필수·선택 그래프의 완성 모습과 빠른 설정표
- `PRACTICE_GUIDE.md`: 교시별 요구사항, 실행 방식, 검증 기준, 완료 조건
- `practice/`: 교시별 필수 4문제+선택 1문제, 총 40문제와 답안 작성 방법
- `assets/`: 교재와 같은 Kibana 9.5.0 실제 화면 캡처 20종
- `requests/05-dashboard-baseline.http`: 화면 수치와 비교할 ES 기준값
- `evidence/day-04/dashboard-plan.md`: 개인 Dashboard 설계 청사진
- `evidence/day-04/dashboard-review.md`: 테스트·해석·개선 기록
- `evidence/day-04/README.md`: 제출 파일과 캡처 기준

## 오늘의 최종 산출물

1. 공통 Dashboard: Metric, category Bar, brand Table, price 분포 Bar, in_stock Donut, created_at Line, category Options list
2. 개인 Dashboard: 질문이 서로 다른 패널 4개 이상, filter 또는 control 1개 이상
3. `dashboard-plan.md`, `dashboard-review.md`, Dashboard 전체 화면 캡처

## 연습문제 시작

1. [Kibana 9.5.0 화면 그대로 따라 하기](KIBANA_9_5_STEP_BY_STEP.md)를 북마크합니다.
2. [차트 완성형 한눈에 보기](CHART_GALLERY.md)에서 오늘 만들 결과를 확인합니다.
3. [답안 작성 방법](practice/ANSWER_WRITING_GUIDE.md)을 읽습니다.
4. [교시별 문제 목록](practice/README.md)에서 현재 교시 문제지를 엽니다.
5. 문제지를 개인 저장소 `evidence/day-04-practice/`에 복사해 답을 작성합니다.
6. 매 교시는 필수 4문제를 먼저 수행하고 선택 도전은 시간이 남을 때만 수행합니다.

전체 40문제에는 공통 기능 재현, 설정 변형, 오류 진단·검증, 개인 PBL 적용, 선택 도전이 교시 목적에 맞게 포함됩니다. 예상값을 그대로 적지 말고 실제 화면에서 확인한 값과 근거 캡처를 기록합니다.

강사 공통 시연은 쇼핑몰 `products`를 사용합니다. 개인 데이터가 충분한 학생은 자신의 index로 개인 Dashboard를 만들고, 데이터가 부족한 학생은 공통 Dashboard를 끝까지 만든 뒤 설계 문서에 필요한 field와 데이터 보강 규칙을 작성합니다.

## 완료 기준

- Dashboard 제목과 모든 패널 제목이 비어 있지 않다.
- 각 패널이 서로 다른 분석 질문에 답한다.
- filter/control 적용 전후에 2개 이상의 패널 값이 함께 변한다.
- 핵심값 3개를 Discover 또는 ES 집계 결과와 대조했다.
- `created_at`을 판매 추이라고 표현하지 않고 상품 등록 시점으로 해석했다.
- 개인 데이터가 부족한 경우 부족한 field, 값 분포, 생성 규칙을 기록했다.

## 공식 문서

- [Lens visualizations](https://www.elastic.co/docs/explore-analyze/visualize/lens)
- [Create a dashboard](https://www.elastic.co/docs/explore-analyze/dashboards/create-dashboard)
- [Add dashboard controls](https://www.elastic.co/docs/explore-analyze/visualize/add-controls)
- [Explore dashboards and filters](https://www.elastic.co/docs/explore-analyze/dashboards/using)
