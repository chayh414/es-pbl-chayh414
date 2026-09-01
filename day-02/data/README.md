# 공통 쇼핑몰 데이터 패키지

공통 products · 10000문서 · Seed9502026 · 공통12field.
공통 실습 기준은 [학생교재 T12/T15](../student-workbook.md)와 [공통 요청](../practice/lecture-requests.http)이다.

## 실행 순서

1. S32: GET /products로 존재를 확인한다. 없을 때만 requests/01-create-products.http의 완전한 PUT을 실행한다. 기존 것은 mapping/settings를 비교하고 다르면 중단한다.
2. S57: PowerShell에서 배포 day-02/data로 이동한다. .\generator\generate-products.ps1 -Count 10000 -Seed 9502026 실행.
3. generated/products-10000.ndjson, products-sample-30.ndjson, generation-summary.json 확인.
4. 기존 다른 데이터가 섞이지 않았고 mapping이 정본과 같을 때만 .\load-products.ps1 실행. S32에 생성한 index에 PUT을 다시 하지 않는다.
5. S58: ../practice/lecture-requests.http의 count·category·재고·가격 stats·날짜 min/max를 실행하고 실제 값을 기록한다.

빈 기준 index에 고유10000건만 넣은 경우 count10000·category8개각1250이다. 재고85%는 확률이며 고정8500건이 아니다. errors:false와 데이터 품질/총 건수 판정은 별개다.
loader는 ../pbl-data-template/data-contract.ps1을 사용하므로 Day2 패키지를 폴더 전체로 받는다.

## 파일 구분

product-mapping.json과 완전한 생성 요청은 같은 계약이다. generation-rules.json은 규칙 설명이며 generator가 읽는 입력 설정이 아니다.
검증 요청은 [practice/lecture-requests.http](../practice/lecture-requests.http)의 S58을 사용한다. 구 검증 파일과 후속 Dashboard 참고 파일은 이번 배포에 포함하지 않는다.
공통 생성기 Count/Index를 바꾸면 결과 파일명도 해당 값으로 바뀐다. 공통 loader는 수업 기준 products10000만 받는다.
