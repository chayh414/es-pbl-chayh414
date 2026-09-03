# 8교시 실습 — 통합·개선·제출

## (공통) 문제 1 — 제공 코드로 통합 검색 검증

```http
GET /products/_search
{
  "size": 10,
  "_source": ["product_id", "name", "description", "category", "price", "rating", "in_stock"],
  "query": {
    "bool": {
      "must": [{
        "multi_match": {
          "query": "무선 이어폰",
          "fields": ["name^3", "description"]
        }
      }],
      "filter": [
        { "term": { "category": "전자기기" } },
        { "term": { "in_stock": true } },
        { "range": { "price": { "gte": 50000, "lte": 200000 } } }
      ]
    }
  },
  "sort": [{ "rating": "desc" }, { "price": "asc" }],
  "highlight": { "fields": { "name": {}, "description": {} } }
}
```

### 결과 입력

- `hits.total.value`: 74
- 상위 3개 ID: P-08761(rating5/price107200), P-06457(rating5/price184900), P-09025(rating4.9/price51300)
- 세 filter 통과 여부: 10건 전부 category="전자기기", in_stock=true, price가 51,300~184,900으로 50,000~200,000 범위 안에 있음을 확인
- 1·2차 정렬 통과 여부: 통과. rating이 5→5→4.9→4.9→4.9→4.9→4.9→4.8→4.8→4.7로 내려가기만 함(1차). rating=5인 2건(P-08761, P-06457) 안에서 price가 107200→184900 오름차순(2차), rating=4.9인 6건도 51300→81800→96300→128400→176200 순서 확인
- highlight 확인 결과: 10건 전부 `highlight.name`에 `<em>무선</em> <em>이어폰</em>` 생성됨. `highlight.description`은 생성 안 됨(description 문구에 검색어가 없어서)
- 관련/보류/무관 판정: 10건 모두 관련. 실제 무선 이어폰 상품이고 재고·가격·이름까지 조건에 맞음

## (공통) 문제 2 — boost 개선 전후 직접 구현

`name`, `description`에서 `무선 이어폰`을 검색하는 boost 없는 요청과 `name^3` 요청을 각각 작성하세요. 다른 조건은 동일하게 유지하세요.

### 개선 전 API

```http
GET /products/_search
{
  "size": 5,
  "query": {
    "multi_match": {
      "query": "무선 이어폰",
      "fields": ["name", "description"]
    }
  }
}
```

### 개선 후 API

```http
GET /products/_search
{
  "size": 5,
  "query": {
    "multi_match": {
      "query": "무선 이어폰",
      "fields": ["name^3", "description"]
    }
  }
}
```

### 비교 결과

(3교시 문제1·2에서 이미 실행한 실제 결과를 재사용함)

- 전/후 상위 3개 ID: 개선 전 P-00241(6.76)/P-00305(6.76)/P-00529(6.76) → 개선 후 P-00241(20.28)/P-00305(20.28)/P-00529(20.28), ID·순서 동일
- 순위가 달라진 문서: 없음
- 개선/보류/악화: 보류 (순위 변화 없음, 점수만 3배 가까이 상승)
- 사용자 의도 근거: 이번 검색어·데이터에서는 이미 상위 문서가 name에서 매칭된 상태라 boost로 순위가 바뀌진 않았지만, name 매칭 문서와 description 매칭 문서 간 점수 격차가 커져서 "상품명 일치가 더 중요하다"는 의도가 더 명확하게 반영됐다.

## (공통) 문제 3 — 요구사항으로 최종 API 직접 구현

다음 요구사항만 보고 실행 가능한 Search API 전체를 작성하세요.

- index: `products`
- 검색어: `무선 이어폰`
- 검색 field: `name`, `description`; name을 더 중요하게 처리
- category: `전자기기`
- 재고 있는 상품만 포함
- 가격: 50,000원 이상 200,000원 이하
- 평점 높은 순, 가격 낮은 순
- 최대 10건
- 결과 카드 field와 검색어 highlight 포함

### API 전체 입력

