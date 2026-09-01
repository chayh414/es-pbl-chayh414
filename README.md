# Elasticsearch 5일 PBL 학생 배포 자료

이 저장소에는 오늘 수업에 필요한 학생용 자료만 순차적으로 추가됩니다. 강사용 PPT 대본·정답·평가 메모는 포함하지 않습니다.

## 수업 전 준비

1. Docker Desktop 설치 안내를 확인합니다.
2. 저장소를 내려받습니다.
3. 1일 차 Docker 폴더에서 `pull-images.ps1`을 실행합니다. 이미지 다운로드는 수업 전날 실행을 권장합니다.

## 일별 자료

현재 공개: [Day 1](day-01/README.md), **[Day 2](day-02/README.md)**. Day3~5는 아래 예정에 따라 순차 공개한다.

Day1에 clone한 배포 저장소에서 `git pull --ff-only origin main`을 실행하면 Day2가 추가된다. 개인 PBL 저장소와 구분한다.

Day 2 실습을 마친 뒤 [Day 2 데이터 준비 결과 양식](evidence/day-02-data.md)을 개인 PBL 저장소의 같은 경로에 복사해 실제 결과를 작성하고 commit·push한다.

| 폴더 | 공개 시점 | 내용 |
|---|---|---|
| `day-01/` | 1일 차 전날 | 과정·PBL 시작, Docker, 첫 REST 요청 |
| `day-02/` | 2일 차 전날 | mapping, 생성기, Bulk 적재 |
| `day-03/` | 3일 차 전날 | 검색·filter·정렬·품질 테스트 |
| `day-04/` | 4일 차 전날 | 집계·Discover·Lens·Dashboard |
| `day-05/` | 5일 차 전날 | ES\|QL, AI Search 이론, 제출·발표 |

## 공개 저장소 주의

- 실제 `.env`, 비밀번호, token, 개인정보를 commit하지 않습니다.
- 개인 PBL 저장소는 Public을 기본으로 제출합니다. 공개가 어려운 경우에만 강사에게 먼저 알리고 Private 저장소에 강사를 초대합니다.
