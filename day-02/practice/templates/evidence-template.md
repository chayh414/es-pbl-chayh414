# Day 2 실제 실행 증거

공통과 개인을 구분한다. 실행하지 않은 결과는 미실행으로 적는다. 비밀번호/인증 헤더를 기록하지 않는다.

## V1-T09-C/P 환경

- 실제 node 이름/버전/master:
- products 존재 여부 / 실제 CAT 값:
- 개인 index 이름:

## V1-T12-C/P 생성/조회

- 공통/개인 구분, 대상 index:
- 신규 생성 또는 기존 확인:
- 요청과 실제 응답(settings/mapping/shards):
- 기대/실제 비교:

## V1-T13-C/P 분석

| 입력 | 방식(standard/field) | 예상 token | 실제 token/position | 차이 이유 |
|---|---|---|---|---|
| | | | | |

개인 검색어3개를 두 방식으로 각각 기록한다. 요청은 루트 requests.http에 보존한다.

## V1-T14-C/P CRUD

- 대상 index / 임시 ID / 출발 count:

| 단계 | 예상 result | 실제 result | 실제 source/변경·유지 field |
|---|---|---|---|
| 생성 | | | |
| 조회 | | | |
| 수정/재조회 | | | |
| 삭제/재조회 | | | |

- 삭제 뒤 found/count:
- 선택 noop/not_found 관찰:

## V1-T15-C/P 생성·적재

- 생성 설정/명령/건수/seed:
- 로컬 검사 결과:
- 표본 ID/field/조건 사례 확인:
- 실제 Bulk 결과 / 현재 단계 / S67에서 이어 할 작업:

## V1-T16-C simulate

| 입력 사례 | 예상 변화/오류 | 실제 변화/오류 | 저장 여부 |
|---|---|---|---|
| Samsung | | | |
| Apple | | | |
| in_stock=false | | | |
| temp 누락 | | | |

## V1-T16-P 필수 개인 완료

- 개인 index / 생성 건수 / 실제 ES count:
- 분류 terms / 숫자 stats / 필요한 날짜 범위:
- 계획과 실제 분포 차이 이유:
- 선택 pipeline 실제 단건/GET/정리 결과(미구현이면 해당 없음):

## 오류·재검증

| 요청/파일 | 오류 | 수정 | 실제 재실행 결과 | 다음 조치 |
|---|---|---|---|---|
| | | | | |

## 제출

- commit hash / 현재 branch:
- GitHub에서 확인한 동일 commit / push 실패라면 원인:
- 미완료와 다음 요청:
