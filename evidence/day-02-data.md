# Day 2 실제 실행 증거

공통과 개인을 구분한다. 실행하지 않은 결과는 미실행으로 적는다. 비밀번호/인증 헤더를 기록하지 않는다.

## V1-T09-C/P 환경

- 실제 node 이름/버전/master: 미확인
- products 존재 여부 / 실제 CAT 값: 미실행 (공통 실습 미착수)
- 개인 index 이름: vintage-items

## V1-T12-C/P 생성/조회

- 공통/개인 구분, 대상 index: 개인, `vintage-items`
- 신규 생성 또는 기존 확인: 신규 생성 (`PUT /vintage-items`)
- 요청과 실제 응답(settings/mapping/shards):

  `GET /vintage-items/_mapping` 실제 응답 — `elasticsearch/index-create.json`과 완전히 일치 (17개 field, item_name keyword sub-field 포함):

  ```json
  {
    "vintage-items": {
      "mappings": {
        "dynamic": "strict",
        "properties": {
          "brand": { "type": "keyword" },
          "brand_tier": { "type": "keyword" },
          "category": { "type": "keyword" },
          "color": { "type": "keyword" },
          "condition": { "type": "keyword" },
          "defects": { "type": "text" },
          "description": { "type": "text" },
          "era": { "type": "keyword" },
          "item_name": {
            "type": "text",
            "fields": { "keyword": { "type": "keyword" } }
          },
          "listed_date": { "type": "date" },
          "material": { "type": "keyword" },
          "original_price": { "type": "integer" },
          "platform": { "type": "keyword" },
          "price": { "type": "integer" },
          "seller_rating": { "type": "float" },
          "size": { "type": "keyword" },
          "sold": { "type": "boolean" }
        }
      }
    }
  }
  ```

  `GET /_cat/shards/vintage-items?v` 실제 응답:

  ```
  index         shard prirep state   docs store dataset ip         node
  vintage-items 0     p      STARTED    3  24kb    24kb 172.19.0.3 es01
  vintage-items 0     r      STARTED    3  24kb    24kb 172.19.0.5 es03
  ```

- 기대/실제 비교: primary 1개(es01)·replica 1개(es03) 모두 `STARTED`로 정상 배치되어 기대(`number_of_shards=1`, `number_of_replicas=1`)와 일치. 대표 문서 3건(`_id`=1,2,3) 색인 후 `docs=3`으로 primary/replica 모두 일치, `GET /vintage-items/_search`에서도 `hits.total.value=3`으로 확인됨. mapping도 요청한 type과 전부 일치.

## V1-T13-C/P 분석

| 입력 | 방식(standard/field) | 예상 token | 실제 token/position | 차이 이유 |
|---|---|---|---|---|
| | | | | |

미실행.

## V1-T14-C/P CRUD

- 대상 index / 임시 ID / 출발 count: 미실행

| 단계 | 예상 result | 실제 result | 실제 source/변경·유지 field |
|---|---|---|---|
| 생성 | | | |
| 조회 | | | |
| 수정/재조회 | | | |
| 삭제/재조회 | | | |

- 삭제 뒤 found/count: 미실행
- 선택 noop/not_found 관찰: 미실행

## V1-T15-C/P 생성·적재

- 생성 설정/명령/건수/seed: 미실행 (대표 3건만 수기 색인 완료, 1,000건 생성기 미실행)
- 로컬 검사 결과: 미실행
- 표본 ID/field/조건 사례 확인: 미실행
- 실제 Bulk 결과 / 현재 단계 / S67에서 이어 할 작업: `data/pbl-data-template/` 개인 복사·설정 전, 생성기 미실행 상태. 다음 작업으로 이어감.

## V1-T16-C simulate

| 입력 사례 | 예상 변화/오류 | 실제 변화/오류 | 저장 여부 |
|---|---|---|---|
| Samsung | | | |
| Apple | | | |
| in_stock=false | | | |
| temp 누락 | | | |

미실행.

## V1-T16-P 필수 개인 완료

- 개인 index / 생성 건수 / 실제 ES count: `vintage-items` / 대표 3건만 색인 / 실제 count=3
- 분류 terms / 숫자 stats / 필요한 날짜 범위: 미실행
- 계획과 실제 분포 차이 이유: 아직 1,000건 규모 데이터가 없어 분포 비교 불가
- 선택 pipeline 실제 단건/GET/정리 결과(미구현이면 해당 없음): 해당 없음 (미구현)

## 오류·재검증

| 요청/파일 | 오류 | 수정 | 실제 재실행 결과 | 다음 조치 |
|---|---|---|---|---|
| | | | | |

없음.

## 제출

- commit hash / 현재 branch: (커밋 후 기록)
- GitHub에서 확인한 동일 commit / push 실패라면 원인: (커밋 후 기록)
- 미완료와 다음 요청: `_analyze`(T13), CRUD(T14), 1,000건 생성·적재(T15), 집계(T16) 남음
