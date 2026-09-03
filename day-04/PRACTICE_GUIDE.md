# Day 4 v2 교시별 실습 가이드

모든 교시는 `짧은 설명 → 강사 시연 → 그대로 재현 → 설정 하나 변경 → 검증·저장` 순서로 진행합니다.

교시별 실제 문제와 답안란은 [`practice/README.md`](practice/README.md)에서 시작합니다. 답을 쓰기 전 [`practice/ANSWER_WRITING_GUIDE.md`](practice/ANSWER_WRITING_GUIDE.md)의 질문·설정·실제 결과·근거·판정 작성 규칙을 확인합니다.

메뉴 위치와 클릭 순서는 [`KIBANA_9_5_STEP_BY_STEP.md`](KIBANA_9_5_STEP_BY_STEP.md), 모든 필수·선택 그래프의 완성 모습은 [`CHART_GALLERY.md`](CHART_GALLERY.md)를 사용합니다. 메뉴가 다르면 임의로 눌러 진행하지 말고 단계 번호와 화면 캡처를 제출합니다.

## 공통 준비

1. Kibana 접속과 `products` Data View를 확인합니다.
2. `products`가 20,000건인지 확인합니다.
3. 시간 범위는 강사 화면과 같은 절대 범위로 맞춥니다.
4. 개인 저장소에 `evidence/day-04/` 양식을 복사합니다.
5. 상태를 GREEN/YELLOW/RED 중 하나로 표시할 준비를 합니다.

## 1교시 · 데이터와 질문 확인

