# Day 3 교시별 실습 문제

각 교시는 5문제로 진행합니다.

- 공통 문제 1: 제공 코드를 실행하고 실제 결과를 기록합니다.
- 공통 문제 2·3: 검색어와 조건만 보고 실행 가능한 Search API 전체를 직접 작성합니다.
- 개인 문제 4·5: 자기 index·mapping·데이터에 맞게 검색 기능을 설계하고 검증합니다.

## 작성 규칙

1. 이 파일들을 개인 PBL 저장소로 복사한 뒤 직접 작성합니다.
2. 실행하지 않은 숫자·문서 ID·결과를 추측해 적지 않습니다.
3. 코드 미제공 문제에는 `GET /내-index/_search`와 JSON body 전체를 작성합니다.
4. 개인 문제는 쇼핑몰 field를 복사하지 말고 자기 mapping에 실제로 존재하는 field를 사용합니다.
5. 결과가 0건이어도 실패로 단정하지 말고 index·field·query·데이터를 확인해 근거를 적습니다.

## 파일

| 교시 | 토픽 | 문제지 |
|---:|---|---|
| 1 | Search API 기본 | [period-01-search-api.md](period-01-search-api.md) |
| 2 | term과 match | [period-02-term-match.md](period-02-term-match.md) |
| 3 | 전문 검색 확장 | [period-03-full-text.md](period-03-full-text.md) |
| 4 | 정확 조건과 경계 | [period-04-filter-range.md](period-04-filter-range.md) |
| 5 | bool 실험 | [period-05-bool.md](period-05-bool.md) |
| 6 | 정렬·highlight | [period-06-sort-highlight.md](period-06-sort-highlight.md) |
| 7 | 검색 품질 점검 | [period-07-quality.md](period-07-quality.md) |
| 8 | 통합·개선·제출 | [period-08-integration.md](period-08-integration.md) |

완성한 개인 Search API는 개인 저장소 루트 `requests.http`에도 `V1-T17-P`~`V1-T21-P` ID로 정리합니다.
