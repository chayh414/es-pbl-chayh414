[CmdletBinding()]
param(
  [string]$DataFile
)

$ErrorActionPreference = 'Stop'
if (-not $DataFile) { $DataFile = Join-Path $PSScriptRoot 'generated\products-10000.ndjson' }
$dockerRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..\day-01\docker') -ErrorAction SilentlyContinue
if (-not $dockerRoot) { throw 'Docker 실습 패키지 경로를 찾지 못했습니다. 강사 배포본의 안내 경로에서 실행합니다.' }
if (-not (Test-Path -LiteralPath $DataFile)) { throw "데이터 파일이 없습니다: $DataFile" }
$DataFile = (Resolve-Path -LiteralPath $DataFile).Path
. (Join-Path $PSScriptRoot '..\pbl-data-template\data-contract.ps1')
$null = Test-BulkFile $DataFile 'products' 10000 (Join-Path $PSScriptRoot 'product-mapping.json') 'product_id'

Push-Location $dockerRoot
try {
  if (-not (Test-Path -LiteralPath '.env')) { throw '.env가 없습니다. Docker 실습환경을 먼저 준비합니다.' }
  $containerId = (docker compose ps -q es01).Trim()
  if (-not $containerId) { throw 'es01 컨테이너가 실행 중이지 않습니다. .\start.ps1 후 다시 실행합니다.' }
  $passwordLine = Get-Content .env | Where-Object { $_ -match '^ELASTIC_PASSWORD=' } | Select-Object -First 1
  if (-not $passwordLine) { throw 'ELASTIC_PASSWORD is missing from .env; check the Day 1 environment.' }
  $password = $passwordLine.Split('=', 2)[1]
  $existing = docker compose exec -T es01 sh -c "curl -fsS --cacert config/certs/ca/ca.crt -u 'elastic:$password' 'https://localhost:9200/products/_mapping'"
  if ($LASTEXITCODE -ne 0) { throw 'products mapping is unavailable. Complete S32 first; no automatic creation.' }
  docker cp $DataFile "${containerId}:/tmp/products-10000.ndjson"
  if ($LASTEXITCODE -ne 0) { throw 'Bulk 데이터 파일을 es01 컨테이너로 복사하지 못했습니다.' }
  $bulk = docker compose exec -T es01 sh -c "curl -s --cacert config/certs/ca/ca.crt -u 'elastic:$password' -H 'Content-Type: application/x-ndjson' -X POST 'https://localhost:9200/_bulk?refresh=wait_for&filter_path=errors,items.*.error' --data-binary @/tmp/products-10000.ndjson"
  if ($LASTEXITCODE -ne 0) { throw "Bulk request failed: $bulk" }
  $bulkResult = ($bulk -join "`n") | ConvertFrom-Json
  if ($null -eq $bulkResult.errors -or $bulkResult.errors -ne $false) { throw "Bulk 적재 실패: $bulk" }
  $count = docker compose exec -T es01 sh -c "curl -s --cacert config/certs/ca/ca.crt -u 'elastic:$password' 'https://localhost:9200/products/_count'"
  if ($LASTEXITCODE -ne 0) { throw "Count request failed: $count" }
  $countResult = ($count -join "`n") | ConvertFrom-Json
  if ($null -eq $countResult.count -or $countResult._shards.failed -gt 0) { throw "Count validation failed: $count" }
  Write-Host "PASS: Bulk item errors=false. Actual count=$($countResult.count). Validate distribution separately."
  if ($countResult.count -ne 10000) { Write-Warning 'Expected 10000 only for the clean common dataset; investigate existing IDs without deleting automatically.' }
} finally {
  Pop-Location
}
