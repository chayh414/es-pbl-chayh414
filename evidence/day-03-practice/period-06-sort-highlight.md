# 6교시 실습 — 정렬·highlight

## (공통) 문제 1 — 제공 코드로 1·2차 정렬 확인

```http
GET /products/_search
{
  "size": 10,
  "_source": ["product_id", "name", "price", "rating", "in_stock"],
  "query": { "match": { "name": "무선" } },
  "sort": [
    { "rating": "desc" },
    { "price": "asc" }
  ]
}
```

### 결과 입력

- 상위 5개 ID / rating / price: P-03842(5/13900), P-08761(5/107200), P-07634(5/132300), P-05962(5/138300), P-06457(5/184900)
- 1차 정렬이 올바른가: 맞음. rating이 5→5→5→5→5→5→5→4.9→4.9→4.9 순으로 내려가기만 하고 올라가지 않음
- rating 동률에서 2차 정렬이 적용된 사례: rating=5인 문서가 7개(P-03842, P-08761, P-07634, P-05962, P-06457, P-01041, P-01409) 있고, 그 안에서 price가 13900→107200→132300→138300→184900→322100→350900으로 정확히 오름차순 정렬됨. rating=4.9 그룹(3개)도 12900→13300→15900으로 오름차순.
- 동률이 없다면 2차 정렬을 확인할 수 있는 방법: 해당 없음 (실제로 동률 그룹이 존재해 직접 확인함)

## (공통) 문제 2 — 정렬 우선순위 교환

문제 1과 같은 검색 결과를 가격이 낮은 순서로 먼저 정렬하고, 가격이 같으면 평점이 높은 순서로 정렬하세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 10,
  "_source": ["product_id", "name", "price", "rating", "in_stock"],
  "query": { "match": { "name": "무선" } },
  "sort": [
    { "price": "asc" },
    { "rating": "desc" }
  ]
}
```

### 비교 결과

- 변경 후 상위 5개 ID / price / rating: P-01490(10900/2.9), P-05738(12900/4.9), P-05218(13300/4.9), P-08586(13700/2.3), P-03842(13900/5)
- 순서가 달라진 문서: 완전히 다른 순서. 문제 1(rating 우선)의 1위는 P-03842(rating5, price13900)였는데, 문제 2(price 우선)에서는 그보다 더 싼 P-01490(price10900)이 1위가 됨. 이번 상위 10건은 price가 전부 서로 달라(10900~19800) 동률이 없어서 2차 정렬(rating desc)이 실제로 적용되는 사례는 이 화면에서 확인 안 됨.
- 검색 hit 집합도 달라졌는가: 아니오. `hits.total.value`는 문제 1과 동일하게 505건. `query`(검색 조건)는 그대로고 `sort`만 바꿨기 때문에, 걸리는 문서 집합은 같고 나열 순서만 바뀌었다.

## (공통) 문제 3 — highlight와 표시 field 구현

`name`, `description`에서 `무선 이어폰`을 검색하되 `name`에 3배 boost를 적용하세요. 최대 5건을 반환하고 결과 카드용 field만 `_source`에 포함하며 `name`, `description`에 highlight를 적용하세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 5,
  "_source": ["product_id", "name", "price", "rating"],
  "query": {
    "multi_match": {
      "query": "무선 이어폰",
      "fields": ["name^3", "description"]
    }
  },
  "highlight": {
    "fields": {
      "name": {},
      "description": {}
    }
  }
}
```

### 결과 입력

- `_source` field 목록: product_id, name, price, rating
- highlight가 생성된 문서 ID와 field: 5건(P-00241, P-00305, P-00529, P-00617, P-00777) 전부 `name` field에만 highlight 생성됨 (예: `"SoundLab 프리미엄 <em>무선</em> <em>이어폰</em>"`)
- `_source`와 highlight의 차이: `_source`는 원본 데이터 그대로("SoundLab 프리미엄 무선 이어폰"), `highlight`는 검색어("무선", "이어폰")가 있는 부분만 `<em>` 태그로 감싸 별도 필드로 제공되는 강조 조각. 원본은 안 바뀌고 화면 표시용 힌트만 추가로 옴.
- highlight가 없는 hit가 있다면 이유 추정: 5건 전부 `highlight` 객체에 `name`만 있고 `description` key는 없음(즉 description은 highlight가 안 생김). description 문구가 "재택 학습에 잘 어울리는 전자기기 상품입니다..." 같은 정형화된 문장이라 "무선"/"이어폰" 단어 자체가 없기 때문으로 추정됨.