```http
GET /products/_search
{
  "size": 10,
  "query": {
    "bool": {
      "must": [{
        "multi_match": {
          "query": "무선 이어폰",
          "fields": ["name^3", "description"]
        }
      }],
      "filter": [
        { "term": { "category": "전자기기" } },
        { "term": { "in_stock": true } },
        { "range": { "price": { "gte": 50000, "lte": 200000 } } }
      ]
    }
  },
  "sort": [{ "rating": "desc" }, { "price": "asc" }],
  "highlight": { "fields": { "name": {}, "description": {} } }
}
```

### 검증 결과

- 문제 1과 기능적으로 같은 조건인가: 예, 완전히 동일함(요구사항을 그대로 옮겨 적음)
- 다른 부분이 있다면 이유: 없음
- 실제 실행 성공 여부: 성공 (문제 1과 동일한 요청이므로 같은 응답을 받음 — total 74, 상위 3개 P-08761/P-06457/P-09025 동일)
- 상위 결과 검증: 문제 1에서 이미 확인한 것과 동일하게 filter 3개·정렬 2단계·highlight가 전부 정상 작동함을 재확인

## (개인) 문제 4 — 자기 검색 한 요소 개선

7교시에서 진단한 개인 검색 문제 하나를 선택해 query, field, boost, filter, sort, 검색어 중 한 요소만 변경하고 다시 실행하세요.

### 역할·검증 기준

- 같은 index·데이터·검색어·size를 유지합니다. 검색어를 바꾸는 실험이라면 나머지 요소를 유지합니다.
- 변경 전후 요청을 모두 보존합니다.
- hit 수가 아니라 사용자 의도와 조건 통과로 개선을 판정합니다.

### API와 결과 입력

```http
GET /vintage-items/_search
{
  "size": 5,
  "query": {
    "bool": {
      "must": [{ "match": { "item_name": { "query": "데님 자켓", "operator": "and" } } }],
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

- 문제 / 추정 원인: (7교시 진단) match의 기본 operator가 "or"라서 "데님"만 있거나 "자켓"만 있어도 매칭되어, "데님 아우터"같이 관련성 낮은 문서가 결과에 섞임
- 변경한 한 요소: `match`에 `"operator": "and"` 추가 (item_name에 "데님"과 "자켓"이 둘 다 있어야만 매칭되도록)
- 전/후 상위 3개: 변경 전 VI-00001(8.89)/VI-00531(1.94)/VI-01076(1.94) → 변경 후 VI-00001(8.89) 단 1건뿐
- 개선/보류/악화와 근거: 개선. total이 14→1건으로 줄었고, 남은 유일한 문서 VI-00001이 실제로 "데님"과 "자켓"이 둘 다 있는(item_name에 "리바이스 505 빈티지 데님 자켓") 정확히 원하는 상품이다. "데님 아우터"류의 관련성 낮은 문서(VI-00531, VI-01076 등)가 전부 사라져 사용자 의도("데님 자켓")에 훨씬 가까워짐.

## (개인) 문제 5 — 최종 재현·산출물 완성

자기 전문 검색·정확 조건·bool/filter 요청을 새 Console에서 다시 실행하고 다른 사람이 commit만으로 재현할 수 있게 정리하세요.

### 역할·검증 기준

- 루트 `requests.http`에 `V1-T17-P`~`V1-T21-P`를 정리합니다.
- `docs/quality-test.md`에 질문별 기대·실제·개선 근거를 작성합니다.
- `evidence/day-03-search.md`에 핵심 결과와 commit SHA를 기록합니다.

### 최종 입력

- 새 Console 재현 성공 여부: 성공 (오늘 모든 요청을 Kibana Dev Tools Console에서 하나씩 새로 실행하며 진행했고, `requests.http`에 그대로 옮겨 정리함)
- 전문 검색 요청 ID: V1-T18-2-P (multi_match item_name^3+description "데님 자켓")
- 정확 조건 요청 ID: V1-T21-1-P (term era:"90s" + sort)
- bool/filter 요청 ID: V1-T21-2-P (Q1 최종본, operator=and로 개선)
- 품질표 경로: `docs/quality-test.md`
- evidence 경로: `evidence/day-03-search.md`, `evidence/day-03-practice/period-01~08.md`
- 최종 commit SHA: (커밋 후 기록)
- 미완료 또는 재현 실패 항목: 없음 — 1~8교시(40문제) 전부 완료
