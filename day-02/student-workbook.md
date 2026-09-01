# Day 2 학생교재 — 데이터 모델링과 적재

2026-09-01 동기화판. 69장 PPT · ES/Kibana 9.5.0 · Windows 11.
[시작 안내](practice/README.md) · [실습/제출 확인표](practice/PRACTICE_GUIDE.md) · [공통 요청](practice/lecture-requests.http) · [생성 가이드](practice/DATA_GENERATION_GUIDE.md) · [작성 양식](practice/templates/README.md)

공통 실습은 products, 개인 실습은 본인이 정한 index에서 진행한다. C는 공통, P는 개인 적용이다. 아래 슬라이드 번호는 실제 PPT 번호이며 토픽마다 다시 시작하지 않는다. 요청 하나씩 Console에 복사하고 PowerShell 명령은 별도 PowerShell에서 실행한다. 생성·삭제·수정을 일괄 실행하지 않는다.

## 시작 준비 — S1~3

배포 저장소와 개인 저장소를 구분한다. 개인 저장소에 docs, elasticsearch, data, evidence 폴더가 없으면 생성한다. docs/data-model.md, evidence/day-02-data.md, 루트 requests.http도 없으면 새 파일을 만든다. Day 1 작성본은 유지하고 확장한다. 전체 자료를 아직 받지 못했다면 파일을 임의로 만들어 대신하지 말고 배포 상태를 질문한다.

이 교재의 요청 중 자기-index, 자기-field 같은 표시는 반드시 실제 값으로 바꾼다. 요청 파일과 생성기의 IndexName을 끝까지 동일하게 유지한다. 기록은 예시 결과를 옮기는 것이 아니라 실제 응답으로 작성한다. 공통 예제만 완료하고 개인 데이터가 없으면 Day 2 개인 과제는 미완료다.

## T09 · ES 구조와 Console — S4~12

### 개념·예제

cluster는 함께 동작하는 node 집합, index는 같은 검색 목적의 document 묶음이다. document 한 건은 JSON 객체이고 field는 속성이다. products는 상품 한 건이 아니라 상품 문서 묶음이다. product_id는 업무 ID, _id는 ES 메타데이터로 같은 값을 쓸 수 있지만 자동 동기화되지 않는다.

CAT은 사람이 상태를 읽는 표다. v는 열 이름 표시, h는 표시할 열 선택이며 v만으로 version 열이 생기지 않는다. 애플리케이션 연동에는 JSON API를 사용한다.

### V1-T09-C · 환경을 실제 응답으로 관찰 — S7~9

Console에서 다음을 하나씩 실행한다. [공통 파일](practice/lecture-requests.http)의 T09 부분도 사용할 수 있다.

~~~http
GET /_cat/nodes?v
GET /_cat/nodes?v&h=name,ip,node.role,master,version
GET /_cat/indices?v
~~~

evidence/day-02-data.md의 T09에 실제 node 이름·버전·master를 적는다. 세 node와 version 9.5.0을 확인한다. master 별표는 선출 결과이며 m 역할과 다르다. index 목록에서 products의 존재 여부를 적는다. S32 생성 전이므로 없을 수 있다. 없는 상태와 존재하지만0건인 상태는 다르다. 기존 index를 지우거나 그림에 맞추기 위해 먼저 만들지 않는다. CAT docs.count와 사용자 문서 수 _count는 같은 개념으로 단정하지 않는다.

### V1-T09-P · 내 문서 단위와 이름 — S10~12

docs/data-model.md에 개인 index 이름, 문서 한 건의 의미, 업무 ID field, 예시 ID를 적는다. 소문자 영문·숫자·하이픈 중심의 이름을 사용한다. requests.http에 아래 요청을 적되 생성 후 확인용이라고 주석을 붙인다.

~~~http
### V1-T09-P 생성 후 실행 — 자기-index를 실제 이름으로 변경
GET /자기-index/_mapping
~~~

S11은 요청 의미와 생성 후 응답 예시다. 지금 성공 응답을 기록하지 않는다. 완료 기준은 이름/문서/ID가 명확하고 실제 환경 기록과 생성 후 요청이 저장된 것이다. node가 안 보이거나 접속 오류면 Day1 환경 상태를 확인하고 오류를 질문한다. system index를 삭제하지 않는다.

