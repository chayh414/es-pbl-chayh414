# 4교시 실습 — 정확 조건과 경계

## (공통) 문제 1 — 제공 코드로 세 filter 확인

```http
GET /products/_search
{
  "size": 10,
  "query": {
    "bool": {
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

- `hits.total.value`: 380
- 확인한 문서 ID 3개: P-00025, P-00129, P-00185
- 각 문서의 category / in_stock / price: P-00025(전자기기/true/59400), P-00129(전자기기/true/53800), P-00185(전자기기/true/161600)
- 조건을 위반한 문서가 있는가: 없음. 3건 모두 category="전자기기", in_stock=true, price가 50,000~200,000 범위 안에 있음을 확인함. 참고로 `max_score`가 0인데, `bool.filter`는 조건 통과 여부만 따지고 관련도 점수 계산에는 관여하지 않기 때문이다.

## (공통) 문제 2 — 경계 포함 범위 직접 구현

`products`에서 category가 `전자기기`이고 가격이 50,000원 이상 200,000원 이하인 상품을 검색하세요. 최대 10건을 반환하고 `product_id`, `name`, `category`, `price`만 표시하세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 10,
  "_source": ["product_id", "name", "category", "price"],
  "query": {
    "bool": {
      "filter": [
        { "term": { "category": "전자기기" } },
        { "range": { "price": { "gte": 50000, "lte": 200000 } } }
      ]
    }
  }
}
```

### 결과 입력

- `hits.total.value`: 440
- 최소·최대 price: (반환된 10건 중) 최소 53,800(P-00129) / 최대 199,300(P-00457) — 정렬을 지정하지 않아 반환 순서가 가격순이 아니므로 이 값이 전체 440건의 진짜 최소·최대는 아님
- 50,000 또는 200,000 경계 문서 존재 여부와 ID: 반환된 10건 중에는 정확히 50,000 또는 200,000인 문서 없음. 전체 440건 중 존재 여부는 이 응답만으로 단정할 수 없어 문제 3의 total 비교로 확인 예정.

## (공통) 문제 3 — 경계 제외 범위 직접 구현

문제 2에서 다른 조건은 모두 그대로 유지하고 가격 조건만 50,000원 초과 200,000원 미만으로 바꾸세요. 한 요소만 변경해야 합니다.

### API 전체 입력

```http
GET /products/_search
{
  "size": 10,
  "_source": ["product_id", "name", "category", "price"],
  "query": {
    "bool": {
      "filter": [
        { "term": { "category": "전자기기" } },
        { "range": { "price": { "gt": 50000, "lt": 200000 } } }
      ]
    }
  }
}
```

### 비교 결과

- 문제 2 total / 문제 3 total: 440 / 440 (동일)
- 빠진 경계 문서 ID: 없음
- 경계 문서가 없어 결과가 같다면 확인한 근거: `gte/lte`(문제2)와 `gt/lt`(문제3) 둘 다 total이 440으로 정확히 같고, 반환된 10건의 ID·price도 완전히 동일하다. 즉 이 `전자기기` 카테고리 상품 중 가격이 정확히 50,000원이거나 200,000원인 문서가 하나도 없어서, 경계를 포함하든 제외하든 결과에 차이가 없다.

## (개인) 문제 4 — 자기 정확 조건 2개

자기 데이터에서 정확 조건으로 사용할 field 2개를 선택해 두 조건을 모두 만족하는 검색을 구현하세요.

### 역할·검증 기준

- keyword·boolean 등 실제 mapping type에 적합해야 합니다.
- 실행 전 포함 예상 문서 1개와 제외 예상 문서 1개를 정합니다.
- 실행 후 `_source`로 판정합니다.

### API와 결과 입력

```http
GET /vintage-items/_search
{
  "size": 5,
  "query": {
    "bool": {
      "filter": [
        { "term": { "condition": "A급" } },
        { "term": { "sold": false } }
      ]
    }
  }
}
```

- field·type·값 2개: condition(keyword)="A급", sold(boolean)=false
- 기대 ID / 제외 ID: 포함 예상 VI-00001(A급, 미판매) / 제외 예상 VI-00002(condition=B급이라 불만족)
- 실제 결과와 판정: 통과. `hits.total.value`=1175, 상위 5건(VI-00001, VI-00003, VI-00010, VI-00015, VI-00018) 전부 `_source.condition`="A급"이고 `sold`=false임을 확인했다. 예상대로 VI-00001은 결과에 포함됐고, VI-00002는 결과 목록에 나타나지 않아 예상이 맞았다.

## (개인) 문제 5 — 자기 범위와 경계 실험

자기 데이터의 numeric 또는 date field를 선택해 포함 경계와 제외 경계 요청을 각각 구현하세요.

### 역할·검증 기준

- 실제 데이터의 최소·최대 또는 의미 있는 경계값을 먼저 확인합니다.
- `gte/lte`와 `gt/lt` 외 조건은 동일하게 유지합니다.
- 경계 문서가 없으면 fixture 설계 또는 부재 근거를 기록합니다.

### API와 결과 입력

```http
GET /vintage-items/_search
{
  "size": 0,
  "query": { "range": { "price": { "lte": 30000 } } }
}

GET /vintage-items/_search
{
  "size": 0,
  "query": { "range": { "price": { "lt": 30000 } } }
}
```

- field / type / 경계값: price(integer) / 30,000원 — Q1("3만원 이하") 기준값
- 포함 요청 total / 제외 요청 total: 828 / 827
- 달라진 문서 ID: VI-00003 (price=30000, `lte`에는 포함되고 `lt`에서는 빠짐)
- 경계 판정: 통과. 포함/제외 total 차이가 정확히 1이고, 그 1건이 실제로 대표 문서 VI-00003(price=30000)와 일치한다. 즉 "3만원 이하"와 "3만원 미만"의 차이를 실제 데이터로 정확히 확인했다.
