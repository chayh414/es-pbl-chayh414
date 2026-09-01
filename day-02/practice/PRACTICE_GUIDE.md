# Day 2 실습·산출물 확인표

69장 PPT와 [학생교재](../student-workbook.md) 기준. C는 공통, P는 개인 적용이다. S번호는 실제 PPT 번호다.

| ID | PPT | 작업 | 완료 근거 |
|---|---|---|---|
| V1-T09-C/P | S4~12 | 실제 CAT·개인 index/문서/ID 정의 | node·버전·존재 여부·개인 이름/단위 |
| V1-T10-C/P | S13~20 | 질문3개·대표3건·field 목적 | 포함/제외/경계 JSON·질문별 역할 |
| V1-T11-C/P | S21~28 | 공통 mapping·개인 초안 | field/type/근거·JSON 문법 |
| V1-T12-C/P | S29~36 | 공통/개인 생성·조회·shard | 개인 전체 mapping·1primary/1replica |
| V1-T13-C/P | S37~44 | 개인3입력×2분석방식 | 예상/실제 token·차이 이유 |
| V1-T14-C/P | S45~52 | CRUD·전후 비교·정리 | result/source·삭제 후 found:false·출발 count |
| V1-T15-C/P | S53~60 | 공통10000·개인1000 착수 | 규칙/표본/적재, 개인 미완료는 S67로 |
| V1-T16-C/P | S61~69 | simulate·개인 적재완료·판단·선택 구현 | 필수 count/분포·판단·commit/원격 확인 |

## 개인 파일별 작성·제출

없는 개인 Markdown/JSON/HTTP 파일은 새로 만든다. 기존 것은 확장한다. 생성 결과는 생성기가 만들며 빈 파일로 대체하지 않는다.

| 개인 저장소 경로 | 내용 | 제출 |
|---|---|---|
| docs/data-model.md | index·문서·ID·질문3개·field/type/근거 | 포함 |
| data/sample-documents.json | 직접 설계한 대표3건 JSON 배열 | 포함 |
| elasticsearch/index-create.json | 전체 settings/mappings body | 포함 |
| requests.http | 개인 생성/조회/분석/CRUD/분포·선택 pipeline | 포함 |
| data/generation-notes.md | 건수·seed·후보/범위/비율/결측·검증 | 포함 |
| data/pbl-data-template/ | 설정·생성/검증/적재 코드·README | 코드 포함 |
| data/pbl-data-template/generated/자기-index-1000.ndjson | 전체 Bulk 데이터 | 제외 |
| data/pbl-data-template/generated/자기-index-sample-30.ndjson | 생성기30건 표본 | 포함 |
| data/pbl-data-template/generated/generation-summary.json | 생성 조건·해시·건수 | 포함 |
| evidence/day-02-data.md | 실제 요청·응답·판정·오류/조치 | 포함 |
| docs/pipeline-decision.md | 적용/미적용/보류·대상·입출력·처리 위치 | 포함 |
| README.md | 실행/재현 순서·위 파일 링크·제한 | 포함 |
| .gitignore | 실제 전체 파일 경로·비밀정보 제외 | 포함 |

예: `.gitignore`에 `data/pbl-data-template/generated/library-books-1000.ndjson`을 적는다. 건수를 변경해 새 전체 파일이 생기면 그것도 제외한다. generated 폴더 전체를 제외하면 표본·요약도 빠진다. 이미 추적 중인 파일은 ignore만으로 제외되지 않으므로 staging을 확인하고 질문한다.

## 자가 점검

- [ ] 모든 요청·설정·mapping의 개인 index와 field가 같다.
- [ ] 대표3건과 생성기30건 표본을 모두 보존했다.
- [ ] 개인 실제 count/분포를 확인했고 공통 응답을 개인 증거로 제출하지 않았다.
- [ ] pipeline 미구현과 개인 적재 미완료를 혼동하지 않았다.
- [ ] 오류·현재 단계·다음 조치를 적었으며 성공 응답을 지어내지 않았다.
- [ ] git diff --cached에 .env·인증값·전체 데이터가 없다.
- [ ] commit 뒤 현재 branch/remote를 확인해 push하고 GitHub에서 같은 commit을 확인했다. 원격 실패는 로컬 성공과 구분해 기록했다.
