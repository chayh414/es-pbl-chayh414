# Day 2 데이터 준비 결과

> 예시 문장을 복사하지 말고 자신의 실제 실행 결과를 작성합니다.
> 실행하지 않은 항목은 완료로 표시하지 않습니다.

## 1. Index와 문서

- Index 이름: vintage-items
- 문서 한 건의 의미: 중고(빈티지·세컨핸드) 의류 상품 1건
- 실제 색인 건수: 3건 (대표 문서만 수기 색인, 대량 생성은 아직 미실행)
- Mapping의 `dynamic` 설정: `strict`

## 2. 최종 Field

| Field | Type | 검색에서 사용할 목적 |
|---|---|---|
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

- 생성 건수: 미실행 (아직 생성기 실행 전)
- 로컬 검증 결과: 미실행
- Bulk 색인 결과: 미실행
- ES 실제 `_count`: 3 (대표 문서 3건만)
- 분류·숫자·boolean 분포 확인 결과: 미실행 (데이터 3건뿐이라 분포 확인 의미 없음)

## 4. Day 3 연결

- 검색 질문 기준: `docs/data-model.md`의 사용자 질문 3개

## 5. 결과 파일 위치

- Mapping: `elasticsearch/index-create.json`
- 실행 요청: `requests.http`
- 대표 문서: `data/sample-documents.json`
- 데이터 생성 설정: 아직 없음 (`data/pbl-data-template/` 개인 복사·설정 전)
- 생성 표본: 아직 없음
- 생성 요약: 아직 없음

## 6. Pipeline 적용 판단

- 적용 / 미적용 / 보류: 보류
- 판단 이유: 아직 대량 데이터 생성·적재 전이라 pipeline 필요 여부(예: 값 정규화, 파생 field 계산)를 판단할 데이터가 부족함. T15~T16 진행 후 확정 예정

## 7. 미완료·오류

- 없음 또는 현재 상태: 대표 문서 3건 색인, index mapping/shard 검증 완료. `_analyze` 3개 검색어 비교 완료(item_name이 커스텀 analyzer 없이 standard를 그대로 씀을 확인). CRUD(임시 문서 생성/수정/삭제) 요청은 작성했으나 아직 미실행.
- 다음에 할 작업: CRUD 실행 및 결과 확인, `data/pbl-data-template/` 개인 복사·설정, 최소 1,000건 생성·로컬 검증·Bulk 적재, aggregation(terms/stats) 확인, pipeline 적용 여부 최종 판단
