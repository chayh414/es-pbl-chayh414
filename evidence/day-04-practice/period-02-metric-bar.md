# 2교시 연습 — Metric·Bar·Top values

- 필수 권장 시간: 40분
- 선택 도전: 5분
- 제출 상태 확인: 5분
- 시작 기준: Discover 20,000건, KQL/filter 없음
- 화면 순서: [Metric](../KIBANA_9_5_STEP_BY_STEP.md#5-패널-1--전체-상품-수-metric), [category Bar](../KIBANA_9_5_STEP_BY_STEP.md#6-패널-2--카테고리별-상품-수-bar)

## (공통·필수) 문제 1 — 전체 상품 수 Metric 제작

빈 Dashboard에 Lens Metric을 추가하세요.

- Data View: 공통 `products`
- 계산: Records 또는 Count of records
- 제목: `전체 상품 수`
- 정상 기준: 20,000

### 결과 입력

- Dashboard 이름: (아직 저장 전, 이름 정하는 대로 채우기)
- 사용한 계산: Count of records
- 실제 Metric 값: 20,000
- 시간 범위: Last 2 years
- KQL/filter/control 상태: 없음 (깨끗한 상태)
- 정상/보류/오류와 이유: 정상. 기대한 20,000과 정확히 일치
- 캡처 파일: `../day-04/screenshots/05-all-panels.png`

## (공통·필수) 문제 2 — category Bar 제작

같은 Dashboard에 category별 상품 수 Bar를 만드세요.

- 그룹 field: `category`
- 그룹 방식: Top values
- Number of values: 8
- 값: Count of records
- 제목: `카테고리별 상품 수`

### 설정·결과 입력

- Bar 방향: vertical
- x축 또는 category 차원: category (Top values, Rank by Custom→Count of records, Descending)
- y축 또는 Metric: Count of records
- Number of values: 8
- 표시된 category 수: 8개 (도서, 반려동물, 뷰티, 생활, 스포츠, 식품, 전자기기, 패션)
- 각 category 값이 공통 기준과 일치하는가: 예. 8개 막대 모두 눈으로 봐도 2,500 근처로 균등하며, ES에서 확인한 공통 기준(각 2,500건)과 일치
- 캡처 파일: `../day-04/screenshots/05-all-panels.png`

## (변형·필수) 문제 3 — Bar 방향 한 가지만 바꿔 비교

동일한 category·Count·Top 8을 유지하고 Bar 방향만 vertical과 horizontal로 바꿔 보세요.

방향은 `Style → Appearance → Bar orientation`에서 바꿉니다. 축 label 방향과 혼동하지 않습니다.

| 비교 | vertical | horizontal |
|---|---|---|
| category 이름 가독성 | 한글 카테고리명이 짧아 세로 막대 아래에서도 잘 읽힘 | 가독성은 비슷하나 세로 방향만큼 직관적이지 않음 |
| 값 비교 속도 | 막대 높이가 눈에 더 잘 들어와 수치 비교가 빠름 | 상대적으로 느리게 느껴짐 |
| 잘림·겹침 | 없음 | 없음 |

- 최종 선택: vertical
- 선택 이유: 각 카테고리별 수치가 눈에 더 잘 들어옴 (막대 높이 비교가 horizontal의 길이 비교보다 직관적으로 느껴짐)
- 다른 설정을 동시에 바꾸지 않았는가: 예, Bar orientation 하나만 변경하고 category/Count/Top 8은 그대로 유지함

## (진단·필수) 문제 4 — 막대가 하나만 남은 상황 복구

Bar에 `스포츠` 등 하나의 category만 보인다고 가정합니다. Dashboard에서 다음을 확인하고 원래 8개 category로 복구하세요.

1. category Control 선택값
2. 상단 filter pill
3. KQL
4. 시간 범위
5. Lens의 Top values 설정

### 진단 기록

(가정 상황이 아니라 실제로 category Bar의 "식품" 막대를 클릭했을 때 발생함)

- 보이던 category: 식품 1개만
- 발견한 제한 조건: 검색창 아래에 filter pill `category: 식품`이 자동으로 생성됨. Lens 차트를 클릭하면 그 값으로 Dashboard 전체를 필터링하는 기본 동작 때문
- 제거 또는 초기화한 항목: 해당 filter pill의 X를 눌러 제거
- 복구 후 막대 수: 8개 (도서, 반려동물, 뷰티, 생활, 스포츠, 식품, 전자기기, 패션)
- 복구 후 Metric 값: 20,000
- 원인이 없었다면 추가로 확인한 Lens 설정: 해당 없음 (filter pill이 원인으로 바로 확인됨)
- 캡처 파일: (회원님 로컬 스크린샷 경로로 채워주세요)

## (개인·선택 도전) 문제 5 — 내 범주 field로 Metric+Bar 설계

자기 데이터의 전체 규모 Metric과 범주별 Bar를 설계하거나 만드세요. 범주 field가 없으면 필요한 field를 설계합니다.

- 개인 index/Data View: vintage-items (Timestamp field: listed_date)
- 전체 규모가 의미하는 것: 현재 등록된 빈티지 의류 상품 총 개수
- 범주 field: category
- 실제 고유값 수: 6개 (원피스, 아우터, 가방, 신발, 상의, 하의)
- Top N 선택값과 이유: 9로 설정했으나 실제 고유값이 6개뿐이라 6개만 표시됨 — 카테고리 종류가 적어 Top N을 넉넉히 잡아도 문제없음
- 예상 사용자 판단: 어떤 카테고리 상품이 가장 많이 등록돼 있는지 파악해 재고·마케팅 우선순위를 정할 수 있음
- 실제 제작 여부: 실제 제작함 (Metric+Bar 둘 다 완성)
- 부족한 경우 필요한 field와 예시값: 해당 없음 (필요한 field 이미 존재)
- 캡처 또는 설계 문서 경로: `../day-04/screenshots/02-vintage-metric-bar.png`

## 교시 완료 신호

- GREEN: Metric 20,000, category Bar 8개, 제목 2개, 비교·복구 기록 완료
- YELLOW: 패널은 있으나 값·Top N·제목 중 하나가 다름
- RED: Lens 저장 또는 Dashboard 복귀 불가

