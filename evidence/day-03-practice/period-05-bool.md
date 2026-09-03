# 5교시 실습 — bool 검색

## (공통) 문제 1 — 제공 코드로 must·filter 확인

```http
GET /products/_search
{
  "size": 10,
  "query": {
    "bool": {
      "must": [{ "match": { "name": "무선" } }],
      "filter": [
        { "term": { "category": "전자기기" } },
        { "term": { "in_stock": true } },
        { "range": { "price": { "gte": 50000, "lte": 200000 } } }
      ]
    }
  }
}
```

### 결과 입력

- `hits.total.value`: 74
- 상위 3개 ID·name: P-00025(MobiCore 컴팩트 무선 이어폰), P-00129(Auralis 스마트 무선 이어폰), P-00369(SoundLab 데일리 무선 이어폰)
- 세 filter의 실제 값: 3건 모두 category="전자기기", in_stock=true, price가 53,800~162,800원으로 50,000~200,000 범위 안에 있음을 확인
- must와 filter의 역할 차이: `must`(match)는 "무선"이라는 단어가 있는지 분석 기반으로 찾으면서 점수(관련도)에도 반영된다 (상위 10건 score가 전부 6.3034635로 동일한 이유는 세 filter는 점수에 안 들어가고, must의 "무선" 매칭 정도가 동일해서). `filter`는 조건 통과 여부만 boolean으로 따지고 점수 계산에는 전혀 관여하지 않는다.

## (공통) 문제 2 — 조건 제거 실험 직접 구현

문제 1의 요청에서 `in_stock` filter만 제거한 API를 작성하세요. 다른 조건은 바꾸지 마세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 10,
  "query": {
    "bool": {
      "must": [{ "match": { "name": "무선" } }],
      "filter": [
        { "term": { "category": "전자기기" } },
        { "range": { "price": { "gte": 50000, "lte": 200000 } } }
      ]
    }
  }
}
```

### 비교 결과

- 변경 전 total / 변경 후 total: 74 / 83
- 새로 포함된 문서 ID·in_stock: P-00457(in_stock=false), P-00521(in_stock=false) — 재고 없는 무선 상품들이 새로 들어옴
- 변화가 없다면 데이터 근거: 해당 없음 (실제로 9건 늘었음)
- 제거한 조건의 역할: `in_stock=true` filter는 "재고 있는 상품만" 강제로 걸러내는 역할이었다. 이걸 빼니 재고 없는(in_stock=false) 상품도 결과에 섞여 들어와, 실사용 시 "품절 상품을 검색 결과에 보여줄지" 결정하는 핵심 조건임을 확인했다.

## (공통) 문제 3 — should 조건 직접 구현

category가 `전자기기`인 문서 중 `name`에 `무선`이 있거나 `in_stock=true`인 조건을 최소 하나 만족하도록 bool API를 작성하세요. `minimum_should_match`를 명시하세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 10,
  "query": {
    "bool": {
      "filter": [{ "term": { "category": "전자기기" } }],
      "should": [
        { "match": { "name": "무선" } },
        { "term": { "in_stock": true } }
      ],
      "minimum_should_match": 1
    }
  }
}
```

### 결과 입력

- `hits.total.value`: 1097 (전체 전자기기 1250건 중 1097건이 최소 하나의 should 조건을 만족, 나머지 153건은 둘 다 불만족)
- 무선이지만 품절인 문서 존재 여부: 이 응답(상위 10건)만으로는 확인 불가 — 상위 10건 전부 name에 "무선"이 있고 동시에 in_stock=true라 두 조건을 모두 만족하는 문서만 최고 점수로 올라왔음. should 조건 중 하나만 만족하는 문서는 더 낮은 점수로 뒤쪽에 있을 것으로 추정되며, 존재 여부를 확정하려면 `{"bool":{"filter":[{"term":{"category":"전자기기"}},{"match":{"name":"무선"}},{"term":{"in_stock":false}}]}}` 같은 별도 요청으로 확인이 필요함
- 무선이 아니지만 재고가 있는 문서 존재 여부: 위와 동일한 이유로 상위 10건만으로는 확인 불가, 별도 요청 필요
- should 조건 판정: `minimum_should_match: 1`로 지정했기 때문에 두 조건 중 하나만 맞아도 결과에 포함된다는 것은 total(1097 < 1250)로 확인됐다. 다만 상위 결과는 항상 두 조건을 모두 만족하는 문서가 점수가 가장 높아 먼저 나오므로, "하나만 만족하는" 개별 사례를 보려면 정렬이나 별도 필터가 필요하다는 것을 배움.

