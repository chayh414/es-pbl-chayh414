# Day 2 — 데이터 모델링과 적재

2026-09-01 배포. 현재 강의의 69장 PPT에 대응하는 학생용 자료다.

[학생교재](student-workbook.md) · [시작·제공 파일 지도](practice/README.md) · [실습·제출 확인표](practice/PRACTICE_GUIDE.md)

[공통 실행 요청](practice/lecture-requests.http) · [개인 데이터 생성 가이드](practice/DATA_GENERATION_GUIDE.md) · [작성 템플릿](practice/templates/README.md)

## 폴더별 역할

- `practice/`: 실습 안내·공통 요청·학생 작성 양식
- `data/`: 쇼핑몰 공통 데이터 생성·적재 파일
- `pbl-data-template/`: 학생 개인 주제의 데이터 생성·검증·적재 도구

## 받는 방법

Day1에 받은 **강사 배포 저장소** 폴더에서 실행한다. 개인 PBL 저장소에서 실행하는 명령이 아니다.

```powershell
git pull --ff-only origin main
```

로컬 수정 때문에 pull이 거부되면 기존 파일을 삭제하거나 강제로 되돌리지 말고 변경 내용을 확인한다. ZIP으로 받을 때도 day-02만 따로 받지 말고 저장소 전체를 받아 day-01/docker와 day-02가 나란히 있게 한다.

## 실행 순서

S32 공통 products 생성 → S33 개인 index 생성 → 분석 → CRUD → S57 공통10000건 생성·적재 → S59 개인1000건 생성·적재 → S67 개인 검증 완료.

공통 실습 후 본인의 주제에 적용한다. 개인 데이터 적재·검증과 pipeline 적용 판단 기록은 필수이고, 개인 pipeline 구현만 선택이다. 짝 검토나 순회 점검을 전제로 하지 않는다.

## 실행 도구와 파일

- .http는 편집기로 열고 요청 하나씩 Kibana Dev Tools Console에 복사한다. 파일 전체를 실행하지 않는다.
- .ps1은 Windows PowerShell에서 실행한다. 실행 정책 오류는 [Day1 Docker 설치 안내](../day-01/docker/DOCKER_INSTALL_GUIDE.md)의 절차를 따른다.
- 공통 데이터는 합성 상품10000건·표본30건·생성 요약을 제공한다. S57에는 생성기를 직접 실행하고 결과를 확인한다.
- 개인 문서는 본인 저장소에 작성한다. 생성된 전체 개인 NDJSON은 제출하지 않고 코드·설정·대표3건·표본30건·요약·실제 검증 결과를 제출한다.
- 실제 .env·비밀번호·인증 헤더는 공유하거나 제출하지 않는다. Day1 환경이 준비된 상태에서 진행한다.

이번 패키지는 현재 69장 수업용 자료다. 이전 실습 파일·Day3~5 자료·강사용 PPT/대본/정답은 포함하지 않는다.
