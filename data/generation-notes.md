# 데이터 생성 기록

## 1. 생성 설정

- Index: `vintage-items`
- 건수: 5,000건 (권장 5,000~10,000건 범위 내)
- Seed: `20260902`
- IdField / IdPrefix: `item_id` / `VI` (형식 `VI-00001`, 5자리)
- 표본(Sample) 건수: 30건
- 고정 대표 문서: `data/sample-documents.json` 3건을 `-FixedDocumentsFile`로 지정, 생성기의 앞 3개 순번(`VI-00001~00003`)에 그대로 반영됨
- 설정 파일: `data/pbl-data-template/my-data-settings.ps1`
- Mapping 기준: `elasticsearch/index-create.json`

## 2. Field별 후보·범위·비율

| field | Kind | 후보/범위 | 비율·비고 |
|---|---|---|---|
| item_id | id | `VI-00001` ~ | 순번 기반, 5자리 |
| category | choice | 아우터, 상의, 하의, 원피스, 신발, 가방 | 6종 균등 |
| brand | choice | Levi's, Carhartt, SANSAN GEAR, Nike, Adidas, Champion, Dickies, Wrangler, Polo Ralph Lauren, Fila | 10종 균등 |
| brand_tier | choice | 일반, 하이엔드스트릿, 디자이너 | 3종 균등 |
| size | choice | S, M, L, XL, 28, 30, 32 | 7종 균등 |
| color | choice | 블랙, 화이트, 인디고, 카키, 베이지, 그레이, 네이비, 라임, 브라운 | 9종 균등 |
| condition | weighted_choice | S급10% / A급35% / B급35% / C급20% | 실거래 등급 분포 가정 |
| price | integer | 5,000 ~ 150,000 | 균등 난수 |
| original_price | integer | 10,000 ~ 300,000 | 균등 난수 (price와 독립 생성이라 간혹 price보다 낮게 나올 수 있음, 알려진 한계) |
| era | choice | 80s, 90s, 2000s, 2010s | 4종 균등 |
| material | choice | 데님, 캔버스, 나일론, 울, 코튼, 폴리에스터, 가죽 | 7종 균등 |
| platform | choice | 번개장터, 당근마켓, 동묘구제, 에이블리빈티지, 민팃 | 5종 균등 |
| seller_rating | decimal | 3.0 ~ 5.0 (소수 1자리) | 균등 난수 |
| listed_date | date | 2025-01-01 ~ 2026-08-30 | 균등 난수 |
| sold | boolean | TrueRatio 0.30 | 판매완료 30% |
| item_name | template | `{{brand}} {{era}} {{material}} {{category}}` | 결측 없음 |
| description | template | `{{era}} {{material}} 소재, {{condition}} 상태의 {{category}}. {{platform}}에서 판매.` | 결측 없음 |
| defects | weighted_choice | 빈 값60% / 하자 문구 4종 각10% | 하자 있는 상품 40% |

결측(MissingRatio)은 별도 설정하지 않음 — 모든 field가 항상 값을 가짐.

## 3. 로컬 검증 결과

```
LOCAL CHECK PASS: 5000 documents, unique IDs, target index and NDJSON verified. This is not an Elasticsearch indexing result.
```

- ID 중복 없음, NDJSON 5,000 × 2줄 형식 확인, mapping과 field/type 일치 확인 (`validate-data.ps1` 통과)

## 4. Bulk 적재 결과 및 실제 ES 분포

```
PASS: Bulk item errors=false. Actual count=5000, generated=5000.
```

- `GET /vintage-items/_count` → 5000 (기대와 일치)
- category 분포: 아우터808 / 상의850 / 하의860 / 원피스798 / 신발845 / 가방839 (기대: 6종 균등, 각 약 833) — 오차 범위 내 균등
- condition 분포: S급509(10.2%) / A급1691(33.8%) / B급1802(36.0%) / C급998(20.0%) — 설정 비율(10/35/35/20%)과 일치
- era 분포: 80s1233 / 90s1276 / 2000s1251 / 2010s1240 — 기대(4종 균등, 각 약 1250)와 일치
- price: min 5,003 / max 149,945 / avg 78,944 — 설정 범위(5,000~150,000) 내
- seller_rating: min 3.0 / max 5.0 / avg 4.00 — 설정 범위(3.0~5.0) 내
- sold=true: 1,509건 (30.18%) — 설정 TrueRatio(30%)와 일치
- listed_date: 2025-01-01 ~ 2026-08-30 — 설정 범위와 일치
- 대표 문서 3건(`VI-00001~00003`)이 고정 표본 그대로 색인됐는지 재조회로 확인함

## 5. 재현 방법

```powershell
Set-Location "data/pbl-data-template"
.\generator\generate-data.ps1 -SettingsFile .\my-data-settings.ps1 -MappingFile ..\..\elasticsearch\index-create.json -FixedDocumentsFile ..\sample-documents.json
.\validate-data.ps1 -SettingsFile .\my-data-settings.ps1 -MappingFile ..\..\elasticsearch\index-create.json
.\load-data.ps1 -SettingsFile .\my-data-settings.ps1 -MappingFile ..\..\elasticsearch\index-create.json -DockerDirectory "day-01/docker"
```
