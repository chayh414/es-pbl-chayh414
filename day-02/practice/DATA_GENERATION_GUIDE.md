# Day 2 개인 대량 데이터 생성 가이드

[교재 T15~16](../student-workbook.md) · [실습 확인표](PRACTICE_GUIDE.md)

## 1. 누가 무엇을 준비하나

강사는 공통12field mapping·공통10000 생성기/loader와 개인 pbl-data-template 전체를 제공한다. 개인 템플릿에는 설정, 생성기, data-contract.ps1, validate-data.ps1, loader, 도서 mapping/검증 예가 있다. 도서 예는 정답이 아니라 규칙 사용 예다.

학생은 개인 index 이름·문서 단위·질문3개·대표3건·전체 mapping을 S33까지 준비한다. S59에서는 후보/범위/확률/결측/ID/seed를 설정으로 옮기고 실제1000건을 생성·적재한다. S67에서 count·분포 검증까지 끝낸다. 이미 만든 index를 다시 PUT하거나 삭제하지 않는다.

## 2. 복사와 경로

배포 day-02/pbl-data-template 전체를 개인 data/pbl-data-template로 복사한다. 폴더 일부만 복사하면 검증 도구가 빠진다. 기존 작업본이 있으면 덮어쓰지 말고 자신의 설정을 보존하여 제공 코드의 변경 부분만 확인한다.

PowerShell 작업 폴더는 개인 저장소의 data/pbl-data-template다. 이 위치에서 mapping은 ../../elasticsearch/index-create.json, 대표 문서는 ../sample-documents.json이다. 개인 루트 requests.http는 ../../requests.http다.

## 3. 설정에 입력할 정보

| 설정 | 학생이 정할 내용 | 확인 |
|---|---|---|
| IndexName | S33에 만든 실제 개인 이름 | 공통 products 아님 |
| DocumentCount | 첫1000 | 필요하면 검증 후 증가, 템플릿 최대100000 |
| Seed | 고정 정수 | 규칙·코드·환경도 함께 보존 |
| IdField | mapping의 업무 ID field | Kind=id, 결측 금지 |
| IdPrefix | BOOK/STAY/ITEM 등 | 생성 ID 중복 방지 |
| SampleCount | 30 | 전체 건수 이하 |
| Vocabularies | 분류·제목 재료·태그 후보 | 실제 질문에 포함/제외 가능한 값 |
| FieldRules | field별 Kind/범위/확률 | mapping 이름·type 일치 |

지원 Kind는 id, choice, weighted_choice, integer, decimal, date, boolean, tags, template다. 필드명은 영문자로 시작하는 영문/숫자/밑줄로 제한한 수업용 규칙을 쓴다. text/keyword는 문자열, integer는 정수, float는 숫자, boolean은 실제 참/거짓, date는 ISO 문자열을 생성한다. 날짜는 YYYY-MM-DD 또는 시간대가 있는 ISO 시각으로 쓴다.

MissingRatio와 TrueRatio는0~1이다. weighted_choice는 음수 가중치를 사용하지 않고 합계가0보다 커야 한다. template가 참조하는 field는 앞에서 생성되어야 하며 결측이 없어야 한다. 모든 생성 field는 mapping에 있어야 한다. title을 만들기 위한 adjective도 source에 남으므로 mapping에 정의하거나 그 field를 사용하지 않는 규칙으로 바꾼다.

## 4. 주제별 작성 대응 예

예시 이름을 그대로 강제하지 않는다. 본인 S33 mapping이 기준이며 생성 설정과 검증 field를 같은 이름으로 고친다.

| 주제 | 질문 예 | 후보/규칙 예 | 검증할 값 |
|---|---|---|---|
| 도서 | 대출 가능한 2020년 이후 과학 도서 | category=소설/과학/역사/예술, status=대출 가능70/대출 중30, published_year=2000~2026 | category/status terms, published_year stats |
| 여행 | 부산에서 1박20만원 이하 숙소 | city=서울/부산/제주, price_per_night=50000~300000, available=true확률0.8 | city terms, price_per_night stats, available terms |
| 콘텐츠 | 공개된 평점4점 이상 영화 | genre=드라마/다큐/애니, rating=2~5, published=true확률0.9, title=분류+순번 | genre terms, rating stats, published terms |

예: 여행 price_per_night의 FieldRule는 Name='price_per_night', Kind='integer', Min=50000, Max=300000이다. available은 Kind='boolean', TrueRatio=0.8이다. city는 choice와 cities 후보 목록을 연결한다. 도서 전용 status/published_year/adjective/title 규칙을 이유 없이 남기지 않는다. 그에 맞춰 실제 mapping·대표 문서·검증 요청을 함께 바꾼다.

data/generation-notes.md에 질문별 포함/제외/경계 사례, 후보/범위, 실제 관찰할 통계를 적는다. 숫자의 허용 범위 양끝이 무작위 표본에 반드시 나오는 것은 아니다. 확률을 정확한 고정 건수로 판정하지 않는다.

## 5. 생성과 경계 사례 고정

기본 생성 명령(개인 data/pbl-data-template에서):

```powershell
.\generator\generate-data.ps1 -SettingsFile .\my-data-settings.ps1 -MappingFile ..\..\elasticsearch\index-create.json
```

