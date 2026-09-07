# 빈티지·세컨핸드 의류 마켓 검색

Elasticsearch로 만든 빈티지 의류 검색 서비스 — 5일 PBL 과정 개인 프로젝트

가격 대비 상태 좋은 빈티지·디자이너 브랜드를 찾는 구매자를 위한 검색 엔진. 데이터 모델링부터 검색 로직, Kibana Dashboard, 검색 웹앱 시연까지 전 과정을 직접 설계·구현.

> 강사 배포 원본: [djkorea/es-5days-pbl-course](https://github.com/djkorea/es-5days-pbl-course)

---

## 한눈에 보기

| | |
|---|---|
| **데이터** | `vintage-items` index · 문서 5,000건 · field 18개 (seed 고정, 재현 가능) |
| **검색** | 전문 검색 · 정확 조건 · bool 조합 · 정렬 2단계 · highlight |
| **Dashboard** | Kibana Lens 4패널, ES 실측값과 교차 검증 완료 |
| **검색 앱** | FE·BE 템플릿에 내 index 연결, 브라우저 시연 가능 |

## 진행 현황

| Day | 내용 | 상태 |
|---|---|---|
| Day 1 | 주제·사용자·문서 단위 설계 | ✅ |
| Day 2 | index/mapping 생성 · 데이터 5,000건 생성·적재 | ✅ |
| Day 3 | 검색 기능 구현 · 품질 점검 | ✅ |
| Day 4 | Kibana Dashboard (개인) | ✅ · 공통 Dashboard는 보완 예정 |

## 프로젝트

- **사용자**: 빈티지 마켓 구매자(검색) / 운영자(Dashboard로 재고·가격 전략 파악)
- **문서 1건**: 중고 의류 상품 — 예) 리바이스 505 빈티지 데님 자켓, A급, 27,000원, 번개장터
- 상세: [`docs/pbl-start-card.md`](docs/pbl-start-card.md) · [`docs/data-model.md`](docs/data-model.md)

## 검색 질문 3개

| 질문 | 구현 |
|---|---|
| 3만원 이하, A급 이상 데님 자켓 | `bool`(전문 검색 + filter 4개), `operator:"and"`로 관련성 개선 (14건 → 1건) |
| 90년대 브랜드 옷을 평점 높은 순으로 | `term`(era) + 1·2차 정렬(seller_rating desc → price asc) |
| 하자 언급 없는 상품만 | `bool.must_not`(match) |

→ [`requests.http`](requests.http) · [`docs/quality-test.md`](docs/quality-test.md) · [`evidence/day-03-search.md`](evidence/day-03-search.md)

## Dashboard

`vintage-items` 개인 Dashboard 4패널 (Kibana Lens):

- 전체 등록 상품 수 — **5,000**
- 카테고리별 평균 가격 — 상의 최고가(**82,824원**)
- 가격 구간별 상품 수 — 120,000~150,000원대 최다
- 판매완료 비율 — true **30.18%**

category Control로 여러 패널 동시 필터링 구현, 화면 값과 ES 실측 쿼리 결과 대조해 전량 일치 검증.

→ [`evidence/day-04/dashboard-plan.md`](evidence/day-04/dashboard-plan.md) · [`evidence/day-04/dashboard-review.md`](evidence/day-04/dashboard-review.md) · [screenshots](evidence/day-04/screenshots/)

> 공통 `products` 6패널 Dashboard는 시간 관계상 미완성 — 제출 전 보완 예정

## 검색 앱 시연

```powershell
cd search-app-template
./start.ps1
```
→ `http://localhost:3000` — "데님", "아우터" 검색, highlight·실행 쿼리 확인 가능

## 동작 원리

전체 요청 흐름:

```text
브라우저 검색어
  → FE (search-app-template/public)
  → BE (server.mjs, 고정 코드)
  → search-request.json 의 Query DSL ({{searchText}}를 실제 검색어로 치환)
  → POST /vintage-items/_search
  → 결과 → FE 카드 렌더링 (제목·설명·badge·meta)
```

### index 설계 기준

- **text**: 자유 검색이 필요한 field만 — `item_name`, `description`, `defects`
- **keyword**: 정확 매칭·필터·집계용 — `category`, `brand`, `brand_tier`, `condition`, `era`, `material`, `platform`, `size`, `color`
- **integer/float/date/boolean**: `price`/`original_price`(integer), `seller_rating`(float), `listed_date`(date), `sold`(boolean)
- **item_id**(keyword): `_id`와 같은 값을 별도 field로도 저장 — 데이터 생성기가 "업무 ID"와 "_id"를 분리해서 다루는 구조라 맞춘 것
- `dynamic: strict` — 오타 field가 실수로 색인되는 것을 막음

### 데이터 생성 로직

- `data/pbl-data-template/my-data-settings.ps1`에 seed(20260902) 고정 → 실행할 때마다 같은 5,000건이 재현됨
- 대표 문서 3건은 `FixedDocumentsFile`로 고정해 순번 1~3 자리에 그대로 심고, 나머지는 vocab 목록 기반 랜덤(가중치 있는 `condition`·`defects` 포함)으로 생성
- 재현 방법: `data/generation-notes.md`에 정리된 3단계 스크립트(generate → validate → load) 그대로 실행

### 검색 로직

- **filter vs must**: 점수가 필요 없는 정확 조건(가격 범위, 카테고리 등)은 `filter`(빠르고 캐시됨), 관련도 순위가 필요한 자유 검색어는 `must`
- **match의 함정**: 기본 `operator`가 `or`라서 "데님 자켓" 검색 시 "데님"이나 "자켓" 중 하나만 있어도 매칭됨 → `operator:"and"`로 바꿔 관련 없는 결과(14건→1건)를 제거한 실제 개선 사례가 `evidence/day-03-practice/period-08-integration.md`에 있음
- **정렬**: 1차 기준이 동률일 때 2차 기준으로 순서를 고정 (예: `seller_rating desc` → `price asc`)

### Dashboard 데이터 흐름

- Kibana Lens 패널은 내부적으로 동일한 ES aggregation을 실행 — 화면 숫자는 곧 ES 실제 집계값 (그래서 `curl`로 직접 재현해 값이 정확히 일치하는지 검증했음)
- **Control(field 기반 필터)은 같은 field 이름을 쓰는 모든 패널에 전역 적용됨** — 공통 `products`와 개인 `vintage-items`를 한 Dashboard에 섞어두고 `category` Control을 걸었더니, `products`엔 없는 값("아우터")이라 그쪽 패널이 깨지는 걸 직접 확인함 (`evidence/day-04-practice/period-07-personal-build.md` 참고)

### 검색 앱 연결 로직

- `app.config.json`: 화면에 뭘 보여줄지(카드 field 매핑)만 담당, 검색 로직과 무관
- `search-request.json`: 실제 Query DSL 원본. `{{searchText}}`라는 문자열이 사용자가 입력한 검색어로 그대로 치환되어 BE가 ES에 전달 — 이 파일만 바꾸면 검색 로직 전체가 바뀜

## 구조

```text
docs/                  주제 · 데이터 모델 · 검색 품질
elasticsearch/          index mapping
data/                    대표 문서 · 생성기 설정 · 생성 기록
requests.http            전체 실행 요청 (Day 2~3)
evidence/                실행 결과 · 증거 (Day 2~4)
search-app-template/    검색 웹앱 (내 index 연결됨)
```