- 상세 클릭 순서: [Data View](KIBANA_9_5_STEP_BY_STEP.md#1-data-view-만들기-또는-기존-data-view-확인하기), [Discover](KIBANA_9_5_STEP_BY_STEP.md#2-discover에서-실제-데이터-확인하기)

- 요구사항: Data View, Discover, Lens, Dashboard 역할을 구분하고 공통 기준값을 확인한다.
- 강사 시연: products Data View와 Discover에서 20,000건, 핵심 field, 시간 범위를 확인한다.
- 학생 재현: 표시 열 7개를 추가하고 `in_stock:false`가 3,001건인지 확인한다.
- +@ 과제: “내 주제에서 보고 싶은 질문” 하나와 필요한 field를 적는다.
- 검증: Data View, 20,000건, 시간 범위, field 열이 같은 화면에 보인다.
- 최종 골: GREEN/YELLOW/RED 상태와 개인 질문 1개.

## 2교시 · 전체와 그룹 비교

- 상세 클릭 순서: [Metric](KIBANA_9_5_STEP_BY_STEP.md#5-패널-1--전체-상품-수-metric), [category Bar](KIBANA_9_5_STEP_BY_STEP.md#6-패널-2--카테고리별-상품-수-bar)

- 요구사항: 전체 상품 수 Metric과 category Bar를 만든다.
- 강사 시연: Records count Metric → category Top values + Count Bar.
- 학생 재현: 같은 제목과 field로 두 패널을 만든다.
- +@ 과제: 가로/세로 방향 또는 Top N 하나를 바꾸고 더 읽기 쉬운 이유를 적는다.
- 검증: 20,000과 category 8개×2,500이 보인다.
- 최종 골: `전체 상품 수`, `카테고리별 상품 수` 2패널 저장.

## 3교시 · 정확한 값과 정렬

- 상세 클릭 순서: [brand Table](KIBANA_9_5_STEP_BY_STEP.md#7-패널-3--브랜드별-상품-수와-평균-가격-table)

- 요구사항: brand별 Count와 Average price를 한 Table에서 비교한다.
- 강사 시연: brand Top values, Records count, Average price, 정렬 변경.
- 학생 재현: 같은 Table을 만든다.
- +@ 과제: count 정렬과 average price 정렬 결과의 차이를 설명한다.
- 검증: 열 제목, 단위, Top N, 정렬 방향이 질문과 일치한다.
- 최종 골: `브랜드별 상품 수와 평균 가격` 저장과 해석 1문장.

## 4교시 · 분포·비율·시간

- 상세 클릭 순서: [price ranges](KIBANA_9_5_STEP_BY_STEP.md#8-패널-4--가격-구간별-상품-수-bar), [Pie→Donut](KIBANA_9_5_STEP_BY_STEP.md#9-패널-5--재고-상태-비율-donut), [created_at Line](KIBANA_9_5_STEP_BY_STEP.md#10-패널-6--월별-상품-등록-분포-line)

- 요구사항: price Bar, in_stock Donut, created_at Line을 만든다.
- 강사 시연: Intervals, Top values, Date histogram의 차이와 `Pie → Donut hole`, `Minimum interval → 1M`을 보여 준다.
- 학생 재현: 세 패널을 만든다.
- +@ 과제: price 자동 Intervals/50,000 단위 custom ranges 또는 날짜 `1d`/`1M`을 비교해 하나를 선택한다.
- 검증: false 3,001·true 16,999, 날짜 의미가 상품 등록 시점임을 확인한다.
- 최종 골: 공통 필수 6패널 완성.

## 5교시 · 조립·저장·상호작용

- 상세 클릭 순서: [배치·패널 메뉴](KIBANA_9_5_STEP_BY_STEP.md#11-dashboard-배치제목패널-메뉴), [Options list](KIBANA_9_5_STEP_BY_STEP.md#12-category-options-list-control), [조건 복구](KIBANA_9_5_STEP_BY_STEP.md#13-controlfilterkql-사용과-복구), [저장](KIBANA_9_5_STEP_BY_STEP.md#14-dashboard-저장재열기복제)

- 요구사항: 6패널을 배치하고 category Options list와 패널 클릭 filter를 확인한다.
- 강사 시연: 제목 변경, 패널 크기 조정, control 추가, filter 적용·해제, 저장.
- 학생 재현: Dashboard를 정돈하고 같은 상호작용을 수행한다.
- +@ 과제: category 하나를 선택한 전후 값 2개를 기록한다.
- 검증: 제목 공백·라벨 겹침·불필요 filter가 없고 Clear 후 20,000으로 복구된다.
- 최종 골: `D4 공통 상품 Dashboard - 이름` 저장과 전체 화면 캡처.
- 현장 중단점: 목요일은 여기서 종료할 수 있다. 금요일에는 같은 파일의 6교시부터 이어간다.

## 6교시 · 개인 질문과 데이터 적합성

- 요구사항: 개인 Dashboard 사용자, 목적, 질문 4개, 필요한 field를 설계한다.
- 강사 시연: 질문→field→계산→차트→검증 청사진 작성.
- 학생 재현: `dashboard-plan.md`를 작성하고 A/B/C 경로를 선택한다.
- +@ 과제: 불가능한 질문 하나를 찾고 필요한 field·값 분포·생성 규칙을 쓴다.
- 검증: 질문 4개가 서로 중복되지 않고 각 field가 실제로 있거나 보강 계획이 있다.
- 최종 골: 완성된 `dashboard-plan.md`.

## 7교시 · 개인 Dashboard 제작

- 상세 클릭 순서: [개인본 Save as](KIBANA_9_5_STEP_BY_STEP.md#142-개인본-만들기), [선택 확장 패널](KIBANA_9_5_STEP_BY_STEP.md#16-선택-확장-패널)

- 요구사항: 개인 질문을 답하는 패널 4개 이상과 filter/control 1개를 만든다.
- 강사 시연: 공통 설정을 다른 질문으로 바꾸는 방법을 보여 준다.
- 학생 재현: 청사진 순서대로 만들고 각 패널 제목을 질문형으로 붙인다.
- +@ 과제: 빠른 학생은 Gauge·Heatmap·Treemap·Tag cloud 중 필요한 것 하나만 추가한다.
- 검증: 공통 화면 복사가 아니라 field·집계·정렬·구간·제목 중 두 가지 이상이 달라졌다.
- 최종 골: 개인 Dashboard 저장.

## 8교시 · 테스트·해석·개선

- 상세 클릭 순서: [결과 저장·백업](KIBANA_9_5_STEP_BY_STEP.md#15-결과-저장공유백업), [최종 점검](KIBANA_9_5_STEP_BY_STEP.md#18-최종-자가-점검)

- 요구사항: filter 전후, 핵심값 3개, 오류 복구, 해석 2문장, 개선 1개를 남긴다.
- 강사 시연: 조건 적용→값 기록→Discover/ES 대조→Clear→개선.
- 학생 재현: `dashboard-review.md`를 완성한다.
- +@ 과제: 질문에 답하지 못하는 패널 하나를 수정하거나 제거한다.
- 검증: 캡처와 기록으로 다른 사람이 결과를 재현할 수 있다.
- 최종 골: Dashboard, plan, review, 캡처를 개인 저장소에 commit.

## 말하지 않아도 참여 상태를 알리는 방법

교시 종료 5분 전에 GREEN/YELLOW/RED를 표시합니다.

- GREEN: 완료 기준 충족
- YELLOW: 결과는 있으나 수치·field·시간·저장 중 하나가 다름
- RED: 다음 교시 진행이 어려움

YELLOW/RED 학생은 발표하지 않고 오류 화면 캡처와 현재 단계 번호만 제출합니다. 강사는 그 정보로 공통 복구 순서를 안내합니다.

## 전체 완료 기준

- [ ] 공통 6패널과 category control
- [ ] 개인 질문 4개와 데이터 적합성 판단
- [ ] 개인 4패널 이상과 filter/control
- [ ] filter 적용 전·후와 Clear 복구 기록
- [ ] 핵심값 3개 교차 검증
- [ ] 해석 2문장과 개선 1개
- [ ] evidence 전체 저장
- [ ] 교시별 필수 연습문제 32개 답안과 근거 저장
- [ ] 개인 저장소 `evidence/day-04-practice/`에 문제지 기록
