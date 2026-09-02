# ES 5일 PBL — Day 3 학생교재

- 주제: 검색 기능 구현
- 공통 실습: 쇼핑몰 검색 / ES·Kibana 9.5.0 / 공통 index: `products`
- 이 교재는 PPT와 같은 토픽 ID·실습 흐름을 사용합니다. 교시별 시간과 강사용 발화는 포함하지 않습니다.
- **중요:** 강사는 쇼핑몰 예제로 시연하지만, 여러분은 선택한 도메인의 PBL을 완성합니다. 공통 예제를 그대로 제출하지 마세요.

## 검색 요구와 오늘의 query 구현

사용자 질문·정확 조건·정렬 기준은 오늘 ES query와 filter로 구현합니다. 검색 개념을 먼저 다룬 이유는 API 문법을 외우기 전에, 어떤 요청이 좋은 결과를 만들어야 하는지 판단하기 위해서입니다.

## 오늘의 완료 기준

- 학생이 Search API 요청은 무엇을 찾을지 query, 몇 개를 볼지 size, 어떤 순서인지 sort, 어떤 field를 받을지 _source로 표현합니다.
- 학생이 term은 정확한 값 비교에, match는 분석된 text 검색에 사용합니다.
- 학생이 match_phrase는 단어 순서와 가까운 구문을, multi_match는 여러 text field를 동시에 찾는 데 사용합니다.
- 학생이 filter는 점수보다 조건 충족 여부를 빠르게 좁히는 역할을 합니다.
- 학생이 bool은 must, filter, must_not, should를 하나의 검색 요청으로 합칩니다.
- 학생이 sort·highlight·_source 축소는 결과를 사용자가 읽기 쉽게 표현하는 기능입니다.
- 학생이 품질 점검은 결과 수가 아니라 질문별 기대·제외·0건 기준을 통과했는지 보는 절차입니다.
- 학생이 통합 검색 요청은 이미 만든 기능을 한 질문에 필요한 만큼만 결합하는 최종 실습입니다.

## 오늘 사용할 파일

- `requests/04-search-and-quality.http`
- `QUALITY_TEST_TEMPLATE.md`
- 개인 저장소 루트 `requests.http`
- `docs/quality-test.md`
- `evidence/day-03-search.md`

## 목차

- T17 Search API 기본
- T18-1 정확·전문 검색
- T18-2 전문 검색 확장
- T19-1 필터링·복합 검색
- T19-2 bool 실습
- T20 결과 표현·관련도
- T21-1 검색 품질 점검
- T21-2 PBL 검색 통합

## T17 Search API 기본

- 학생교재 위치: §17 Search API

### 학습 목표

- 학생이 Search API 요청은 무엇을 찾을지 query, 몇 개를 볼지 size, 어떤 순서인지 sort, 어떤 field를 받을지 _source로 표현합니다.
- 쇼핑몰 예제를 내 도메인의 문서·field·검색 질문으로 바꾼다.

### 핵심 개념

응답은 hits.total, hits.hits, _score, _source를 순서대로 읽습니다.

**주의:** 결과 수만 보고 검색 품질이 좋다고 판단하지 않습니다.

### PPT와 연결되는 학습 포인트

1. **검색 요청은 “무엇을 찾고 어떻게 보여 줄지”를 JSON으로 표현합니다.** — 검색 요청은 “무엇을 찾고 어떻게 보여 줄지”를 JSON으로 표현합니다.
2. **GET** — GET · {index} · _search
3. **query, size, sort, _source** — query, size, sort, _source
4. **응답 읽기** — 응답 읽기
5. **기본 검색 시연** — 기본 검색 시연
6. **내 질문 1 → 요청 뼈대** — 내 질문 1 → 요청 뼈대
7. **개인 요청 역번역 점검** — 개인 요청 역번역 점검
8. **T18 연결** — T18 연결

#### PPT 원문 확인

- S02: `GET /{index}/_search`

### 쇼핑몰 데이터 예제