대표3건의 포함/제외/경계를 대량 데이터에 확실히 넣으려면 다음을 사용한다.

```powershell
.\generator\generate-data.ps1 -SettingsFile .\my-data-settings.ps1 -MappingFile ..\..\elasticsearch\index-create.json -FixedDocumentsFile ..\sample-documents.json
```

FixedDocumentsFile은 일반 JSON 배열이다. 첫3건의 source를 이 문서들로 만들고, 업무 ID는 생성기의 첫3개 고유 ID로 다시 배정한다. 전체 건수는1000으로 유지한다. 대표 문서의 원래 ID를 ES 조회에 그대로 쓰지 말고 생성 표본에서 실제 ID를 읽는다. 고정 사례가 들어간 만큼 무작위 분포와 차이가 날 수 있으며 그 이유를 기록한다. 이후에는 같은 고정 파일도 재현 자료로 보존한다.

결과는 generated/자기-index-1000.ndjson, 자기-index-sample-30.ndjson, generation-summary.json이다. 파일이 없으면 생성 오류를 해결하며 빈 파일을 만들지 않는다. 실패했는데 이전 생성 파일을 새 성공으로 사용하지 않는다. 새 생성기는 검증을 마친 데이터만 파일로 기록한다.

```powershell
.\validate-data.ps1 -SettingsFile .\my-data-settings.ps1 -MappingFile ..\..\elasticsearch\index-create.json
```

이 검사는 로컬 파일의 줄 구조·고유ID·대상 index·field/type·설정/파일 해시를 확인한다. ES 저장 성공이나 실제 서버 mapping과의 완전한 일치를 대신하지 않는다. 서버 mapping은 T12 GET 응답과 다시 대조한다.

## 6. 적재와 실제 검증

이미 T12에 만든 개인 index를 사용한다. 대상/ID 대체 범위를 확인하고 Day1 docker의 실제 경로를 지정한다.

```powershell
.\load-data.ps1 -SettingsFile .\my-data-settings.ps1 -MappingFile ..\..\elasticsearch\index-create.json -DockerDirectory "C:\수업\es-5days-pbl-course\day-01\docker"
```

loader는 로컬 파일과 index 존재를 확인한 뒤 전송한다. 기존 같은 ID는 대체될 수 있으므로 다른 데이터가 섞였다면 실행 전 중단한다. 자동 index 삭제는 하지 않는다. Bulk 오류가 없더라도 ES count와 분포를 별도로 읽는다. S59에서 마치지 못한 작업은 현재 단계/오류를 기록하고 S67에서 이어간다.

requests/verify-data-template.http는 도서 예시다. 본인 index와 field로 바꾸어 루트 requests.http의 V1-T16-P에 저장한다.

```http
GET /자기-index/_count
GET /자기-index/_search
{
  "size":0,
  "aggs":{
    "categories":{"terms":{"field":"자기-분류-keyword","size":20}},
    "numbers":{"stats":{"field":"자기-숫자-field"}}
  }
}
```

evidence/day-02-data.md에 실제 count·분류별 건수·숫자 최소/최대·확률 관찰값·오류/수정을 저장한다. 처음 빈 index에서 고유1000건을 넣었다면 count1000이다. 이미 다른 문서가 있으면 합계가 다를 수 있어 삭제로 맞추지 않는다.

## 7. 지원 범위와 한계

- 기본 지원: 평면 scalar field와 tags 같은 단순 배열, 이전 field를 사용한 문자열 template, 대표 문서의 고정 사례 삽입.
- 기본 지원 밖: object/nested, 임의 연관관계/조건부 분포, vector, 사용자 지정 date format 등의 전체 ES mapping 기능. S16에서 이런 구조를 구상했다면 Day2 필수 데이터는 평면화 가능한 범위로 명시적으로 한정하거나 강사와 별도 생성 구현을 정한다. 조용히 중첩 관계를 버리지 않는다.
- 고정3건은 경계 검증용이지 현실적인 복합 분포 전체를 보장하지 않는다.
- 코드/후보/seed/고정 문서/환경이 같아야 재현을 비교할 수 있다. generation-rules.json은 공통 설명 자료이며 공통 생성기가 읽는 설정 파일은 아니다.
- 날짜는 정수 초로 생성해 Windows PowerShell 5.1과 PowerShell 7의 소수 초 반올림 차이를 피한다. 재현 확인은 JSON 값 기준이며 직렬화 표기나 줄바꿈의 차이와 구분한다.
- 고정 문서나 생성기 코드 자체를 수정한 경우에도 반드시 다시 생성한다. 로컬 해시 검사는 설정·mapping·전체 NDJSON 대상으로, 모든 소스 파일의 변경을 자동 추적하는 빌드 시스템은 아니다.
- 개인 loader에는 pipeline 인수가 없다. 선택 pipeline은 교재 S67의 임시 단건 방식으로 검증한다.

## 8. 제출

설정·generator·data-contract.ps1·validate-data.ps1·loader·개인 mapping·대표3건·30건 표본·요약·evidence를 제출한다. 전체 NDJSON은 실제 개인 경로를 .gitignore에 적어 제외한다. 상세 목록은 [제출 확인표](PRACTICE_GUIDE.md)를 따른다.
