# 개인 작성 양식

아래 파일을 개인 경로에 복사하되 기존 파일이 있으면 필요한 절만 추가한다. 작성 칸을 실제 값으로 채운다. 예시 응답은 제공하지 않으며 학생 본인의 실행 결과를 기록한다.

| 제공 양식 | 개인 저장 경로 | 사용 |
|---|---|---|
| data-model-template.md | docs/data-model.md | S3~28 |
| evidence-template.md | evidence/day-02-data.md | S3~69 |
| generation-notes-template.md | data/generation-notes.md | S53~67 |
| pipeline-decision-template.md | docs/pipeline-decision.md | S66~67 |
| requests-template.http | 루트 requests.http | S7~67 |

data/sample-documents.json은 학생이 대표3건을 일반 JSON 배열로 작성한다. elasticsearch/index-create.json은 학생이 settings와 mappings 전체 body를 작성한다. 없는 경우 새 파일로 만든다. 제공 도서 예시는 배포 pbl-data-template/elasticsearch/create-index-template.http를 참고하되 개인 정본을 대신하여 다시 실행하지 않는다.

생성되는 NDJSON/요약은 빈 파일을 만들지 않는다. [생성 가이드](../DATA_GENERATION_GUIDE.md)를 따른다.
