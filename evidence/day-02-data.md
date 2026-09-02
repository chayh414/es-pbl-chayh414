# Day 2 데이터 준비 결과

> 예시 문장을 복사하지 말고 자신의 실제 실행 결과를 작성합니다.
> 실행하지 않은 항목은 완료로 표시하지 않습니다.

## 1. Index와 문서

- Index 이름: vintage-items
- 문서 한 건의 의미: 중고(빈티지·세컨핸드) 의류 상품 1건
- 실제 색인 건수: 5,000건 (대표 문서 3건 포함, 대량 생성·적재 완료)
- Mapping의 `dynamic` 설정: `strict`

## 2. 최종 Field

| Field | Type | 검색에서 사용할 목적 |
|---|---|---|
| item_id | keyword | 업무 ID, _id와 동일 값 |
| item_name | text (keyword sub-field 포함) | 상품명 자유 검색, 정확 매칭/정렬용 keyword |
| category | keyword | 카테고리 필터 |
| brand | keyword | 브랜드 필터/집계 |
| brand_tier | keyword | 브랜드 등급(일반/하이엔드스트릿 등) 필터 |
| size | keyword | 사이즈 필터 |
| color | keyword | 색상 필터 |
| condition | keyword | 상태등급(S/A/B급) 필터 |
| price | integer | 가격 범위 필터, 가격순 정렬 |
| original_price | integer | 할인율 계산 참고용 표시 |
| era | keyword | 연대(90s 등) 필터 |
| material | keyword | 소재 필터/검색 |
| platform | keyword | 판매 플랫폼 필터 |
| seller_rating | float | 평점 높은 순 정렬 |
| listed_date | date | 등록일 정렬/필터 |
| sold | boolean | 판매완료 여부 필터 |
| description | text | 상품 설명 자유 검색 |
| defects | text | 하자 단어 포함 여부 검색 |

## 3. 대량 데이터 생성·색인 결과

- 생성 건수: 5,000건 (Seed 20260902, `data/pbl-data-template/my-data-settings.ps1`)
- 로컬 검증 결과: `LOCAL CHECK PASS: 5000 documents, unique IDs, target index and NDJSON verified.`
- Bulk 색인 결과: `PASS: Bulk item errors=false. Actual count=5000, generated=5000.`
- ES 실제 `_count`: 5000
- 분류·숫자·boolean 분포 확인 결과:
  - category: 아우터808 / 상의850 / 하의860 / 원피스798 / 신발845 / 가방839 (기대: 6종 균등 각~833, 오차 범위 내)
  - condition: S급509(10.2%) / A급1691(33.8%) / B급1802(36.0%) / C급998(20.0%) — 설정 비율(10/35/35/20%)과 일치
  - era: 80s1233 / 90s1276 / 2000s1251 / 2010s1240 (기대: 4종 균등 각~1250, 일치)
  - price: min5,003 / max149,945 / avg78,944 (설정 범위 5,000~150,000 내)
  - seller_rating: min3.0 / max5.0 / avg4.00 (설정 범위 3.0~5.0 내)
  - sold=true: 1,509건(30.18%) — 설정 TrueRatio(30%)와 일치
  - listed_date: 2025-01-01~2026-08-30 (설정 범위와 일치)

## 4. Day 3 연결

- 검색 질문 기준: `docs/data-model.md`의 사용자 질문 3개

## 5. 결과 파일 위치

- Mapping: `elasticsearch/index-create.json`
- 실행 요청: `requests.http`
- 대표 문서: `data/sample-documents.json`
- 데이터 생성 설정: `data/pbl-data-template/my-data-settings.ps1`
- 생성 표본: `data/pbl-data-template/generated/vintage-items-sample-30.ndjson`
- 생성 요약: `data/pbl-data-template/generated/generation-summary.json`

## 6. Pipeline 적용 판단

- 적용 / 미적용 / 보류: 미적용
- 판단 이유: Day 3에서 필요한 전문 검색·필터·정렬·집계는 현재 원본 field(그대로 저장된 값)만으로 충분히 처리 가능해 별도 ingest 가공이 필요하지 않음. 다만 `price`와 `original_price`를 독립적으로 난수 생성해 간혹 `original_price < price`인 경우가 있음 — 실제 할인율 계산 기능을 붙일 경우 pipeline(script processor)으로 값 보정을 검토할 수 있음(현재는 불필요로 판단, 보류 아님).

## 7. 미완료·오류

- 없음 또는 현재 상태: index 생성·mapping/shard 검증, CRUD(생성/조회/수정/삭제) 실습, `_analyze` 비교, 대표 문서 3건 색인, 5,000건 생성·검증·적재, 분류/숫자/boolean 분포 확인까지 전부 완료.
- 다음에 할 작업: Day 3 검색 기능 구현 (전문 검색·filter·sort·highlight, `docs/quality-test.md` 작성)
