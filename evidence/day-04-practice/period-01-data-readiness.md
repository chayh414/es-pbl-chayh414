# 1교시 연습 — Data View·Discover·KQL·데이터 준비 상태

- 필수 권장 시간: 38분
- 선택 도전: 7분
- 제출 상태 확인: 5분
- 시작 기준: Kibana 접속 가능
- 화면 순서: [Data View·Discover 상세 가이드](../KIBANA_9_5_STEP_BY_STEP.md#1-data-view-만들기-또는-기존-data-view-확인하기)

## (공통·필수) 문제 1 — Dashboard를 만들 수 있는 데이터인지 확인

강사가 지정한 `products` Data View를 선택하고 다음 항목을 확인하세요.

- index pattern: `products`
- time field: `created_at`
- 실제 field: `product_id`, `name`, `category`, `brand`, `price`, `in_stock`, `created_at`
- Discover 전체 문서 수: 20,000

### 결과 입력

- 선택한 Data View 이름: products
- index pattern: products
- time field: created_at
- 확인한 7개 field: product_id, name, category, brand, price, in_stock, created_at 전부 Available fields에서 확인
- 사용한 절대 시간 범위: Last 2 years
- Discover 실제 문서 수: 20,000
- 정상/보류/오류: 정상 (처음엔 기본 시간 범위 "Last 15 minutes"라 0건이었으나, 시간 범위를 "Last 2 years"로 넓히자 20,000건 확인됨)
- 판정 근거: `products` index의 `created_at`이 2025~2026년에 분산돼 있어 짧은 기본 시간 범위에는 걸리지 않았던 것. 범위를 넓히니 기대한 20,000건이 정확히 나옴
- 캡처 파일: (회원님 로컬 스크린샷 경로로 채워주세요)

## (공통·필수) 문제 2 — KQL 적용 전후를 비교

Discover의 전체 20,000건 상태에서 다음 KQL을 실행하세요.

```text
in_stock : false
```

결과를 기록한 뒤 KQL을 지우고 전체 상태로 복구하세요.

### 비교 결과

| 확인 항목 | 적용 전 | 적용 후 | KQL 제거 후 |
|---|---:|---:|---:|
| 문서 수 | 20,000 | 3,001 | 20,000 |

- 적용 후 대표 문서 ID 2개: P-03985, P-14019
- `in_stock` 값 확인: 둘 다 false로 확인됨
- 복구 성공 여부: 성공 (검색창 지우고 다시 20,000건으로 복구됨)
- 캡처 파일: (회원님 로컬 스크린샷 경로로 채워주세요)
- KQL이 데이터를 삭제한 것인가? 이유: 아니오. KQL은 "화면에 어떤 문서를 보여줄지" 걸러내는 조건일 뿐, ES에 저장된 실제 문서는 전혀 지워지지 않는다. 실제로 검색창을 지우니 즉시 20,000건 전체가 그대로 다시 보였다.

## (진단·필수) 문제 3 — 0건 또는 일부 데이터만 보이는 상황 복구

다음 상황을 가정합니다.

> Discover에서 데이터가 0건이거나 예상보다 적게 보인다. index가 지워졌다고 단정하지 않고 원인을 확인한다.

아래 순서로 현재 화면을 점검하세요.

1. 시간 범위
2. 선택한 Data View
3. KQL 입력
4. filter pill
5. field가 실제 mapping에 존재하는지

실제 화면에서 조건 하나를 일부러 적용해 건수를 줄였다가 다시 복구해도 됩니다.

### 진단 기록

(문제 1을 진행하며 실제로 겪은 상황을 그대로 기록함 — 일부러 재현한 게 아니라 처음 Data View를 만들었을 때 실제로 발생했음)

- 재현한 증상: Discover에서 "No results match your search criteria" — 0건
- 마지막 정상 상태: Data View는 `products`로 정확히 선택돼 있었고 index pattern·필드도 정상 인식됨(스크린샷상 Available fields에 0으로 나왔으나 이는 시간 범위 문제 때문)
- 확인한 항목과 순서: 1) 시간 범위 확인 → 우측 상단이 `Last 15 minutes`로 설정돼 있었음. Data View·KQL·filter pill·field 존재 여부는 문제 없었음
- 발견한 원인: 시간 범위가 지나치게 좁음. `created_at` 값이 2025~2026년에 걸쳐 분산돼 있는데 최근 15분만 조회하고 있어서 조건에 맞는 문서가 화면상 하나도 없었던 것 (index 삭제나 데이터 손실이 아님)
- 수정한 내용: 시간 범위를 `Last 2 years`로 확장 (`Search entire time range` 버튼으로도 동일하게 해결 가능)
- 수정 후 문서 수: 20,000
- 다음부터 먼저 확인할 항목: 시간 범위 — 0건이나 예상보다 적은 결과가 보이면 index 삭제를 의심하기 전에 항상 시간 범위부터 확인한다
- 캡처 파일: (회원님 로컬 스크린샷 경로로 채워주세요, 이미 주신 `../day-04/screenshots/01-discover-0hits.png`가 "0건" 상태 캡처에 해당)

## (개인·필수) 문제 4 — 내 데이터 준비 상태 카드

자기 index 또는 준비 중인 데이터에서 Dashboard 질문 하나를 정하고 필요한 field를 점검하세요. 개인 Data View가 아직 없다면 mapping·샘플 문서로 판단합니다.

### 개인 답안

- 내 주제: 빈티지·세컨핸드 의류 상품 검색
- 한 문서가 의미하는 대상 또는 사건: 중고(빈티지·세컨핸드) 의류 상품 1건
- Dashboard 사용자: 빈티지 마켓 구매자 및 운영자
- 사용자가 내릴 판단: 어떤 카테고리·상태등급의 상품이 많이 등록/판매되는지, 가격·재고 전략을 어떻게 조정할지
- 첫 분석 질문: 카테고리별 평균 가격은 얼마인가?
- 필요한 field: category, price
- 각 field의 mapping type: category=keyword, price=integer
- 실제 존재 여부: 존재함 (`elasticsearch/index-create.json` mapping에 둘 다 있음)
- 데이터 문서 수: 5,000 (Day 2에서 생성·적재 완료)
- A 개인 데이터 사용 / B 공통 products 사용+보강 설계 / C 공통 실습+개인 청사진 중 선택: A
- 선택 이유: 개인 index(vintage-items)에 이미 필요한 field와 충분한 문서 수(5,000건)가 갖춰져 있어 공통 products로 대체하거나 보강할 필요가 없음
- 부족한 데이터와 다음 행동: 현재 없음. 다만 6~7교시(개인 질문 4개) 설계 시 추가로 필요한 field가 생기면 그때 다시 점검

## (선택 도전) 문제 5 — 서로 다른 KQL 3개 설계

`products`에서 category, price, in_stock 중 서로 다른 field를 사용한 KQL 3개를 만들고, 한 번에 한 조건만 실행하세요.

| KQL | 질문 | 결과 수 | 대표 문서 | 조건 제거 후 20,000 복구 |
|---|---|---:|---|---|
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |

## 교시 완료 신호

- GREEN: 필수 1~4 완료, 마지막 상태 20,000, KQL/filter 없음
- YELLOW: 결과는 있으나 수치·시간·field 중 하나가 다름
- RED: Data View 또는 Discover에서 데이터를 확인할 수 없음