## T10 · 데이터 모델링 — S13~20

### 개념·예제

검색 결과 한 줄에 해당하는 대상 하나를 문서로 삼는다. 쇼핑몰 질문 “재고가 있고 5만원 이상 20만원 이하인 전자기기를 가격순으로 찾기”는 category, price, in_stock이 필요하다. name은 검색/표시, price는 조건/정렬/표시처럼 한 field에 여러 역할이 있을 수 있다.

공통 schema는 product_id, name, description, category, brand, price, rating, review_count, in_stock, tags, created_at, updated_at 12개다. image_url·brand_info는 추가 설계 예시이며 공통 strict products에는 넣지 않는다. 단순 값 배열 tags는 같은 타입 여러 값이며 별도 array type을 선언하지 않는다. 객체 배열의 개별 값 관계를 유지해야 하면 nested를 검토하되, 제공 개인 생성기의 기본 지원은 평면 field와 tags 배열이다. 복합 구조는 [생성 가이드](practice/DATA_GENERATION_GUIDE.md)의 지원 범위를 먼저 확인한다.

### V1-T10-C · 질문의 포함/제외/경계 판단 — S14~19

위 쇼핑몰 질문에서 price=50000과 price=200000은 포함 경계다. price=49900은 제외, in_stock=false도 제외다. 분류가 다르면 가격이 범위 안이어도 제외된다. 각 예시가 포함되는지와 그 field 근거를 말이나 문서로 정리한다. 아직 검색 query를 실행해 검증하는 단계는 아니다.

### V1-T10-P · 대표 문서 3건과 목적 표 — S18~20

1. docs/data-model.md에 본인의 질문3개를 적고 검색어·조건·정렬·표시·필요 field로 분해한다.
2. data/sample-documents.json이 없으면 생성하여 대표 문서3건을 일반 JSON 배열로 작성한다. 최소 포함1건·제외1건·경계1건을 넣는다. 이는 Bulk NDJSON과 다른 파일이다.
3. docs/data-model.md에 field, 예시 값, 역할, 연결 질문, 선택 이유 표를 만든다.
4. 개인정보·실제 고객 자료를 제외하고 합성 값을 사용한다. 제외 이유를 남긴다.
5. 혼자서 세 문서의 조건을 대조하고 부족한 field를 문서와 표 양쪽에 수정한다.

도서 예: “대출 가능하고 2020년 이후 출판된 과학 도서를 평점순으로”라면 category, status, published_year, rating이 필요하다. 2020년 경계 문서, 대출 중인 제외 문서, 2024년 포함 문서를 작성할 수 있다. 이는 예시이며 본인이 정한 schema가 기준이다. 먼저 마치면 경계 밖 반례1건을 추가하고 예상 포함 여부를 적는다. 완료 기준은 세 JSON의 문법과 질문별 근거가 맞는 것이다.

## T11 · mapping과 field type — S21~28

### 개념·예제

mapping은 field 이름과 type을 정하는 계약이다. text는 분석된 token 기반 전문 검색, keyword는 원값 filter/정렬/집계, integer는 정수, float는 소수, boolean은 참/거짓, date는 날짜에 사용한다. type은 문자열 모양만이 아니라 질문에서의 역할로 고른다. 숫자는 숫자 값, boolean은 true/false로 생성한다.

name.keyword는 name의 multi-field다. 원본 JSON에 name.keyword를 따로 입력하지 않는다. name은 검색, name.keyword는 정렬/정확 비교에 사용한다. dynamic:strict는 미정의 field를 거부하지만 모든 field를 필수로 만들지는 않는다.

### V1-T11-C · 완전한 공통 파일 읽기 — S26

편집기로 [data/product-mapping.json](data/product-mapping.json)을 연다. settings와 mappings가 최상위에 있고 properties에 공통12field가 있는지 본다. name과 description의 korean_search는 이 자료에서 standard로 정의한 이름이며 한국어 형태소 분석기가 아니다. name에는 keyword 하위 field가 있다. S26 화면은 생성 후 GET의 발췌다. 지금은 파일을 읽으며 아직 products가 없는데 성공 GET을 요구하지 않는다.