공통 index는 `products`입니다. 상품 문서의 `name`, `description`, `category`, `price`, `rating`, `in_stock`는 역할을 보여 주는 예시입니다. 내 PBL에서는 같은 이름을 복사하지 말고, 예를 들어 도서 검색의 `title`·`genre`·`available`처럼 같은 역할의 field로 대응합니다.

### 개념 실습

```http
GET /products/_search
{ "query": { "match_all": {} }, "size": 5 }
```

#### 진행 순서

1. 공통 쇼핑몰 예제를 먼저 실행하거나 화면에서 확인합니다.
2. 예상 결과를 확인한 뒤, 내 PBL에서 같은 역할을 할 field·값·질문을 정합니다.
3. 내 저장소의 README, `elasticsearch/`, `data/`, `kibana/`, `evidence/` 중 알맞은 파일에 결과를 남깁니다.

#### 예상 결과·확인 기준

- 요청 또는 화면에서 핵심 field·문서·차트가 질문에 맞는지 한 문장으로 설명합니다.
- 결과 수만 보지 말고, 왜 그 결과가 나왔는지 field와 조건을 근거로 설명합니다.

### 오류 해결 팁

결과가 다르면 화면을 닫지 말고 method, path, field 이름, 값의 type, 응답의 error/message를 순서대로 확인합니다.

### 내 PBL 반영

- 내 주제에서 이 토픽과 같은 역할을 하는 문서·field·질문:
- 공통 예제를 내 데이터로 바꿀 때 변경할 값 또는 명령:
- 예상 결과와 실패했을 때 점검할 항목:
- 저장할 파일 경로:

### 복습 체크

- [ ] 학생이 Search API 요청은 무엇을 찾을지 query, 몇 개를 볼지 size, 어떤 순서인지 sort, 어떤 field를 받을지 _source로 표현합니다.
- [ ] 쇼핑몰 예제를 내 도메인에 맞게 한 항목 이상 바꾸었다.
- [ ] 결과 또는 설계 근거를 저장소에 남겼다.
- [ ] 다음 토픽에서 사용할 질문 또는 field를 정리했다.

### 공식 문서

- [Elastic 공식 문서](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-search)

---

## T18-1 정확·전문 검색

- 학생교재 위치: §18.1 정확·전문 검색

### 학습 목표

- 학생이 term은 정확한 값 비교에, match는 분석된 text 검색에 사용합니다.
- 쇼핑몰 예제를 내 도메인의 문서·field·검색 질문으로 바꾼다.

### 핵심 개념

category 같은 keyword와 name 같은 text에 같은 쿼리를 무심코 적용하지 않습니다.

**주의:** 학생은 같은 질문을 term과 match로 각각 실행해 왜 결과가 다른지 기록합니다.

### PPT와 연결되는 학습 포인트

1. **값 전체 비교에는 term, 분석된 문장 검색에는 match를 사용합니다.** — 값 전체 비교에는 term, 분석된 문장 검색에는 match를 사용합니다.
2. **term + keyword** — term + keyword
3. **match + text** — match + text
4. **잘못된 조합** — 잘못된 조합
5. **공통 2요청 실행** — 공통 2요청 실행
6. **내 PBL 두 요청** — 내 PBL 두 요청
7. **판정** — 판정
8. **T18-2 연결** — T18-2 연결

### 쇼핑몰 데이터 예제

공통 index는 `products`입니다. 상품 문서의 `name`, `description`, `category`, `price`, `rating`, `in_stock`는 역할을 보여 주는 예시입니다. 내 PBL에서는 같은 이름을 복사하지 말고, 예를 들어 도서 검색의 `title`·`genre`·`available`처럼 같은 역할의 field로 대응합니다.

### 개념 실습

```http
GET /products/_search
{ "query": { "term": { "category": "전자기기" } } }
```

#### 진행 순서

1. 공통 쇼핑몰 예제를 먼저 실행하거나 화면에서 확인합니다.
2. 예상 결과를 확인한 뒤, 내 PBL에서 같은 역할을 할 field·값·질문을 정합니다.
3. 내 저장소의 README, `elasticsearch/`, `data/`, `kibana/`, `evidence/` 중 알맞은 파일에 결과를 남깁니다.

