# Day 4 개인 Dashboard 설계

## 1. 사용자와 목적

- 내 주제: 빈티지·세컨핸드 의류 상품 검색
- 이 Dashboard를 볼 사람: 빈티지 마켓 운영자(판매자)
- Dashboard를 보고 결정하거나 행동할 것: 어떤 카테고리·가격대·상태등급의 상품이 많이 등록돼 있는지 파악해 사입·프라이싱·홍보 전략을 조정
- 사용할 index / Data View: vintage-items

## 2. 데이터 준비 경로

- [x] A: 개인 데이터로 제작
- [ ] B: 공통 products로 제작하며 개인 데이터 보강 규칙 작성
- [ ] C: 공통 Dashboard를 완성하고 개인 청사진에 집중

선택 이유: 개인 index(vintage-items)에 이미 5,000건의 문서와 필요한 모든 field(category, brand, price, condition, sold 등)가 준비돼 있어 공통 데이터로 대체하거나 보강할 필요가 없음

## 3. 질문-데이터-차트 청사진

| 번호 | 분석 질문 | 필요한 field | 현재 존재? | mapping type | 계산·그룹 방식 | 차트 | filter/control | 확인 기준 |
|---|---|---|---|---|---|---|---|---|
| Q1 전체 규모 | (없음, Records) | 존재 | - | Count of records | Metric | 없음 | 5,000 |
| Q2 그룹 비교 | category, price | 존재 | keyword, integer | category Top values + Average(price) | Bar 또는 Table | 없음 | 카테고리 6개, 각 평균 가격 확인 |
| Q3 분포/정확한 값 | price | 존재 | integer | Custom ranges(30,000원 단위) + Count | Bar | 없음 | 120,000~150,000 구간 최다(이미 확인) |
| Q4 상태/시간 | sold | 존재 | boolean | Top values + Count | Donut | 없음 | true/false 비율, 합계 5,000 |

## 4. 데이터 부족 분석

- 현재 데이터로 답할 수 없는 질문: (필수 질문 4개는 모두 가능함) — 참고로 도전적인 5번째 질문을 가정하면 "브랜드별 재구매 고객 비율" 같은 건 답할 수 없음
- 부족한 field: customer_id·재구매 여부 같은 고객 단위 field (현재 mapping엔 상품 단위 field만 있고 고객/거래 단위 field가 없음)
- 필요한 mapping type: keyword(customer_id), boolean(is_repeat_buyer)
- 필요한 값의 범위·범주·비율: 해당 없음(설계 안 함, 현재 범위 밖 질문)
- 날짜가 필요하다면 기간과 단위: 해당 없음
- 한 문서가 의미할 사건 또는 대상: (가정) 고객 1명의 구매 이력 1건
- 생성 또는 수집 방법: 현재 프로젝트 범위(상품 검색) 밖이라 생성하지 않음. 상품 단위 데이터만으로 답이 가능한 질문 4개로 충분히 완료 기준을 충족함
- 데이터 수가 충분하다고 판단할 기준: 해당 없음

## 5. 제작 순서

1. Q1 Metric(전체 상품 수) — 완료
2. Q3 price 분포 Bar — 완료 (4교시에서 이미 제작)
3. Q2 category별 평균 가격 Bar/Table — 제작 예정
4. Q4 sold 비율 Donut — 제작 예정

## 6. 완료 예상 화면

- Dashboard 제목: D4 개인 Dashboard - 빈티지 마켓
- 필수 패널 수: 4개 (Q1~Q4)
- 사용할 control/filter: 없음(필수 최소 기준만 충족, 선택 도전 시 category control 추가 가능)
- 저장할 캡처 파일명: personal-dashboard.png