### V1-T11-P · 내 mapping 초안 — S27~28

목적 표에 type·선택 근거·질문 번호를 추가한다. elasticsearch/index-create.json이 없으면 생성하고 settings/mappings가 들어갈 JSON body를 작성한다. 대표 문서의 모든 field를 정의한다. text 중 원값 정렬/비교가 필요한 것만 keyword 하위 field를 둔다. 개인 생성기는 다음에도 이 mapping을 기준으로 맞춘다.

완료 기준: 대표3건의 field와 type이 맞고 선택 이유를 질문으로 설명할 수 있다. 날짜 문자열 형식, 숫자와 문자열, boolean과 “있음/없음” 혼용을 점검한다. 먼저 마치면 type을 잘못 고를 때 불가능해지는 질문2개를 적는다. 이 단계에서는 생성하지 않는다.

## T12 · index 생성과 settings — S29~36

### 개념·예제

settings는 shard/replica/analyzer 같은 index 동작, mappings는 field schema다. 공통 products는 primary3·각 replica1, 개인 index는 primary1·replica1이다. 정상 할당된 사본은 각각6개·2개이며 세 node에 반드시 개인 사본 하나씩 배치되는 것은 아니다.

### V1-T12-C · 공통 생성 — S31~32

1. Console에서 GET /products로 존재 여부를 확인한다.
2. 없다면 [01-create-products.http](data/requests/01-create-products.http)의 완전한 PUT body를 한 번 실행한다. 그림의 발췌나 줄임표는 실행 JSON으로 사용하지 않는다.
3. 이미 있다면 GET으로 settings/mapping을 비교한다. 다르면 적재하지 말고 질문한다. 삭제해서 맞추지 않는다.
4. 생성 후 아래 요청을 각각 확인한다.

~~~http
GET /products/_mapping
GET /products/_count
GET /_cat/shards/products?v
~~~

새 index라면 count0, 아직10000이 아니다. acknowledged와 shards_acknowledged를 구분한다. 후자가 false라도 index 자체는 생성됐을 수 있어 무조건 재PUT하지 않는다.

### V1-T12-P · 개인 생성과 증거 — S33~35

elasticsearch/index-create.json에 개인 전체 mapping과 settings(number_of_shards=1, number_of_replicas=1)을 완성한다. 화면의 my-index/name/price/in_stock은 최소 예시이며 개인 field를 세 개로 제한하는 지시가 아니다. requests.http에 실제 개인 이름의 GET 존재 확인과 PUT 생성 body를 작성한다.

~~~http
### V1-T12-P — 실제 개인 이름으로 변경
GET /자기-index
# 없을 때만 PUT /자기-index 뒤에 index-create.json 전체 body를 붙여 실행
GET /자기-index/_mapping
GET /_cat/shards/자기-index?v
~~~

evidence/day-02-data.md T12에 생성 또는 기존 확인 여부, 실제 settings/mapping 응답과 shard의 p/r·상태·node를 기록한다. UNASSIGNED를 STARTED라고 적지 않는다. 앞서 만든 index를 T15에서 다시 생성하지 않는다.

오류는 요청별로 기록한다. 없는 index GET의404, 이미 존재하는 index PUT의 resource_already_exists_exception, 기존 field type 변경 오류는 다르다. 요청·error.type/reason·수정·재실행 결과를 남긴다. node 중단이나 수동 shard 이동 실험은 하지 않는다.

## T13 · analyzer — S37~44

### 개념·예제

analyzer는 문자열을 token으로 바꾼다. character filter → tokenizer → token filter 흐름이며 모든 분석기에 character filter가 필수는 아니다. token 값과 position을 먼저 읽고 offset을 확인한다. _analyze는 문서를 저장하거나 검색하지 않는다.

### V1-T13-C · 동일 입력으로 비교 — S39~41

[공통 요청](practice/lecture-requests.http)의 S39와 S40을 사용한다.

~~~http
POST /products/_analyze
{"field":"name","text":"SoundLab 무선 이어폰"}

