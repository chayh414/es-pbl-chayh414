# 8교시 연습 — 사용 시나리오·교차 검증·개선·제출

- 필수 권장 시간: 45분
- 선택 도전: 필수 제출 완료 후
- 함께 작성: `../evidence/day-04/dashboard-review.md`
- 시작 기준: 개인 Dashboard 4패널 이상과 상호작용 1개 저장 완료
- 화면 순서: [Inspect·결과 저장·백업](../KIBANA_9_5_STEP_BY_STEP.md#15-결과-저장공유백업)

## (개인·필수) 문제 1 — 사용자 행동 두 가지 테스트

Dashboard 사용자가 실제로 할 행동 두 가지를 실행하세요. 각 행동은 조건 적용과 결과 확인, 원상 복구를 포함합니다.

| 행동 | 시작 상태 | 적용 조건 | 변한 패널·값 | 사용자의 판단 | 복구 방법 | 복구 성공 |
|---|---|---|---|---|---|---|
| 1 | 전체(5,000) | category Control = "아우터" | 내 등록 상품 수 5,000→808, 카테고리별 평균 가격/가격 구간/판매완료 비율 패널도 아우터 기준으로 재계산 | "아우터 카테고리는 808개 등록돼 있고 그중 32.18%가 판매완료" | Control을 "Any"로 재선택 | 성공 |
| 2 | brand Table 상품 수 내림차순(HomeNest 1위) | 평균 가격 열 클릭해 정렬 변경 | 1위가 HomeNest(537건)→MobiCore(516건, 평균가 223,058원)로 바뀜 | "평균가가 가장 높은 브랜드는 MobiCore지만 상품 수는 많지 않다" | 상품 수 열 다시 클릭해 정렬 원복 | 성공 |

- 두 행동이 서로 다른 이유: 행동1은 Control(전역 필터)로 여러 패널이 동시에 좁혀지는 상호작용이고, 행동2는 한 Table 안에서 정렬 기준만 바꾸는 상호작용이라 영향 범위가 다름
- 사용자가 멈추거나 헷갈린 지점: 행동1에서 category Control이 다른 index(products) 패널까지 전역 적용되어 "N/A"/"No results found"가 뜬 부분 — 처음엔 오류로 오해했으나 원인(값 체계가 다른 index)을 확인함
- 캡처 파일: `../day-04/screenshots/06-category-control-applied.png`

## (개인·필수) 문제 2 — 핵심값 3개 교차 검증

Dashboard의 핵심값 3개를 Discover, `_count`, 또는 aggregation 요청과 비교하세요. `Inspect`는 Dashboard 편집 모드에서 해당 패널의 `Panel menu`에 있습니다. 권한이나 화면 상태로 보이지 않으면 Discover 또는 제공 요청 파일로 검증합니다.

| Dashboard 패널·값 | 동일하게 맞춘 시간·조건 | 비교 방법 | 비교값 | 일치 여부 | 다르면 확인한 원인 |
|---|---|---|---:|---|---|
| 내 등록 상품 수 Metric (5,000) | 조건 없음 | `GET /vintage-items/_count` | 5,000 | 일치 | - |
| category Control="아우터" 적용 시 808 | category=아우터 | `POST /vintage-items/_count` `{"term":{"category":"아우터"}}` | 808 | 일치 | - |
| 카테고리별 평균 가격 — 상의 82,824.615 | category=상의 | `POST /vintage-items/_search` avg agg on price | 82,824.615 | 일치 | - |

- 비교에 사용한 요청 파일 또는 Discover 캡처: Kibana Dev Tools Console에서 직접 실행 (`requests.http`의 Day2 T16 집계 패턴과 동일한 방식)
- 세 값을 신뢰할 수 있는 이유: Dashboard가 화면에 보여주는 숫자와, ES에 직접 요청한 count·aggregation 결과가 소수점까지 정확히 일치함을 확인했기 때문에 Dashboard 집계 로직이 실제 데이터를 왜곡 없이 그대로 반영하고 있다고 판단할 수 있음

## (개인·필수) 문제 3 — 문제 하나를 실제로 수정하고 재검증

제목, field, 집계, 정렬, 구간, 시간, filter, layout 중 한 문제를 골라 수정하세요. 문제가 없다고 생각되면 사용성 문제 하나를 개선합니다.

- 발견한 문제: category Bar의 기본 제목이 "Top 9 values of category"로, 실제로는 카테고리가 6종류뿐인데 "9"라는 숫자가 표시돼 사용자가 "카테고리가 9개나 있나?" 오해할 수 있음
- 문제 유형: 제목(설정값과 실제 데이터 불일치)
- 수정 전 설정 또는 결과: Number of values = 9로 설정, 실제 표시된 막대는 6개뿐이라 제목과 실제 내용이 안 맞음
- 추정 원인: Lens의 Top values 기본값(9)을 그대로 두고 실제 고유값 수(6)에 맞게 조정하지 않음
- 수정한 한 가지: Number of values를 9 → 6으로 변경
- 수정 후 결과: 제목이 "Top 6 values of category"로 바뀌고, 실제 데이터(6개 카테고리)와 표시 개수가 일치함
- 같은 조건 재검증 결과: 막대 6개(원피스, 아우터, 가방, 신발, 상의, 하의) 그대로 유지되며 값도 동일
- 개선/보류/악화 판정과 근거: 개선. 실제 데이터 개수와 제목의 숫자가 일치해 사용자가 오해할 여지가 사라짐
- 수정 전·후 캡처: 수정 전 `../day-04/screenshots/05-all-panels.png` (Top 9로 표시된 상태)

## (개인·필수) 문제 4 — 결과 3·한계 2·필요 데이터 1과 제출

### 결과 3개

1. 조건: 전체(필터 없음) / 핵심값: 5,000건 / 비교: `GET /vintage-items/_count`와 정확히 일치 / 판단: 개인 데이터가 Dashboard에 정상 반영됨
2. 조건: category=아우터 / 핵심값: 808건, 판매완료 비율 32.18% / 비교: ES count 일치 / 판단: 아우터는 전체 평균 판매율(30.18%)보다 소폭 높아 상대적으로 잘 팔리는 카테고리로 보임
3. 조건: category=상의 / 핵심값: 평균 가격 82,824.615원(전체 카테고리 중 최고) / 비교: ES aggregation과 일치 / 판단: 상의가 가장 프리미엄 가격대의 카테고리 → 프라이싱·사입 우선순위 참고 가능

### 현재 데이터의 한계 2개

1. `price`와 `original_price`가 서로 독립적으로 생성돼 실제 할인율 계산에는 부적합함 (간혹 `original_price < price`인 경우 존재, `data/generation-notes.md`에 이미 기록된 한계)
2. 판매 완료 시점(sold_date)이 없어 "얼마나 빨리 팔렸는지" 같은 시간 기반 분석은 현재 데이터로 답할 수 없음 (listed_date만 있고 sold=true 상품의 실제 판매일이 없음)

### 추가로 필요한 데이터 1개

- field: sold_date
- mapping type: date
- 예시값: "2026-08-25T00:00:00Z"
- 값 분포·생성 규칙: sold=true인 문서에만 존재(sold=false면 결측), listed_date 이후 0~60일 사이 균등 랜덤으로 생성
- 추가되면 답할 수 있는 질문: 카테고리별 평균 판매 소요 기간은 얼마인가? 어떤 상태등급이 더 빨리 팔리는가?

### 제출 기록

- Dashboard 제목: D4 개인 미션 - 빈티지마켓 - chayh414 (저장 시 이 이름 사용)
- 전체 화면 캡처 경로: `../day-04/screenshots/06-category-control-applied.png`
- JSON export 경로(선택): (미실행, 선택 사항)
- `dashboard-plan.md` 경로: `evidence/day-04/dashboard-plan.md`
- `dashboard-review.md` 경로: `evidence/day-04/dashboard-review.md` (미작성, 다음 작업)
- 개인 저장소 commit SHA: (커밋 후 기록)
- 미완료 또는 알려진 제한 사항: 공통 products 6패널 Dashboard를 별도로 완성·저장하지 않음(개인 vintage-items 패널 위주로 진행). Donut hole 스타일(sold 비율 차트) 미적용, Pie 형태로 대체. 제출 전 공통 Dashboard 보완 필요

PDF 메뉴가 없으면 정상입니다. 현재 수업 환경의 `More → Export`는 Dashboard JSON을 제공하며, 관련 객체까지 옮길 때는 `Stack Management → Kibana → Saved Objects → Export`를 사용합니다. 화면 캡처를 기본 근거로 제출합니다.

## (선택 도전) 문제 5 — 다른 사람이 재현할 수 있는지 점검

자신의 기록만 보고 다음 항목을 다시 수행해 보거나 옆 학생에게 문서만 보여 줍니다.

- [ ] 올바른 Data View를 선택할 수 있다.
- [ ] 시간 범위를 동일하게 맞출 수 있다.
- [ ] Control/Filter 조건을 재현할 수 있다.
- [ ] 핵심값 3개의 비교 근거를 찾을 수 있다.
- [ ] Dashboard를 초기 상태로 복구할 수 있다.

- 재현에 부족했던 설명:
- 추가한 설명:
- 최종 재현 판정:

## Day 4 최종 완료 신호

- GREEN: 필수 32문제의 요구 산출물, 개인 Dashboard, plan/review, 캡처, commit 완료
- YELLOW: Dashboard는 있으나 검증·개선·commit 중 하나가 미완료
- RED: 저장된 Dashboard 또는 제출 근거가 없음


