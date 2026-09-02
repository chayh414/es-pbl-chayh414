## 1. 문서 단위

- 개인 index 이름: vintage-items
- 검색 결과 한 줄 / 문서 한 건의 의미: 중고(빈티지·세컨핸드) 의류 상품 1건
- 업무 ID field / 예시 값: item_id / VI-00001
- ES _id와 업무 ID 관계: item_id를 ES의 _id와 동일한 값으로 사용하며, 색인 시 item_id 값을 그대로 _id로 지정함 (생성기가 IdField로 item_id를 사용, 형식 `VI-00001`)

## 2. 질문 3가지

| 번호 | 사용자 질문 | 검색어 | 조건 | 정렬 | 표시 field |
|---|---|---|---|---|---|
| Q1 | 3만원 이하, A급 이상 상태의 데님 자켓을 찾고 싶다 | "데님 자켓" (item_name) | price ≤ 30000, condition in [S급, A급], category=아우터, material=데님 | 없음 (또는 price 오름차순) | item_name, price, condition, brand |
| Q2 | 90년대 빈티지 브랜드 옷을 판매자 평점 높은 순으로 보고 싶다 | 없음 | era=90s | seller_rating 내림차순 | item_name, brand, era, seller_rating |
| Q3 | 설명에 하자(얼룩, 보풀 등) 언급이 없는 상품만 보고 싶다 | 없음 | defects 필드에 "얼룩", "보풀" 등 하자 단어 미포함 (또는 값이 빈 문자열) | 없음 | item_name, condition, defects |

## 3. 필드 & 타입

| field | 예시 값 | 검색/필터/정렬/표시/집계 | type | 질문 번호 | 선택 이유 |
|---|---|---|---|---|---|
| item_id | "VI-00001" | 업무 ID (_id와 동일) | keyword | - | 문서 식별자, 생성기 IdField로 사용 |
| item_name | "리바이스 505 빈티지 데님 자켓" | 검색, 표시 | text | Q1 | 자유 검색어로 상품명 매칭 필요 |
| category | "아우터" | 필터, 집계 | keyword | Q1 | 정해진 값 중 정확히 일치해야 함 |
| brand | "Levi's" | 필터, 표시 | keyword | Q1,Q2 | 브랜드명 정확 매칭/집계 |
| brand_tier | "일반" | 필터 | keyword | - | 디자이너/하이엔드/일반 등급 정확 분류 |
| size | "M" | 필터, 표시 | keyword | - | 사이즈 정확 매칭 |
| color | "인디고" | 필터, 표시 | keyword | - | 색상 정확 매칭 |
| condition | "A급" | 필터 | keyword | Q1 | S/A/B급 등급, 순서 비교 아닌 정확 매칭 |
| price | 27000 | 필터(범위), 정렬 | integer | Q1 | 가격 범위 조건과 정렬에 숫자 연산 필요 |
| original_price | 52000 | 표시 | integer | - | 할인율 계산 참고용 |
| era | "90s" | 필터 | keyword | Q2 | 90s/2000s/2010s 정확 매칭 |
| material | "데님" | 필터, 검색 | keyword | Q1 | 소재 정확 매칭 |
| platform | "번개장터" | 필터, 표시 | keyword | - | 거래 플랫폼 정확 매칭 |
| seller_rating | 4.6 | 정렬 | float | Q2 | 평점 높은 순 정렬에 소수 연산 필요 |
| listed_date | "2026-08-22" | 정렬, 표시 | date | - | 등록일 기준 정렬/필터 가능성 |
| sold | false | 필터 | boolean | - | 판매완료 여부 참/거짓 |
| description | "..." | 검색, 표시 | text | - | 자유 텍스트 검색 |
| defects | "" | 검색(존재 여부) | text | Q3 | 하자 단어 포함 여부 또는 빈 값 확인 |

- 배열/객체 여부와 제공 생성기 지원 범위: 배열/객체 필드 없음. 모두 평면(flat) 구조로 생성기 기본 지원 범위 내에서 처리 가능
- 제외한 개인정보/불필요한 field와 이유: 판매자 실명, 연락처, 계좌번호, 실제 배송지 — 실거래가 아닌 합성 데이터 실습이라 개인정보 불필요
- 자가 점검으로 수정한 내용: (진행하며 채우기)
- 완전한 mapping: ../elasticsearch/index-create.json

## 4. 대표 문서 JSON

```json
{
  "item_id": "VI-00001",
  "item_name": "리바이스 505 빈티지 데님 자켓",
  "category": "아우터",
  "brand": "Levi's",
  "brand_tier": "일반",
  "size": "M",
  "color": "인디고",
  "condition": "A급",
  "price": 27000,
  "original_price": 52000,
  "era": "90s",
  "material": "데님",
  "platform": "번개장터",
  "seller_rating": 4.6,
  "listed_date": "2026-08-22",
  "sold": false,
  "description": "90년대 리바이스 데님 자켓, 색빠짐 없이 깔끔함",
  "defects": ""
}
```