POST /_analyze
{"analyzer":"standard","text":"SoundLab 무선 이어폰"}
~~~

첫 요청은 실제 products/name 설정, 둘째는 standard 직접 지정이다. 기본 관찰값은 soundlab, 무선, 이어폰 / position0,1,2 / offset0~8,9~11,12~15다. 끝 offset은 마지막 문자 다음 위치다. _source를 소문자로 바꾸지 않는다. 대소문자/공백을 변경한 추가 실험은 기본 입력과 따로 기록한다.

### V1-T13-P · 개인 검색어3개×2방식 — S42~44

requests.http의 V1-T13-P에 먼저 standard 직접 지정, 다음 POST /자기-index/_analyze에 실제 text field 지정 요청을 저장한다. 검색어3개마다 원문·예상 token·실제 token·차이 이유를 evidence/day-02-data.md에 적는다. 두 결과가 같아도 정상이다. 별도 search_analyzer가 있다면 이 관찰만으로 검색 과정 전체를 검증한 것은 아니다.

완료 기준은 실제 field 설정과 입력이 기록되고 token을 검색 문서 수로 혼동하지 않는 것이다. S43~44의 match/term은 Day3 연결 예이며 지금 실행 필수 과제가 아니다. 빨리 마치면 주제 복합어·영문 대소문자·공백을 바꾸어 비교한다.

## T14 · 문서 CRUD — S45~52

### 개념·예제

일반 PUT /index/_doc/id는 전체 문서를 색인하여 같은 ID면 대체할 수 있다. 실습은 op_type=create로 기존 문서 덮어쓰기를 막는다. _update의 doc은 일부 field 수정이다. 동일 값 update는 noop일 수 있다.

### V1-T14-C · 공통 상태 추적

[공통 요청](practice/lecture-requests.http)의 T14 요청을 한 개씩 실행한다. 이 교재에 연결된 요청 파일만 사용한다.

| 슬라이드 | 동작 | 실제 확인 |
|---|---|---|
| S45 | _count와 GET P-0001 | 출발 건수C, 미사용 ID |
| S46 | create 옵션 PUT | created, price89000, category이어폰, rating4.6 |
| S47 | 부분 수정 개념 설명만 | 아직 update 실행하지 않음 |
| S48 | 같은 ID GET만 | found:true, 수정 전 source 저장 |
| S49 | price79000 update → GET | price만 변경, 나머지 유지 |
| S50 | 본인 임시 ID DELETE → GET | deleted 뒤404/found:false |
| S52 | count 비교 | 신규 빈 index라면0, 기존이면 출발C와 비교 |

P-0001이 이미 있으면 지우지 말고 미사용 ID로 요청 전체와 product_id를 함께 바꾼다. 화면 값을 따라 일반 PUT을 다시 보내지 않는다. DELETE 요청에 refresh=wait_for를 지정한 뒤 _count로 확인한다. 동시 작업이 있으면 count만으로 잔존 여부를 단정하지 않는다.

### V1-T14-P · 개인 CRUD — S51

본인 mapping에 맞는 임시 문서로 생성·조회·수정·재조회·삭제·삭제 후 조회를 연결한다. requests.http에 V1-T14-P로 저장한다. evidence/day-02-data.md에는 예상/실제 result, 변경 전후 source, 유지된 field, 마지막 found와 count를 남긴다. 먼저 마치면 삭제 전에 동일 값 update의 noop을 확인하고 삭제 후 두 번째 DELETE의 not_found를 관찰한다. index 전체나 기존 업무 문서를 삭제하지 않는다.

## T15 · 대량 더미 데이터와 Bulk — S53~60

### 개념·예제

데이터의 목적은 질문을 검증하는 것이다. 포함/제외/경계, 분류·가격·재고·날짜 차이를 설계한다. 공통은 Count10000, Seed9502026, category8개×1250, 재고 true85% 확률이다. 확률이므로 true가 정확히8500일 필요가 없고 허용 범위 끝값이 실제 최솟값/최댓값으로 반드시 나오지도 않는다. 재현에는 생성 코드·설정·실행 환경까지 같아야 한다.