## (개인) 문제 4 — 자기 bool 검색

자기 사용자 질문 하나를 검색 의도와 정확 조건으로 분해해 bool 요청을 구현하세요.

### 역할·검증 기준

- must 0~1개, filter 2개 이상을 사용합니다.
- 각 field와 query 선택 이유를 mapping type으로 설명합니다.
- 반환 문서 3개 이상을 실제 값으로 검증합니다.

### API와 결과 입력

```http
GET /vintage-items/_search
{
  "size": 5,
  "query": {
    "bool": {
      "must": [{ "match": { "item_name": "데님 자켓" } }],
      "filter": [
        { "range": { "price": { "lte": 30000 } } },
        { "terms": { "condition": ["S급", "A급"] } },
        { "term": { "category": "아우터" } },
        { "term": { "material": "데님" } }
      ]
    }
  }
}
```

- 사용자 질문: "3만원 이하, A급 이상 상태의 데님 자켓을 찾고 싶다" (data-model.md Q1)
- must와 이유: `match`로 `item_name`에서 "데님 자켓" 검색 — 상품명에 검색어가 얼마나 가깝게 있는지로 관련도 순위를 매기기 위해 (전문 검색이라 term이 아니라 match)
- filter 2개와 이유: `price` range(≤30000, integer라 범위 조건), `condition` terms(S급/A급, keyword라 정확 목록 매칭) — 그 외 `category`="아우터", `material`="데님"도 keyword 정확 조건으로 추가함(총 filter 4개)
- 실제 검증 결과: 통과. total 14건, VI-00001이 최고 점수(8.89)로 1위 — item_name에 "데님 자켓"이 그대로 포함돼 있음. 나머지(VI-00531 등)는 "데님 아우터"라 "데님"만 매칭돼 낮은 점수(1.94)로 밀림. 5건 모두 price≤30000, condition=A급, category=아우터, material=데님 조건을 실제로 만족함을 `_source`로 확인.

## (개인) 문제 5 — 조건 역할 검증

개인 문제 4에서 filter 하나를 제거하고 전후 결과를 비교하세요. 추가로 원래 조건에서 제외되어야 하는 문서 1개를 독립 요청으로 확인하세요.

### 역할·검증 기준

- 한 번에 filter 하나만 제거합니다.
- 새로 포함된 문서의 실제 값을 확인합니다.
- 제외 문서는 원래 bool 결과에 포함되지 않아야 합니다.

### API와 결과 입력

```http
GET /vintage-items/_search
{
  "size": 5,
  "query": {
    "bool": {
      "must": [{ "match": { "item_name": "데님 자켓" } }],
      "filter": [
        { "range": { "price": { "lte": 30000 } } },
        { "terms": { "condition": ["S급", "A급"] } },
        { "term": { "category": "아우터" } }
      ]
    }
  }
}

GET /vintage-items/_doc/VI-00002
```

- 제거한 filter: `material`="데님"
- 전/후 total: 14 / 15
- 새로 포함된 ID와 값: VI-00003 (material="나일론" — 데님이 아니었지만 material 조건을 뺐더니 통과됨. category=아우터, condition=A급, price=30000으로 나머지 조건은 만족)
- 제외 확인 ID와 근거: VI-00002는 이번 결과에도 없음. `GET /vintage-items/_doc/VI-00002` 실제 조회 결과 category="하의"(아우터 아님), condition="B급"(A급 아님)으로 원래 bool의 filter 조건 2개를 동시에 위반하므로, material 조건을 뺀 것과 무관하게 항상 제외되는 게 맞음을 확인함.
