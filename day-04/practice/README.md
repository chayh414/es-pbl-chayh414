# Day 4 교시별 Dashboard 연습문제

Day 4 연습문제는 Kibana 화면을 그대로 따라 한 뒤 끝내는 방식이 아닙니다. 공통 `products`로 기능을 확인하고, 설정 하나를 바꾸고, 결과를 검증한 다음, 같은 판단 절차를 자신의 PBL 주제에 적용합니다.

버튼 위치나 입력값이 기억나지 않으면 상위 폴더의 [`KIBANA_9_5_STEP_BY_STEP.md`](../KIBANA_9_5_STEP_BY_STEP.md)를 엽니다. 그래프 완성 모습만 빠르게 비교하려면 [`CHART_GALLERY.md`](../CHART_GALLERY.md)를 사용합니다.

## 문제 구성

각 교시는 다음 역할을 조합한 5문제로 구성됩니다. 교시에서 새로 배워야 하는 차트가 여러 개이면 공통 재현 문제가 둘 이상 포함될 수 있습니다.

1. 공통 재현: 강의에서 배운 기능을 `products`로 다시 만든다.
2. 공통 변형: field·정렬·구간·표현 중 한 가지를 바꾸고 차이를 설명한다.
3. 진단·검증: 잘못된 시간·filter·field·집계·제목을 찾아 복구한다.
4. 개인 PBL: 자신의 사용자·질문·데이터에 적용한다.
5. 선택 도전: 시간이 남을 때만 수행한다. 필수 문제보다 우선하지 않는다.

필수 문제는 32개, 선택 도전은 8개이며 전체 40문제입니다.

## 문제 목록

| 교시 | 주제 | 필수 문제 | 선택 도전 | 문제지 |
|---:|---|---:|---:|---|
| 1 | Data View·Discover·KQL·데이터 준비 상태 | 4 | 1 | [period-01-data-readiness.md](period-01-data-readiness.md) |
| 2 | Metric·Bar·Top values | 4 | 1 | [period-02-metric-bar.md](period-02-metric-bar.md) |
| 3 | Table·Count·Average·정렬 | 4 | 1 | [period-03-table.md](period-03-table.md) |
| 4 | 가격 분포·재고 비율·등록 시점 | 4 | 1 | [period-04-distribution.md](period-04-distribution.md) |
| 5 | Dashboard 조립·Control·Filter·KQL | 4 | 1 | [period-05-dashboard-interaction.md](period-05-dashboard-interaction.md) |
| 6 | 개인 질문·필요 field·데이터 보강 | 4 | 1 | [period-06-personal-plan.md](period-06-personal-plan.md) |
| 7 | 개인 목적형 Dashboard 제작 | 4 | 1 | [period-07-personal-build.md](period-07-personal-build.md) |
| 8 | 사용 시나리오·교차 검증·개선·제출 | 4 | 1 | [period-08-validation.md](period-08-validation.md) |

답을 쓰는 방식은 [ANSWER_WRITING_GUIDE.md](ANSWER_WRITING_GUIDE.md)를 먼저 읽습니다.

## Kibana 9.5.0 공통 주의

- Donut은 차트 선택기의 별도 유형이 아닙니다. `Pie → Style → Appearance → Donut hole`로 만듭니다.
- 월 단위 Line은 Date histogram의 `Minimum interval`에 `1M`을 입력합니다.
- 정확한 가격 구간은 `Create custom ranges`로 만듭니다.
- 패널 제목은 Dashboard 편집 모드에서 패널 `Settings`로 바꿉니다.
- `Inspect`는 편집 모드의 해당 패널 `Panel menu`에 있습니다.
- PDF가 없어도 정상입니다. 화면 캡처가 기본 제출 근거입니다.

## 개인 저장소로 복사

PowerShell에서 자신의 실제 경로로 바꿔 실행합니다.

```powershell
$course = "C:\수업\es-5days-pbl-course"
$pbl = "C:\수업\es-pbl-내GitHub아이디"

New-Item -ItemType Directory -Force "$pbl\evidence\day-04-practice"
Copy-Item "$course\day-04\practice\period-*.md" "$pbl\evidence\day-04-practice\"
Copy-Item "$course\day-04\practice\ANSWER_WRITING_GUIDE.md" "$pbl\evidence\day-04-practice\"
```

복사한 `evidence/day-04-practice/period-*.md` 파일에 직접 답을 씁니다. 배포 저장소의 원본에는 답을 쓰지 않습니다.

## 공통 기준 상태

- Data View: 강사가 지정한 `products` Data View
- 시간 field: `created_at`
- 전체 범위를 포함하는 절대 시간
- 전체 문서 수: 20,000
- `in_stock : false`: 3,001
- category: 8개, 각 2,500
- KQL: 비어 있음
- filter pill: 없음
- category Control: `Any`

수치가 다르면 답을 맞추기 위해 숫자를 고치지 않습니다. 현재 화면의 실제 수치와 시간·Data View·KQL·filter/control 상태를 기록하고 원인을 찾습니다.

## 완료 기준

- 문제의 요구사항을 실제 Kibana에서 수행했다.
- 누른 메뉴를 전부 나열하기보다 핵심 설정을 기록했다.
- 예상값을 복사하지 않고 실제 결과를 기록했다.
- 결과가 맞는 이유 또는 다른 이유를 한 문장으로 설명했다.
- 문제에서 요구한 화면 캡처 파일명을 기록했다.
- 개인 문제는 자신의 실제 index와 field를 사용하거나, 부족한 데이터를 구체적으로 설계했다.

## 상태 표시

- GREEN: 필수 문제와 검증 근거 완료
- YELLOW: 화면은 만들었지만 수치·field·시간·저장·검증 중 하나가 미완료
- RED: 다음 교시를 진행할 Data View 또는 Dashboard가 준비되지 않음

말로 발표하지 않아도 됩니다. YELLOW/RED일 때는 문제 번호, 현재 화면 캡처, 마지막으로 성공한 단계만 강사에게 보여 줍니다.
