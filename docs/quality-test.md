# 검색 품질 점검표

각 행에 자신의 PBL 검색 질문과 실제 결과를 기록합니다. 결과 수만 적지 말고, 상위 결과가 질문 의도에 맞는지 확인합니다.

| 번호 | 검색 질문 | 요청 파일/조건 | 기대 결과 | 실제 결과 요약 | 개선 여부·근거 |
|---|---|---|---|---|---|
| 1 | 3만원 이하, A급 이상 상태의 데님 자켓을 찾고 싶다 (bool/filter) | `requests.http` V1-T21-2-P — `bool.must`(match item_name, `operator:"and"`) + `filter` 4개(price≤30000, condition in[S,A], category=아우터, material=데님) | item_name에 "데님"과 "자켓"이 둘 다 있는 상품만, 가격·등급·카테고리·소재 조건도 전부 만족 | total 1건(VI-00001)만 남음. item_name="리바이스 505 빈티지 데님 자켓", price=27000, condition=A급, category=아우터, material=데님 전부 확인 | 개선함. 처음엔 `match`의 기본 operator(or)라서 "데님 아우터" 같은 관련성 낮은 문서 14건이 걸렸는데, `operator:"and"`로 바꿔 정확히 원하는 1건만 남도록 개선 |
| 2 | 90년대 빈티지 브랜드 옷을 판매자 평점 높은 순으로 보고 싶다 (정확 조건+정렬) | `requests.http` V1-T21-1-P — `term era:"90s"` + `sort`(seller_rating desc, price asc) | era=90s인 상품만, 그 안에서 평점 높은 순, 동률이면 저렴한 순 | total 1276건(전체 90s 분포와 정확히 일치). 상위 5건 모두 era=90s, seller_rating=5.0으로 동률, price가 5051→10195→10442→11509→17595로 오름차순 확인 | 개선 불필요. 조건·정렬 모두 기대대로 정확히 동작함 |
| 3 | 설명에 하자(얼룩, 보풀 등) 언급이 없는 상품만 보고 싶다 (0건 대비/제외 조건) | `requests.http` V1-T21-1-P — `bool.must_not`(match defects:"얼룩 보풀 마모 헐거움") | defects에 4가지 하자 단어가 전혀 없는 상품만 (대부분 defects="") | total 3023건. 상위 5건(VI-00001, VI-00003, VI-00004, VI-00006, VI-00007) 전부 defects=""로 확인 | 개선 불필요. `data/generation-notes.md`의 defects 설계(빈 값 60%)와 근사한 비율로 나와 데이터·조건이 일관됨 |

## 의도한 0건 확인

- `requests.http`(및 `evidence/day-03-practice/period-07-quality.md` 문제3)에서 `GET /products/_search { "query": { "term": { "product_id": "__DAY03_INTENTIONAL_ZERO__" } } }` 실행 — index·field는 실제 존재하지만 값이 없어 정상적으로 0건 응답(`hits.total.value: 0`, 에러 없음)을 확인함.

## 최소 기준 체크

- [x] 전문 검색 1개 (Day3 3교시: `multi_match` item_name+description "데님 자켓")
- [x] 정확 조건 검색 1개 (질문 2: `term era:"90s"`)
- [x] bool/filter 검색 1개 (질문 1)
- [x] filter 2개 이상 (질문 1에 4개: price, condition, category, material)
- [x] sort 2개 (질문 2: seller_rating desc + price asc)
- [x] 의도한 0건 조건 1개 (위 참고)
- [x] 예상과 다른 결과 기록 (질문 1: query의 operator를 or→and로 변경해 개선)
