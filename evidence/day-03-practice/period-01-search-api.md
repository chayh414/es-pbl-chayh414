# 1교시 실습 — Search API 기본

## (공통) 문제 1 — 제공 코드 실행·응답 읽기

다음 요청을 실행하세요.

```http
GET /products/_search
{
  "size": 5,
  "query": { "match_all": {} }
}
```

### 결과 입력

- HTTP 성공 여부: 성공 (에러 없음, took=153ms, `_shards.failed`=0)
- `hits.total.value`: 10000
- `hits.hits`에 반환된 문서 수: 5
- 첫 번째 문서의 `_id`: P-00003
- 첫 번째 문서의 `_source` field 3개: product_id, name, category
- `hits.total.value`와 반환 문서 수가 다를 수 있는 이유: `size`는 이번 응답에 몇 건을 담아 돌려줄지만 정하는 값이고, `hits.total.value`는 쿼리 조건(`match_all`이라 전체)에 맞는 문서의 총 개수다. 그래서 조건에 맞는 문서는 10,000건이지만 실제로 받은 건 5건뿐이다.

## (공통) 문제 2 — 반환 개수와 field 직접 구현

`products` index의 전체 문서 중 최대 3건만 반환하고, `_source`에는 `product_id`, `name`, `price`, `in_stock`만 포함하는 Search API를 작성하고 실행하세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 3,
  "_source": ["product_id", "name", "price", "in_stock"],
  "query": { "match_all": {} }
}
```

### 결과 입력

- 반환 문서 수: 3건
- `_source`에 요구하지 않은 field가 포함됐는가: 아니오 (product_id, name, price, in_stock 4개만 포함됨)
- 검증한 문서 ID: P-00003, P-00004, P-00008

## (공통) 문제 3 — 정렬이 포함된 전체 조회 구현

`products` index의 전체 문서 중 최대 10건을 `price`가 낮은 순서로 반환하세요. `_source`에는 `product_id`, `name`, `price`만 포함하세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 10,
  "_source": ["product_id", "name", "price"],
  "query": { "match_all": {} },
  "sort": [{ "price": "asc" }]
}
```

### 결과 입력

- 첫 3개 문서의 ID와 price: P-00431(5900), P-06599(5900), P-06479(5900)
- 오름차순 여부: 맞음 (5900→5900→5900→5900→6100→6100→6100→6100→6200→6200 순으로 증가만 하고 감소는 없음)
- 두 문서의 price가 같을 때 순서가 고정된다고 말할 수 있는가? 근거: 아니오. 실제로 price=5900인 문서가 4개(P-00431, P-06599, P-06479, P-08895) 동률로 나왔는데, `sort`에 price 하나만 지정했기 때문에 이 4개 사이의 순서는 ES가 보장하지 않는다. 여러 shard(총 3개)에서 결과를 모으는 방식상 같은 값끼리는 요청마다 순서가 달라질 수 있다. 순서를 고정하려면 `_id`처럼 값이 겹치지 않는 field를 2차 정렬 기준으로 추가해야 한다.

## (개인) 문제 4 — 자기 index의 첫 Search API

자기 index의 전체 문서 중 최대 5건을 반환하는 Search API를 작성하세요.

### 역할·검증 기준

- 실제 자기 index 이름을 사용합니다.
- `_count`와 `hits.total.value`를 비교합니다.
- `size`와 전체 일치 문서 수를 구분해 설명합니다.

### API와 결과 입력

```http
GET /vintage-items/_count

GET /vintage-items/_search
{
  "size": 5,
  "query": { "match_all": {} }
}
```

- 자기 index: vintage-items
- `_count`: 5000
- `hits.total.value`: 5000
- 반환 문서 수: 5
- 판정과 근거: `_count`(5000)와 `hits.total.value`(5000)가 정확히 일치함. `match_all`이라 전체 문서가 조건에 맞고, `_count`는 그 조건에 맞는 총 개수를 세는 것이므로 두 값이 같아야 정상이다. 반면 실제 응답에 담겨 온 문서(`hits.hits`)는 5개뿐인데, 이는 `size:5`로 "미리보기 몇 개만 보여줘"라고 제한했기 때문이며 전체 개수(5000)와는 별개 개념이다.

## (개인) 문제 5 — 결과 카드 field 설계

자기 서비스에서 검색 결과 카드 한 개를 보여 준다고 가정하세요. 사용자가 클릭 여부를 결정하는 데 필요한 field 3~5개만 반환하는 Search API를 작성하세요.

### 역할·검증 기준

- 선택한 field가 자기 mapping과 실제 문서에 존재해야 합니다.
- 식별자, 제목 역할, 판단용 정보가 포함되어야 합니다.
- 불필요한 field를 하나 이상 제외하고 이유를 설명합니다.

### API와 결과 입력

```http
GET /vintage-items/_search
{
  "size": 5,
  "_source": ["item_id", "item_name", "price", "condition", "brand"],
  "query": { "match_all": {} }
}
```

- 포함한 field와 이유: item_id(식별자, 상세 페이지 이동에 필요), item_name(제목 역할, 뭘 파는 상품인지 바로 인지), price(구매 가능한 가격대인지 판단), condition(상태등급, 중고 옷에서 가장 중요한 판단 기준), brand(브랜드 선호도로 클릭 여부 판단)
- 제외한 field와 이유: description·defects(텍스트가 길어 카드 미리보기에 부적합, 클릭 후 상세 페이지에서 확인하면 됨), listed_date·platform(클릭 여부 판단에 핵심 정보가 아님)
- 실제 반환 문서 ID: VI-00001, VI-00002, VI-00003, VI-00004, VI-00005 (5건 모두 item_id, item_name, brand, condition, price 5개 field만 정확히 포함됨)
- 완료 판정: 통과
