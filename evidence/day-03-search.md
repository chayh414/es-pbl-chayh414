# Day 3 검색 구현·품질 검증 산출물

> 공통 쇼핑몰 답을 복사하지 않고 자신의 PBL index와 실제 결과를 기록합니다. 실행하지 않은 결과는 완료로 표시하지 않습니다.

## 1. 실행 기준

- 개인 index: vintage-items
- 수업 시작 시 실제 `_count`: 5000
- 개인 요청 파일: `requests.http` (`V1-T17-P`~`V1-T21-P` 구간)
- 검색 품질 주 문서: `docs/quality-test.md`
- 실행 환경·시각: 로컬 Docker ES 3노드 (Day 1 환경), 2026-09-03

## 2. 검색 질문과 요구사항

| 요청 ID | 사용자 질문 | 검색 field·검색어 | 정확 조건·범위 | 정렬 | 표시·highlight |
|---|---|---|---|---|---|
| Q01 전문 검색 | 3만원 이하 A급 데님 자켓을 찾고 싶다 (검색어 부분) | item_name^3, description / "데님 자켓" | 없음(전문 검색만) | 없음 | 기본 |
| Q02 정확 조건 | 90년대 빈티지 브랜드 옷을 평점 높은 순으로 | era(keyword)="90s" | era=90s | seller_rating desc, price asc | 기본 |
| Q03 bool/filter | 3만원 이하, A급 이상, 데님 자켓 (최종 통합) | item_name(match, operator=and) / "데님 자켓" | price≤30000, condition∈[S급,A급], category=아우터, material=데님 | 없음 | 기본 |

## 3. 실행 전 기대 기준

| 요청 ID | 기대 문서 ID·이유 | 제외 문서 ID·이유 | 의도한 0건 조건 | 경계 포함·제외 기준 |
|---|---|---|---|---|
| Q01 | VI-00001 — item_name에 "데님 자켓"이 그대로 있음 | VI-00002 — item_name에 "데님"·"자켓" 둘 다 없음 | `GET /products/_search {"query":{"term":{"product_id":"__DAY03_INTENTIONAL_ZERO__"}}}` (실제 index/field, 존재하지 않는 값) | 해당 없음 |
| Q02 | era=90s인 문서 전체(예: VI-00181) | VI-00002 — era="2000s"라 조건 불일치 | 해당 없음(term 조건이라 경계 개념 없음) | 해당 없음 |
| Q03 | VI-00001 — 4개 filter와 검색어 전부 만족 | VI-00002(category=하의·condition=B급으로 filter 2개 위반), VI-00531(개선 전 버전에선 포함됐으나 "자켓"이 없어 최종본에선 제외돼야 함) | 해당 없음 | price=30000(VI-00003) 경계 포함이지만 material="나일론"이라 다른 filter에서 걸러짐 |

## 4. 실제 결과와 판정

| 요청 ID | `hits.total.value` | 상위 3개 ID | 조건·경계 통과 | 관련/보류/무관과 근거 | 판정 |
|---|---:|---|---|---|---|
| Q01 | 760 | VI-00001(9.99), VI-00003(7.82), VI-00008(1.94) | 해당 없음 | VI-00001 관련(데님+자켓 둘 다), VI-00003 보류(자켓만 일치, 소재는 나일론), VI-00008 무관(데님만 일치, 원피스) | 통과 |
| Q02 | 1276 | VI-00181(5.0/5051), VI-04505(5.0/10195), VI-02708(5.0/10442) | era=90s 전건 확인, seller_rating 동률에서 price 오름차순 확인 | 3건 모두 관련 (era=90s이고 정렬 기준대로 배치됨) | 통과 |
| Q03 | 1 | VI-00001 | price≤30000, condition=A급, category=아우터, material=데님 전부 만족 | 관련 (유일하게 남은 문서가 정확히 의도한 상품) | 통과 |

## 5. 조건 제거·변형 실험

| 기준 요청 | 바꾼 한 요소 | 변경 전 total·대표 ID | 변경 후 total·새로 들어온/빠진 ID | 관찰한 역할 |
|---|---|---|---|---|
| Q03(5교시 초기 버전, operator 기본값) | `material`="데님" filter 제거 | 14건, 대표 VI-00001 | 15건, VI-00003(material="나일론") 새로 들어옴 | material filter가 소재를 정확히 걸러내는 역할이며, 빼면 다른 소재 상품도 통과함 |

## 6. 실패 원인 진단

- 문제: Q03 초기 버전(5교시)에서 "Dickies 2000s 데님 아우터"(VI-00531)처럼 "자켓"이 없는 문서가 결과에 섞임
- 1차 원인 분류: query
- 확인한 실제 근거: `match`의 기본 `operator`가 `"or"`라서 item_name에 "데님"만 있어도 매칭됨. VI-00531의 score(1.94)가 VI-00001(8.89)보다 훨씬 낮았지만 어쨌든 `hits`에 포함됐음
- 다음 확인 또는 변경: `match`에 `"operator": "and"`를 추가해 "데님"과 "자켓"이 둘 다 있어야 매칭되도록 변경

## 7. 개선 전후

| 문제 | 추정 원인 | 변경한 한 요소 | 같은 조건으로 재실행한 결과 | 개선 판정과 근거 |
|---|---|---|---|---|
| Q03에 "데님 아우터" 등 관련성 낮은 문서 포함 | match의 기본 operator(or) | `operator: "or"` → `"and"` | total 14건 → 1건(VI-00001만 남음) | 개선. 관련 없는 문서가 전부 사라지고 의도한 상품 1건만 정확히 남음 |

## 8. 완료 체크

- [x] 전문 검색 요청 1개 (Q01)
- [x] 정확 조건 요청 1개 (Q02)
- [x] bool/filter 요청 1개 (Q03)
- [x] filter 2개 이상 (Q03에 4개)
- [x] sort 2개 (Q02: seller_rating desc + price asc)
- [x] highlight 1개 (`requests.http` V1-T20-P, description "데님" highlight)
- [x] 의도한 0건 요청 1개 (Q01 기대 기준 참고)
- [x] 상위 3건 사람 평가 (섹션 4)
- [x] 개선 1건과 전후 결과 (섹션 7)
- [x] README의 기능 목록·실행 경로 동기화 (`requests.http`, `docs/quality-test.md`, `evidence/day-03-practice/` 경로 일치)
- [ ] 최종 commit SHA: (커밋 후 기록)
