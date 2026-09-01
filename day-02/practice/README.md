# Day 2 실습 안내 — 시작과 제공 파일

[학생교재](../student-workbook.md) · [실습 확인표](PRACTICE_GUIDE.md) · [데이터 생성](DATA_GENERATION_GUIDE.md) · [작성 템플릿](templates/README.md)

## 두 저장소

강사 배포 저장소는 제공 파일을 읽는 곳, 개인 PBL 저장소는 본인 문서·mapping·요청·생성 설정·검증 결과를 보관하는 곳이다. 개인 경로는 모두 개인 저장소 루트 기준이다.

## 제공 파일 지도 (day-02 기준)

| 제공 경로 | 내용 / 사용 |
|---|---|
| student-workbook.md | T09~16 개념·수행 절차·확인 기준 |
| practice/lecture-requests.http | CAT·분석·CRUD·분포·pipeline 공통 요청 |
| data/product-mapping.json | 공통12field·strict·3/1·analyzer 생성 body, S26 |
| data/requests/01-create-products.http | 완전한 공통 PUT, S32 |
| data/generator/generate-products.ps1 | 공통10000 생성, S57 |
| data/load-products.ps1 | 공통 Bulk 전송, S57 |
| pbl-data-template/ 전체 | 개인 생성·검증·적재 도구, S59·67 |
| practice/templates/ | 개인 문서 작성 양식, S3 이후 |

공개된 Day2 자료를 받은 뒤 위 파일이 있는지 확인한다. 제공 파일이 없다면 강사에게 배포 상태를 질문한다. 생성 NDJSON이 없는 것은 해당 생성기를 실행해 해결하며 빈 NDJSON을 만들지 않는다.

## S3 준비

Day1의 최소 제출 구조는 과정 전체의 간략 예시다. Day2의 구체적인 경로·필수 기록은 [실습·제출 확인표](PRACTICE_GUIDE.md)를 따른다. 오늘 요청은 개인 루트 requests.http에 모은다. 기존 elasticsearch/requests.http가 있으면 삭제하지 말고 오늘 파일의 위치를 README에 연결한다. 생성 코드는 data/pbl-data-template/에, 표본과 요약은 그 안의 generated/에 보관하며 data/generator/나 data/sample.ndjson에 똑같은 내용을 중복 복사할 필요는 없다. docs/와 evidence/day-02-data.md는 오늘의 설계·검증 기록으로 작성한다.

1. 개인 저장소에 docs·elasticsearch·data·evidence 폴더가 없으면 만든다.
2. docs/data-model.md, evidence/day-02-data.md, 루트 requests.http가 없으면 새 파일을 만든다. 템플릿은 참고하여 필요한 절을 복사한다.
3. Day1 작성본은 삭제하거나 빈 양식으로 덮어쓰지 않고 확장한다.
4. 개인 index는 S10에 이름을 정하고 S33에 생성한다. S11·26은 현재 성공 응답이 아니라 생성 후 예시다.

종료에는 대표3건·mapping·요청·설정/코드·30건 표본/요약·실제 count/분포·pipeline 판단·commit을 남긴다. 전체 NDJSON과 비밀정보는 제외한다.