Bulk의 index/create는 action metadata 한 줄과 source 한 줄이다. JSON 배열이 아니고 빈 줄/줄 사이 쉼표를 넣지 않는다. 마지막 줄바꿈도 필요하다. delete는 action 한 줄로 다르다.

### V1-T15-C · 공통10000 생성·적재·검증 — S56~58

PowerShell에서 배포 저장소 day-02/data로 이동한다.

~~~powershell
.\generator\generate-products.ps1 -Count 10000 -Seed 9502026
~~~

generated/products-10000.ndjson, products-sample-30.ndjson, generation-summary.json을 확인한다. 생성기는 파일을 만들 뿐 ES에 저장하지 않는다. products의 실제 mapping이 S32 정본과 같고 수업용 데이터임을 확인한다. 기존 다른 데이터가 섞였으면 중단하고 질문한다. 이미 S32에 생성했으므로 PUT을 다시 하지 않는다.

~~~powershell
.\load-products.ps1
~~~

loader 오류가 없는지 확인한 뒤 [공통 요청](practice/lecture-requests.http)의 S58 _count와 분포를 Console에서 실행한다. 빈 기준 index에 고유10000건만 넣었다면 count10000·8category각1250이다. 실제 재고 비율, price stats, created_at min/max를 evidence/day-02-data.md에 기록한다. Console 결과는 JSON이며 슬라이드 막대는 설명용 예다. errors:false만으로 품질이나 총 고유건수가 보증되지 않는다.

### V1-T15-P · 개인1000 생성·적재 착수 — S59

1. data/generation-notes.md가 없으면 만들고 index·건수·seed·후보·범위·확률·결측·검증 질문을 적는다.
2. 배포 pbl-data-template 전체를 개인 data/pbl-data-template로 복사한다. 기존 수정본이 있으면 덮어쓰지 않는다.
3. IndexName/IdField는 S33 개인 mapping과 일치, DocumentCount=1000, SampleCount=30으로 정한다. Vocabularies와 FieldRules를 자기 주제로 고친다.
4. [개인 생성 가이드](practice/DATA_GENERATION_GUIDE.md)의 mapping 검증 포함 명령으로 생성한다. 평면 field와 tags 배열이 기본 지원이다. 대표3건을 고정 사례로 넣는 옵션도 가이드에 있다.
5. 표본의 ID·field/type·포함/제외/경계를 확인한 후 가이드의 loader로 적재한다. 미완료는 현재 단계·오류·다음 요청을 기록하여 S67에서 이어간다.

S60에서 Bulk errors:true이면 실패 item의 error.type/reason을 읽는다. 성공 항목이 남아 있을 수 있으므로 index 전체 삭제를 기본 해결책으로 삼지 않는다. 생성 규칙을 고치고 같은 ID 재전송의 대체 범위를 확인한다. 생성이 실패하면 이전 파일을 새 성공 결과로 착각하여 적재하지 않는다.

## T16 · ingest pipeline·개인 완료·제출 — S61~69

### 개념·예제

pipeline은 색인 과정의 서버 측 변환이다. 정의만 저장한다고 기존 문서가 바뀌지 않는다. 적용 요청/설정 연결이 필요하다. S61의 다양한 변환은 별도 개념 예이고, 이번 공통 실습은 set·rename·remove만 사용한다. raw_price를 숫자로 바꾸는 실습이 아니라 이미 숫자인 price를 유지하고 raw_price를 제거한다.

### V1-T16-C · 정의와 simulate — S62~65

[공통 요청](practice/lecture-requests.http)의 S63 GET으로 product-cleanup 존재를 확인한다. 없을 때만 PUT한다. 다른 정의가 있으면 덮어쓰지 않고 새 이름으로 정의/후속 경로를 함께 바꾼다. products의 default_pipeline은 설정하지 않는다.

~~~json
{
  "description":"상품 문서 정리",
  "processors":[
    {"set":{"field":"in_stock","value":true,"override":false}},
    {"rename":{"field":"brand_name","target_field":"brand"}},
    {"remove":{"field":["temp","raw_price"]}}
  ]
}
~~~

S64 Samsung 입력은 price599000과 brand_nameSamsung을 사용한다. S65 Apple 입력은 price1590000이다. 실제 입력 전체는 파일에 있다. _simulate 뒤 docs[].doc._source를 확인한다.