## (개인) 문제 4 — 자기 결과 정렬·카드 설계

자기 서비스에서 중요한 1차·2차 정렬 기준과 결과 카드 field 3~5개를 선택해 Search API를 구현하세요.

### 역할·검증 기준

- 정렬 가능한 mapping type을 사용합니다.
- 1차·2차 정렬의 업무적 이유를 설명합니다.
- 실제 상위 5개 값으로 순서를 검증합니다.

### API와 결과 입력

```http
GET /vintage-items/_search
{
  "size": 5,
  "_source": ["item_id", "item_name", "brand", "price", "seller_rating"],
  "query": { "match_all": {} },
  "sort": [
    { "seller_rating": "desc" },
    { "price": "asc" }
  ]
}
```

- 정렬 field·방향·이유: 1차 `seller_rating` desc — Q2("판매자 평점 높은 순으로 보고 싶다")를 그대로 구현. 2차 `price` asc — 평점이 같으면 저렴한 상품을 먼저 보여줘 구매 결정을 돕기 위함
- 카드 field와 이유: item_id(식별자), item_name(제목), brand(브랜드 선호 판단), price(가격 판단), seller_rating(정렬 기준 자체를 눈으로 확인하기 위해 포함)
- 상위 5개 정렬 검증: VI-00181(5.0/5051), VI-01776(5.0/5351), VI-04811(5.0/8500), VI-04505(5.0/10195), VI-02708(5.0/10442). seller_rating이 전부 5.0(최고 평점)으로 동률이고, 그 안에서 price가 5051→5351→8500→10195→10442로 정확히 오름차순임을 확인 — 2차 정렬이 실제로 작동함.

## (개인) 문제 5 — 자기 highlight 또는 표시 최적화

자기 text 검색에 highlight를 적용하세요. text 검색이 없는 프로젝트라면 `_source` 최소화 전후를 비교하세요.

### 역할·검증 기준

- 검색 field와 highlight field의 관계가 타당해야 합니다.
- 원본 데이터와 강조 조각을 구분합니다.
- 사용자 판단에 실제로 도움이 되는지 평가합니다.

### API와 결과 입력

```http
GET /vintage-items/_search
{
  "size": 5,
  "query": { "match": { "description": "데님" } },
  "highlight": { "fields": { "description": {} } }
}
```

- 선택한 방식과 이유: highlight 선택. `description`은 자유 텍스트 검색이 가능한 field라 "데님"이라는 단어가 실제로 문장 어디에 있는지 사용자에게 시각적으로 보여줄 필요가 있음 (검색어 field와 highlight field를 동일하게 `description`으로 맞춤)
- 실제 결과: 5건(VI-00001, VI-00008, VI-00028, VI-00031, VI-00032) 전부 `highlight.description`에 `<em>데님</em>`으로 강조된 문장이 정확히 반환됨 (예: "90년대 리바이스 <em>데님</em> 자켓, 색빠짐 없이 깔끔함")
- 사용자에게 유용한가: 유용함. description 전체를 다 읽지 않아도 "왜 이 상품이 검색됐는지"를 한눈에 알 수 있어 검색 결과 신뢰도를 높여줌
- 개선할 점: 지금은 `item_name`에서 검색어가 매칭돼도 `item_name`엔 highlight를 안 걸어서, item_name에서 매칭된 경우(예: "데님 자켓")는 강조 표시가 안 보임. 실제 서비스라면 `item_name`도 highlight 대상에 같이 넣는 게 더 좋을 것 같음.
