# Day 3 — 검색 기능 구현

## 개인 PBL Day 3 산출물 만들기

강사 배포 저장소의 요청 예제와 evidence 양식을 개인 PBL 저장소에 맞게 복사한 뒤, 내 검색 질문과 실제 결과로 작성합니다. 쇼핑몰 예제의 질문·field 이름은 그대로 제출하지 않습니다.

```powershell
$course = "C:\수업\es-5days-pbl-course"
$pbl = "C:\수업\es-pbl-내GitHub아이디"

New-Item -ItemType Directory -Force "$pbl\docs"
New-Item -ItemType Directory -Force "$pbl\evidence"
New-Item -ItemType Directory -Force "$pbl\evidence\day-03-practice"
if (-not (Test-Path "$pbl\requests.http")) { New-Item -ItemType File "$pbl\requests.http" }
if (-not (Test-Path "$pbl\docs\quality-test.md")) {
  Copy-Item "$course\day-03\QUALITY_TEST_TEMPLATE.md" "$pbl\docs\quality-test.md"
}
Copy-Item "$course\day-03\evidence\day-03-search.md" "$pbl\evidence\day-03-search.md"
Copy-Item "$course\day-03\practice\period-*.md" "$pbl\evidence\day-03-practice\"
```

`practice/`의 교시별 문제지 8개가 실제 학생 실습 문제입니다. 각 교시는 제공 코드 실행 1문제, 조건만 보고 공통 API를 직접 구현하는 2문제, 자기 데이터에 적용하는 개인 PBL 2문제로 구성됩니다. 총 40문제의 답은 개인 저장소 `evidence/day-03-practice/`에 복사한 파일에 작성합니다.

공통 `requests/04-search-and-quality.http`는 완성 요청을 확인하거나 막혔을 때 비교하는 참고 코드입니다. 문제지가 아니며 먼저 복사해 답으로 제출하지 않습니다. 개인 검색 요청은 Day 1·2에서 사용한 개인 저장소 루트 `requests.http`에 `V1-T17-P`부터 `V1-T21-P` 구간으로 추가합니다.

`docs/quality-test.md`는 Day 1에 만든 검색 질문·기대 결과 초안을 Day 3 실제 결과로 완성하는 주 문서입니다. `evidence/day-03-search.md`에는 핵심 실행 결과·조건 제거·개선 전후·commit SHA를 요약합니다.

오늘은 검색 질문을 Search API 요청으로 바꾸고, 전문 검색·정확 조건·filter·sort·highlight를 구현합니다.

## 완료 기준

- 검색 질문 3개를 요청 파일로 저장했다.
- filter 2개와 sort 2개를 구현했다.
- 기대 결과와 실제 결과를 비교해 개선 1건을 기록했다.

## 제공 자료

- `practice/`: 교시별 5문제×8개 파일, 총 40문제와 답안란
- `requests/04-search-and-quality.http`: 기본·변형·반례 완성 요청 참고 코드
- `QUALITY_TEST_TEMPLATE.md`: 학생 PBL 검색 품질 점검표
- `evidence/day-03-search.md`: Day 3 최종 산출물 기록 양식

## 개인 저장소 최종 경로

```text
requests.http
docs/quality-test.md
evidence/day-03-search.md
evidence/day-03-practice/period-01-search-api.md ~ period-08-integration.md
```

쇼핑몰 요청의 필드명·검색어·필터 기준을 자신의 주제로 바꾸되, 공통 데이터 스키마에 없는 임의 필드를 추가하지 않습니다.