| 항목 | 예상 |
|---|---|
| brand_name | brand로 이름 변경, 대소문자 유지 |
| in_stock 없음 | true 추가 |
| in_stock false | override:false로 false 유지 |
| temp/raw_price | 제거 |
| name/price | 유지 |
| temp 누락 | ignore_missing을 지정하지 않아 오류 관찰 |

변환 전후와 오류를 evidence/day-02-data.md T16에 적는다. simulate는 저장하지 않아 products count를 늘리지 않는다. 실제 mapping 호환성/저장 성공은 단건 색인 후 GET으로 별도 확인한다.

### V1-T16-P · 필수 완료 우선, 선택 구현 후 — S66~67

1. docs/pipeline-decision.md가 없으면 만들고 적용/미적용/보류, 대상 field, 입출력, 원본 보존, 처리 위치와 이유를 적는다. 반복 여부는 추천 판단 요소이지 기술적 사용 제한은 아니다.
2. S59 개인 생성·색인이 끝나지 않았다면 먼저 완료한다. 현재 mapping/설정/파일을 대조하고 loader를 실행한다. 이미 적재했다면 불필요하게 재실행하지 않고 검증으로 간다.
3. requests.http에 자기 _count, 분류 terms, 숫자 stats를 작성한다. 제공 verify-data-template.http의 library-books/category/status/published_year는 자기 값으로 바꾼다. 날짜가 핵심이면 min/max도 확인한다.
4. 실제 건수·분포·설계와 다른 점을 evidence/day-02-data.md에 기록한다. 생성 건수와 ES count 차이는 기존 문서·중복ID·부분실패를 구분한다.
5. 기본 적재를 마친 사람만 선택 pipeline을 구현한다. 개인 pipeline을 simulate한 뒤 미사용 임시 ID 단건 색인에 pipeline, op_type=create, refresh=wait_for를 지정한다. GET으로 변환된 source를 확인하고 자신이 만든 임시 문서만 삭제한다.

개인 loader에는 pipeline 인수가 없다. loader만 실행하면 pipeline이 연결된다고 생각하지 않는다. 이번 선택 구현은 simulate+단건 실제 연결이며 대량 Bulk pipeline 연결은 필수가 아니다. 공통 products에 임의 적용하지 않는다.

### V1-T16-P · 파일 점검과 제출 — S68~69

[제출 확인표](practice/PRACTICE_GUIDE.md)의 전체 파일을 점검한다. 대표3건 sample-documents.json과 생성기30건 표본은 다르므로 모두 제출한다. 전체 대량 NDJSON은 제외하고 설정·코드·표본·요약으로 재현한다. README에는 실행 순서와 문서 링크를 적는다.

.gitignore가 없으면 만들고 실제 전체 파일 경로와 .env/비밀정보를 제외한다. git status, git diff를 읽고 제출할 파일만 git add로 지정한다. git diff --cached를 확인한 뒤 commit한다.

~~~powershell
git status
git diff
# 제출할 실제 파일들을 git add로 지정한 뒤:
git diff --cached
git commit -m "Day 2 데이터 설계와 적재 검증"
git rev-parse --short HEAD
git branch --show-current
git remote -v
# 본인 저장소의 remote와 현재 branch 확인 후:
git push origin HEAD
~~~

인증값이 들어간 remote URL은 공유하지 않는다. GitHub에서 동일 commit을 확인한다. 로컬 commit 성공과 원격 push 실패는 구분해 기록한다. 생성 건수·실제 ES count·분포·commit을 확인하고 미완료는 오류와 다음 조치를 남긴다.

## 공식 참고

- [Mapping](https://www.elastic.co/docs/manage-data/data-store/mapping)
- [Analyze API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-analyze)
- [Bulk API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-bulk)
- [Ingest pipelines](https://www.elastic.co/docs/manage-data/ingest/transform-enrich/ingest-pipelines)

화면 기록은 학생 본인의 Console 응답/PowerShell 결과를 evidence에 남긴다. PPT의 예시 그림을 본인의 실행 캡처로 제출하지 않는다.