#### 예상 결과·확인 기준

- 요청 또는 화면에서 핵심 field·문서·차트가 질문에 맞는지 한 문장으로 설명합니다.
- 결과 수만 보지 말고, 왜 그 결과가 나왔는지 field와 조건을 근거로 설명합니다.

### 오류 해결 팁

결과가 다르면 화면을 닫지 말고 method, path, field 이름, 값의 type, 응답의 error/message를 순서대로 확인합니다.

### 내 PBL 반영

- 내 주제에서 이 토픽과 같은 역할을 하는 문서·field·질문:
- 공통 예제를 내 데이터로 바꿀 때 변경할 값 또는 명령:
- 예상 결과와 실패했을 때 점검할 항목:
- 저장할 파일 경로:

### 복습 체크

- [ ] 학생이 term은 정확한 값 비교에, match는 분석된 text 검색에 사용합니다.
- [ ] 쇼핑몰 예제를 내 도메인에 맞게 한 항목 이상 바꾸었다.
- [ ] 결과 또는 설계 근거를 저장소에 남겼다.
- [ ] 다음 토픽에서 사용할 질문 또는 field를 정리했다.

### 공식 문서

- [Elastic 공식 문서](https://www.elastic.co/docs/reference/query-languages/query-dsl/term-query)

---

## T18-2 전문 검색 확장

- 학생교재 위치: §18.2 전문 검색 확장

### 학습 목표

- 학생이 match_phrase는 단어 순서와 가까운 구문을, multi_match는 여러 text field를 동시에 찾는 데 사용합니다.
- 쇼핑몰 예제를 내 도메인의 문서·field·검색 질문으로 바꾼다.

### 핵심 개념

field boost는 중요한 field의 상대적 우선순위를 정하는 것이지 정답을 강제로 만드는 설정이 아닙니다.

**주의:** 한 쿼리에 옵션을 모두 넣기보다 질문 하나에 필요한 옵션만 추가합니다.

### PPT와 연결되는 학습 포인트

1. **검색 대상 field가 둘 이상이면 multi_match를 설계합니다.** — 검색 대상 field가 둘 이상이면 multi_match를 설계합니다.
2. **field boost** — field boost
3. **match_phrase** — match_phrase
4. **공통 multi_match** — 공통 multi_match
5. **boost 비교** — boost 비교
6. **내 PBL 확장** — 내 PBL 확장
7. **기대 결과** — 기대 결과
8. **T19 연결** — T19 연결

### 쇼핑몰 데이터 예제

공통 index는 `products`입니다. 상품 문서의 `name`, `description`, `category`, `price`, `rating`, `in_stock`는 역할을 보여 주는 예시입니다. 내 PBL에서는 같은 이름을 복사하지 말고, 예를 들어 도서 검색의 `title`·`genre`·`available`처럼 같은 역할의 field로 대응합니다.

### 개념 실습

```http
GET /products/_search
{ "query": { "multi_match": { "query": "무선 이어폰", "fields": ["name^2", "description"] } } }
```

#### 진행 순서

1. 공통 쇼핑몰 예제를 먼저 실행하거나 화면에서 확인합니다.
2. 예상 결과를 확인한 뒤, 내 PBL에서 같은 역할을 할 field·값·질문을 정합니다.
3. 내 저장소의 README, `elasticsearch/`, `data/`, `kibana/`, `evidence/` 중 알맞은 파일에 결과를 남깁니다.

#### 예상 결과·확인 기준

- 요청 또는 화면에서 핵심 field·문서·차트가 질문에 맞는지 한 문장으로 설명합니다.
- 결과 수만 보지 말고, 왜 그 결과가 나왔는지 field와 조건을 근거로 설명합니다.

### 오류 해결 팁

결과가 다르면 화면을 닫지 말고 method, path, field 이름, 값의 type, 응답의 error/message를 순서대로 확인합니다.

### 내 PBL 반영

- 내 주제에서 이 토픽과 같은 역할을 하는 문서·field·질문:
- 공통 예제를 내 데이터로 바꿀 때 변경할 값 또는 명령:
- 예상 결과와 실패했을 때 점검할 항목:
- 저장할 파일 경로:

### 복습 체크

- [ ] 학생이 match_phrase는 단어 순서와 가까운 구문을, multi_match는 여러 text field를 동시에 찾는 데 사용합니다.
- [ ] 쇼핑몰 예제를 내 도메인에 맞게 한 항목 이상 바꾸었다.
- [ ] 결과 또는 설계 근거를 저장소에 남겼다.
- [ ] 다음 토픽에서 사용할 질문 또는 field를 정리했다.

### 공식 문서

- [Elastic 공식 문서](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-multi-match-query)

---

## T19-1 필터링·복합 검색

- 학생교재 위치: §19.1 filter

### 학습 목표

- 학생이 filter는 점수보다 조건 충족 여부를 빠르게 좁히는 역할을 합니다.
- 쇼핑몰 예제를 내 도메인의 문서·field·검색 질문으로 바꾼다.

### 핵심 개념

term·range·boolean 조건을 filter로 조합하고 사용자 검색어가 필요한 부분만 query로 둡니다.

**주의:** 가격 범위의 단위와 경계를 명확히 기록하게 합니다.

### PPT와 연결되는 학습 포인트

1. **filter는 결과에 들어올 자격을 정합니다.** — filter는 결과에 들어올 자격을 정합니다.
2. **term filter** — term filter
3. **range filter** — range filter
4. **bool 뼈대** — bool 뼈대
5. **질문 분해 활동** — 질문 분해 활동
6. **내 filter 설계** — 내 filter 설계
7. **경계 테스트** — 경계 테스트
8. **bool 구현 연결** — bool 구현 연결

### 쇼핑몰 데이터 예제

공통 index는 `products`입니다. 상품 문서의 `name`, `description`, `category`, `price`, `rating`, `in_stock`는 역할을 보여 주는 예시입니다. 내 PBL에서는 같은 이름을 복사하지 말고, 예를 들어 도서 검색의 `title`·`genre`·`available`처럼 같은 역할의 field로 대응합니다.

### 개념 실습

```http
GET /products/_search
{ "query": { "bool": { "filter": [{ "term": { "in_stock": true } }, { "range": { "price": { "gte": 50000, "lte": 200000 } } }] } } }
```

#### 진행 순서

1. 공통 쇼핑몰 예제를 먼저 실행하거나 화면에서 확인합니다.
2. 예상 결과를 확인한 뒤, 내 PBL에서 같은 역할을 할 field·값·질문을 정합니다.
3. 내 저장소의 README, `elasticsearch/`, `data/`, `kibana/`, `evidence/` 중 알맞은 파일에 결과를 남깁니다.

#### 예상 결과·확인 기준

- 요청 또는 화면에서 핵심 field·문서·차트가 질문에 맞는지 한 문장으로 설명합니다.
- 결과 수만 보지 말고, 왜 그 결과가 나왔는지 field와 조건을 근거로 설명합니다.

### 오류 해결 팁

결과가 다르면 화면을 닫지 말고 method, path, field 이름, 값의 type, 응답의 error/message를 순서대로 확인합니다.

### 내 PBL 반영

- 내 주제에서 이 토픽과 같은 역할을 하는 문서·field·질문:
- 공통 예제를 내 데이터로 바꿀 때 변경할 값 또는 명령:
- 예상 결과와 실패했을 때 점검할 항목:
- 저장할 파일 경로:

### 복습 체크

- [ ] 학생이 filter는 점수보다 조건 충족 여부를 빠르게 좁히는 역할을 합니다.
- [ ] 쇼핑몰 예제를 내 도메인에 맞게 한 항목 이상 바꾸었다.
- [ ] 결과 또는 설계 근거를 저장소에 남겼다.
- [ ] 다음 토픽에서 사용할 질문 또는 field를 정리했다.

### 공식 문서

- [Elastic 공식 문서](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-filter-context)

---

## T19-2 bool 실습

- 학생교재 위치: §19.2 bool

### 학습 목표

- 학생이 bool은 must, filter, must_not, should를 하나의 검색 요청으로 합칩니다.
- 쇼핑몰 예제를 내 도메인의 문서·field·검색 질문으로 바꾼다.

### 핵심 개념

must는 관련도 계산에 참여하고 filter는 조건 통과 여부를 결정한다는 차이를 반복합니다.

**주의:** 조건이 많아져도 각 배열에 넣은 이유를 한 문장으로 설명할 수 있어야 합니다.

### PPT와 연결되는 학습 포인트

1. **bool은 여러 조건을 한 검색 요청으로 조합합니다.** — bool은 여러 조건을 한 검색 요청으로 조합합니다.
2. **must와 filter** — must와 filter
3. **must_not과 should** — must_not과 should
4. **공통 bool 실행** — 공통 bool 실행
5. **filter 하나씩 제거** — filter 하나씩 제거
6. **내 bool 구현** — 내 bool 구현
7. **통과 판정** — 통과 판정
8. **T20 연결** — T20 연결

### 쇼핑몰 데이터 예제

공통 index는 `products`입니다. 상품 문서의 `name`, `description`, `category`, `price`, `rating`, `in_stock`는 역할을 보여 주는 예시입니다. 내 PBL에서는 같은 이름을 복사하지 말고, 예를 들어 도서 검색의 `title`·`genre`·`available`처럼 같은 역할의 field로 대응합니다.

### 개념 실습

```http
GET /products/_search
{ "query": { "bool": { "must": [{ "match": { "name": "무선" } }], "filter": [{ "term": { "in_stock": true } }] } } }
```

#### 진행 순서

1. 공통 쇼핑몰 예제를 먼저 실행하거나 화면에서 확인합니다.
2. 예상 결과를 확인한 뒤, 내 PBL에서 같은 역할을 할 field·값·질문을 정합니다.
3. 내 저장소의 README, `elasticsearch/`, `data/`, `kibana/`, `evidence/` 중 알맞은 파일에 결과를 남깁니다.

#### 예상 결과·확인 기준

- 요청 또는 화면에서 핵심 field·문서·차트가 질문에 맞는지 한 문장으로 설명합니다.
- 결과 수만 보지 말고, 왜 그 결과가 나왔는지 field와 조건을 근거로 설명합니다.

### 오류 해결 팁

결과가 다르면 화면을 닫지 말고 method, path, field 이름, 값의 type, 응답의 error/message를 순서대로 확인합니다.

### 내 PBL 반영

- 내 주제에서 이 토픽과 같은 역할을 하는 문서·field·질문:
- 공통 예제를 내 데이터로 바꿀 때 변경할 값 또는 명령:
- 예상 결과와 실패했을 때 점검할 항목:
- 저장할 파일 경로:

### 복습 체크

- [ ] 학생이 bool은 must, filter, must_not, should를 하나의 검색 요청으로 합칩니다.
- [ ] 쇼핑몰 예제를 내 도메인에 맞게 한 항목 이상 바꾸었다.
- [ ] 결과 또는 설계 근거를 저장소에 남겼다.
- [ ] 다음 토픽에서 사용할 질문 또는 field를 정리했다.

### 공식 문서

- [Elastic 공식 문서](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-bool-query)

---

## T20 결과 표현·관련도

- 학생교재 위치: §20 결과 표현

### 학습 목표

- 학생이 sort·highlight·_source 축소는 결과를 사용자가 읽기 쉽게 표현하는 기능입니다.
- 쇼핑몰 예제를 내 도메인의 문서·field·검색 질문으로 바꾼다.

### 핵심 개념

정렬 기준은 가격·평점·최신성처럼 사용자 질문에서 시작하며, highlight는 검색어 근거를 보여 줍니다.

**주의:** 0건을 숨기거나 임의 문서를 추가해 품질 기준을 맞추지 않습니다.

### PPT와 연결되는 학습 포인트

1. **통과 문서가 같아도 정렬과 표시가 검색 경험을 바꿉니다.** — 통과 문서가 같아도 정렬과 표시가 검색 경험을 바꿉니다.
2. **sort** — sort
3. **highlight** — highlight
4. **_source 축소** — _source 축소
5. **공통 결과 실행** — 공통 결과 실행
6. **내 표현 설계** — 내 표현 설계
7. **관련성 읽기** — 관련성 읽기
8. **T21 연결** — T21 연결

### 쇼핑몰 데이터 예제

공통 index는 `products`입니다. 상품 문서의 `name`, `description`, `category`, `price`, `rating`, `in_stock`는 역할을 보여 주는 예시입니다. 내 PBL에서는 같은 이름을 복사하지 말고, 예를 들어 도서 검색의 `title`·`genre`·`available`처럼 같은 역할의 field로 대응합니다.

### 개념 실습

```http
GET /products/_search
{ "sort": [{ "rating": "desc" }], "highlight": { "fields": { "name": {} } } }
```

#### 진행 순서

1. 공통 쇼핑몰 예제를 먼저 실행하거나 화면에서 확인합니다.
2. 예상 결과를 확인한 뒤, 내 PBL에서 같은 역할을 할 field·값·질문을 정합니다.
3. 내 저장소의 README, `elasticsearch/`, `data/`, `kibana/`, `evidence/` 중 알맞은 파일에 결과를 남깁니다.

#### 예상 결과·확인 기준

- 요청 또는 화면에서 핵심 field·문서·차트가 질문에 맞는지 한 문장으로 설명합니다.
- 결과 수만 보지 말고, 왜 그 결과가 나왔는지 field와 조건을 근거로 설명합니다.

### 오류 해결 팁

결과가 다르면 화면을 닫지 말고 method, path, field 이름, 값의 type, 응답의 error/message를 순서대로 확인합니다.

### 내 PBL 반영

- 내 주제에서 이 토픽과 같은 역할을 하는 문서·field·질문:
- 공통 예제를 내 데이터로 바꿀 때 변경할 값 또는 명령:
- 예상 결과와 실패했을 때 점검할 항목:
- 저장할 파일 경로:

### 복습 체크

- [ ] 학생이 sort·highlight·_source 축소는 결과를 사용자가 읽기 쉽게 표현하는 기능입니다.
- [ ] 쇼핑몰 예제를 내 도메인에 맞게 한 항목 이상 바꾸었다.
- [ ] 결과 또는 설계 근거를 저장소에 남겼다.
- [ ] 다음 토픽에서 사용할 질문 또는 field를 정리했다.

### 공식 문서

- [Elastic 공식 문서](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/highlighting)

---

## T21-1 검색 품질 점검

- 학생교재 위치: §21.1 품질 점검

### 학습 목표

- 학생이 품질 점검은 결과 수가 아니라 질문별 기대·제외·0건 기준을 통과했는지 보는 절차입니다.
- 쇼핑몰 예제를 내 도메인의 문서·field·검색 질문으로 바꾼다.

### 핵심 개념

각 테스트에는 요청, 관찰한 결과, 판정, 원인을 같은 기록 표에 남깁니다.

**주의:** 실패하면 data를 억지로 바꾸기 전에 query·filter·sort·mapping 중 원인을 분류합니다.

### PPT와 연결되는 학습 포인트

1. **테스트는 검색 결과 수가 아니라 질문의 통과 조건을 확인합니다.** — 테스트는 검색 결과 수가 아니라 질문의 통과 조건을 확인합니다.
2. **세 가지 필수 질문** — 세 가지 필수 질문
3. **기대·제외·0건** — 기대·제외·0건
4. **0건 공통 요청** — 0건 공통 요청
5. **품질표 작성** — 품질표 작성
6. **원인 분류** — 원인 분류
7. **개인 새 Console 재실행** — 개인 새 Console 재실행
8. **통합 연결** — 통합 연결

### 쇼핑몰 데이터 예제

공통 index는 `products`입니다. 상품 문서의 `name`, `description`, `category`, `price`, `rating`, `in_stock`는 역할을 보여 주는 예시입니다. 내 PBL에서는 같은 이름을 복사하지 말고, 예를 들어 도서 검색의 `title`·`genre`·`available`처럼 같은 역할의 field로 대응합니다.

### 개념 실습



#### 진행 순서

1. 공통 쇼핑몰 예제를 먼저 실행하거나 화면에서 확인합니다.
2. 예상 결과를 확인한 뒤, 내 PBL에서 같은 역할을 할 field·값·질문을 정합니다.
3. 내 저장소의 README, `elasticsearch/`, `data/`, `kibana/`, `evidence/` 중 알맞은 파일에 결과를 남깁니다.

#### 예상 결과·확인 기준

- 요청 또는 화면에서 핵심 field·문서·차트가 질문에 맞는지 한 문장으로 설명합니다.
- 결과 수만 보지 말고, 왜 그 결과가 나왔는지 field와 조건을 근거로 설명합니다.

### 오류 해결 팁

결과가 다르면 화면을 닫지 말고 method, path, field 이름, 값의 type, 응답의 error/message를 순서대로 확인합니다.

### 내 PBL 반영

- 내 주제에서 이 토픽과 같은 역할을 하는 문서·field·질문:
- 공통 예제를 내 데이터로 바꿀 때 변경할 값 또는 명령:
- 예상 결과와 실패했을 때 점검할 항목:
- 저장할 파일 경로:

### 복습 체크

- [ ] 학생이 품질 점검은 결과 수가 아니라 질문별 기대·제외·0건 기준을 통과했는지 보는 절차입니다.
- [ ] 쇼핑몰 예제를 내 도메인에 맞게 한 항목 이상 바꾸었다.
- [ ] 결과 또는 설계 근거를 저장소에 남겼다.
- [ ] 다음 토픽에서 사용할 질문 또는 field를 정리했다.

### 공식 문서

- [Elastic 공식 문서](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search-search)

---

## T21-2 PBL 검색 통합

- 학생교재 위치: §21.2 검색 통합

### 학습 목표

- 학생이 통합 검색 요청은 이미 만든 기능을 한 질문에 필요한 만큼만 결합하는 최종 실습입니다.
- 쇼핑몰 예제를 내 도메인의 문서·field·검색 질문으로 바꾼다.

### 핵심 개념

개선 전후를 같은 기준표로 비교하고 개선 이유를 README 또는 evidence에 기록합니다.

**주의:** 기능을 더 넣는 것이 아니라 사용자의 질문에 맞는 결과로 좁히는 것이 목표입니다.

### PPT와 연결되는 학습 포인트

1. **개선은 결과를 억지로 맞추는 일이 아니라 원인을 기록하고 설계를 바꾸는 일입니다.** — 개선은 결과를 억지로 맞추는 일이 아니라 원인을 기록하고 설계를 바꾸는 일입니다.
2. **개선 전** — 개선 전 · 후 형식
3. **개선 예** — 개선 예
4. **개인 통합** — 개인 통합
5. **commit 준비** — commit 준비
6. **개인 재현 점검** — 개인 재현 점검
7. **Day 3 완료 체크** — Day 3 완료 체크
8. **Day 4 연결** — Day 4 연결

#### PPT 원문 확인

- S02: `개선 전/후 형식`

### 쇼핑몰 데이터 예제

공통 index는 `products`입니다. 상품 문서의 `name`, `description`, `category`, `price`, `rating`, `in_stock`는 역할을 보여 주는 예시입니다. 내 PBL에서는 같은 이름을 복사하지 말고, 예를 들어 도서 검색의 `title`·`genre`·`available`처럼 같은 역할의 field로 대응합니다.

### 개념 실습



#### 진행 순서

1. 공통 쇼핑몰 예제를 먼저 실행하거나 화면에서 확인합니다.
2. 예상 결과를 확인한 뒤, 내 PBL에서 같은 역할을 할 field·값·질문을 정합니다.
3. 내 저장소의 README, `elasticsearch/`, `data/`, `kibana/`, `evidence/` 중 알맞은 파일에 결과를 남깁니다.

#### 예상 결과·확인 기준

- 요청 또는 화면에서 핵심 field·문서·차트가 질문에 맞는지 한 문장으로 설명합니다.
- 결과 수만 보지 말고, 왜 그 결과가 나왔는지 field와 조건을 근거로 설명합니다.

### 오류 해결 팁

결과가 다르면 화면을 닫지 말고 method, path, field 이름, 값의 type, 응답의 error/message를 순서대로 확인합니다.

### 내 PBL 반영

- 내 주제에서 이 토픽과 같은 역할을 하는 문서·field·질문:
- 공통 예제를 내 데이터로 바꿀 때 변경할 값 또는 명령:
- 예상 결과와 실패했을 때 점검할 항목:
- 저장할 파일 경로:

### 복습 체크

- [ ] 학생이 통합 검색 요청은 이미 만든 기능을 한 질문에 필요한 만큼만 결합하는 최종 실습입니다.
- [ ] 쇼핑몰 예제를 내 도메인에 맞게 한 항목 이상 바꾸었다.
- [ ] 결과 또는 설계 근거를 저장소에 남겼다.
- [ ] 다음 토픽에서 사용할 질문 또는 field를 정리했다.

### 공식 문서

- [Elastic 공식 문서](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/paginate-search-results)



## 교시별 실습 운영표

모든 교시는 강사 시연을 본 뒤 끝나는 방식이 아닙니다. [`practice/`](practice/README.md)의 해당 교시 문제지를 개인 저장소 `evidence/day-03-practice/`에 복사하고, 제공 코드 실행 1문제·공통 API 직접 구현 2문제·개인 PBL 구현 2문제에 답합니다.

| 교시 | 문제지 | 공통 문제 1~3 | 개인 문제 4~5 | 합계 |
|---:|---|---|---|---:|
| 1 | [Search API 기본](practice/period-01-search-api.md) | 응답 읽기·반환 field·정렬 전체 조회 | 자기 첫 요청·결과 카드 | 5 |
| 2 | [term과 match](practice/period-02-term-match.md) | 정확 조건·전문 검색·부적절한 조합 비교 | 자기 정확·전문 검색 | 5 |
| 3 | [전문 검색 확장](practice/period-03-full-text.md) | multi_match·boost·phrase | 자기 다중 field·가설 검증 | 5 |
| 4 | [정확 조건과 경계](practice/period-04-filter-range.md) | 세 filter·포함 경계·제외 경계 | 자기 정확 조건·범위 실험 | 5 |
| 5 | [bool 검색](practice/period-05-bool.md) | must/filter·조건 제거·should | 자기 bool·조건 역할 검증 | 5 |
| 6 | [정렬·highlight](practice/period-06-sort-highlight.md) | 1·2차 정렬·우선순위 교환·highlight | 자기 카드·표시 최적화 | 5 |
| 7 | [검색 품질](practice/period-07-quality.md) | 상위 결과·정확 조건·의도한 0건 | 자기 질문 3개·실패 진단 | 5 |
| 8 | [통합·개선](practice/period-08-integration.md) | 통합 검증·boost 전후·요구사항 구현 | 자기 개선·최종 재현 | 5 |
| **합계** |  | **24** | **16** | **40** |

### 개인 요청 작성 규칙

1. `practice/`에서 해당 교시 문제지를 열고 문제 1~5에 순서대로 답합니다.
2. 코드 미제공 문제는 실행 가능한 Search API 전체를 답안 코드 블록에 작성합니다.
3. 개인 문제의 완성 요청은 Day 1·2부터 사용한 개인 저장소 루트 `requests.http`에 사용자 질문과 `V1-T17-P`~`V1-T21-P` 요청 ID를 주석으로 정리합니다.
4. 자기 index·field·실제 값을 사용합니다.
5. 실행 전에 기대 문서·제외 문서·경계 또는 0건 기준을 적습니다.
6. 실행 후 `docs/quality-test.md`에 질문별 기대·실제·판정을 완성하고, `evidence/day-03-search.md`에 핵심 결과와 개선 전후를 요약합니다.
7. 예상과 다르면 data를 바꾸기 전에 mapping→저장값→analyzer→query→filter→sort 순으로 한 단계씩 확인합니다.
