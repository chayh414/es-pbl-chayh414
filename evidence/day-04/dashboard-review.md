# Day 4 Dashboard 테스트·해석·개선 기록

## 1. 기본 상태

- Dashboard 제목: D4 개인 미션 - 빈티지마켓 - chayh414
- Data View: vintage-items (일부 패널은 공통 참고용 products 병행)
- 시간 범위: Last 2 years
- 전체 문서 수: 5,000 (vintage-items)
- 패널 수: 4개(Q1 Metric, Q2 카테고리별 평균 가격, Q3 가격 구간별 상품 수, Q4 판매완료 비율) + 참고용 공통 products 패널 일부

## 2. filter/control 전후 테스트

| 항목 | 적용 전 | 적용 조건 | 적용 후 | Clear 후 | 정상 여부 |
|---|---:|---|---:|---:|---|
| 내 등록 상품 수 Metric | 5,000 | category Control = 아우터 | 808 | 5,000 | 정상 |
| 판매완료 비율 Donut | true 30.18% | category Control = 아우터 | true 32.18% | true 30.18% | 정상 |
| 공통 products 전체 상품 수 Metric | 20,000 | category Control = 아우터 | N/A(무관한 index category 값이라 결과 없음) | 20,000 | 예상 밖 부작용이나 Clear 후 정상 복구 확인 |

## 3. 핵심값 교차 검증

| Dashboard 값 | 비교 화면/요청 | 비교값 | 일치 여부 | 다르면 확인한 원인 |
|---|---|---:|---|---|
| 5,000 (전체) | `GET /vintage-items/_count` | 5,000 | 일치 | - |
| 808 (category=아우터) | `POST /vintage-items/_count` (term category:아우터) | 808 | 일치 | - |
| 82,824.615 (상의 평균가) | `POST /vintage-items/_search` avg(price) where category=상의 | 82,824.61529... | 일치(반올림 차이만) | - |

## 4. 결과 해석

1. 전체(조건 없음)에서 5,000건이 확인됐고 ES `_count`와 정확히 일치했다. 따라서 Dashboard 집계를 신뢰할 수 있으며, 다음으로 카테고리별 세부 분석을 진행한다.
2. category=아우터 조건에서 판매완료 비율이 32.18%로 전체 평균(30.18%)보다 소폭 높았다. 다만 상품 하나의 정확한 판매 시점 데이터가 없으므로 "얼마나 빨리 팔렸는지"까지는 단정할 수 없다.

## 5. 말할 수 없는 것

- `price`와 `original_price`가 독립적으로 생성돼 실제 할인율을 신뢰성 있게 계산할 수 없다.
- `sold_date`가 없어 "판매까지 걸린 기간"이나 "최근 판매 추세"는 현재 데이터로 단정할 수 없다.
- 내 Dashboard에서 단정할 수 없는 것: category=아우터의 판매율이 다른 카테고리보다 "확실히 우수하다"고 말할 수 없음 — 표본 크기(808건)는 충분하지만 계절성·마케팅 등 다른 변수를 통제하지 않은 단순 비교이기 때문

## 6. 개선 전·후

- 발견한 문제: category Bar 제목이 "Top 9 values of category"였는데 실제 카테고리는 6종류뿐이라 숫자가 실제와 안 맞음
- 개선 전 설정 또는 화면: Number of values = 9
- 수정한 내용: Number of values를 6으로 변경
- 수정한 이유: 제목의 숫자와 실제 표시되는 데이터 개수를 일치시켜 오해를 없애기 위해
- 개선 후 확인 결과: 제목이 "Top 6 values of category"로 바뀌고 막대 6개(원피스/아우터/가방/신발/상의/하의) 값은 그대로 유지됨

## 7. 최종 제출 체크

- [x] 모든 패널 제목이 질문과 연결된다.
- [x] 라벨·숫자·축이 겹치거나 잘리지 않는다.
- [x] 의도하지 않은 KQL·filter pill이 남아 있지 않다 (category Control은 의도한 것이며 Any로 복구됨).
- [x] filter/control이 관련 패널에 함께 적용된다.
- [ ] 저장 후 다시 열어도 같은 상태가 복구된다 (아직 최종 저장 전).
- [x] 전체 화면 캡처를 저장했다.
- [ ] 개인 저장소에 commit했다 (다음 작업).
