[CmdletBinding()]
param(
  [int]$Count = 10000,
  [int]$Seed = 9502026,
  [string]$Index = 'products',
  [string]$OutputDir
)

$ErrorActionPreference = 'Stop'
if (-not $OutputDir) {
  $OutputDir = Join-Path (Split-Path -Parent $PSScriptRoot) 'generated'
}
if ($Count -lt 30) { throw 'Count는 샘플 데이터 생성을 위해 30 이상이어야 합니다.' }

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$null = New-Item -ItemType Directory -Force -Path $OutputDir
if ($Index -notmatch '^[a-z0-9][a-z0-9_-]*$') { throw 'Invalid classroom index name.' }
$bulkPath = Join-Path $OutputDir ("{0}-{1}.ndjson" -f $Index,$Count)
$samplePath = Join-Path $OutputDir ("{0}-sample-30.ndjson" -f $Index)
$summaryPath = Join-Path $OutputDir 'generation-summary.json'
$rng = [System.Random]::new($Seed)
$start = [datetime]::Parse('2025-08-27T00:00:00Z').ToUniversalTime()
$end = [datetime]::Parse('2026-08-26T23:59:59Z').ToUniversalTime()

$catalog = [ordered]@{
  '전자기기' = @{ brands = @('SoundLab','NeoTech','PixelWorks','Auralis','MobiCore'); items = @('무선 이어폰','노이즈 캔슬링 헤드폰','블루투스 스피커','기계식 키보드','휴대용 충전기'); uses = @('통학','재택 학습','음악 감상','온라인 회의','여행'); tags = @('무선','블루투스','USB-C','휴대용','노이즈 캔슬링'); min = 19000; max = 429000 }
  '생활' = @{ brands = @('HomeNest','DailyForm','CleanMate','LumiHome','SimpleDay'); items = @('스테인리스 텀블러','무선 청소기','수납 정리함','LED 스탠드','주방 저울'); uses = @('자취','신혼','공부방','주방 정리','선물'); tags = @('실용','정리','친환경','미니멀','선물'); min = 8900; max = 279000 }
  '패션' = @{ brands = @('UrbanStep','Morrow','Dayfit','PlainMood','LoopWear'); items = @('오버핏 후드','데일리 백팩','러닝화','코튼 셔츠','니트 가디건'); uses = @('캠퍼스','출근','주말 외출','운동','여행'); tags = @('데일리','베이직','가벼운 착용감','사계절','선물'); min = 24000; max = 198000 }
  '스포츠' = @{ brands = @('PeakRun','ActiveLine','TrailMove','FlexPro','WaveFit'); items = @('요가 매트','러닝 벨트','덤벨 세트','등산 스틱','물병'); uses = @('홈트','러닝','등산','헬스장','주말 운동'); tags = @('운동','경량','내구성','초보자','야외'); min = 12000; max = 249000 }
  '도서' = @{ brands = @('한빛책방','문장숲','지식마루','오늘의책','북웨이브'); items = @('데이터 분석 입문','여행 에세이','자기계발 도서','소설','요리 레시피북'); uses = @('학습','휴식','취미','선물','독서 모임'); tags = @('베스트셀러','입문','추천','국내도서','ebook'); min = 9800; max = 48000 }
  '뷰티' = @{ brands = @('PureBloom','GlowLab','SkinNote','MildLeaf','DewyDay'); items = @('수분 크림','선크림','클렌징 폼','립 틴트','세럼'); uses = @('데일리 케어','여행','선물','민감 피부','메이크업'); tags = @('보습','저자극','비건','휴대용','기초케어'); min = 7900; max = 89000 }
  '식품' = @{ brands = @('온담','그레인픽','한끼연구소','FreshTable','달콤상점'); items = @('드립백 커피','견과류 세트','그래놀라','무설탕 간식','차 선물세트'); uses = @('아침','사무실','간식','선물','캠핑'); tags = @('건강','간편식','국산','무설탕','선물'); min = 5900; max = 74000 }
  '반려동물' = @{ brands = @('PawStory','멍냥생활','PetBalance','HappyTail','냥이마켓'); items = @('반려견 사료','고양이 모래','자동 급수기','산책 리드줄','장난감 세트'); uses = @('실내 생활','산책','건강 관리','선물','초보 보호자'); tags = @('반려견','반려묘','안전','내구성','정기구매'); min = 6900; max = 219000 }
}

function Pick([object[]]$Values) { return $Values[$rng.Next($Values.Count)] }
function To-Iso([datetime]$Value) { return $Value.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') }
function Write-BulkPair($Writer, $Document) {
  $action = [ordered]@{ index = [ordered]@{ _index = $Index; _id = $Document.product_id } }
  $Writer.WriteLine(($action | ConvertTo-Json -Compress))
  $Writer.WriteLine(($Document | ConvertTo-Json -Compress -Depth 4))
}

$categories = @($catalog.Keys)
$categoryCounts = [ordered]@{}
foreach ($category in $categories) { $categoryCounts[$category] = 0 }
$bulkWriter = [System.IO.StreamWriter]::new($bulkPath, $false, $utf8NoBom)
$sampleWriter = [System.IO.StreamWriter]::new($samplePath, $false, $utf8NoBom)
try {
  for ($number = 1; $number -le $Count; $number++) {
    $category = $categories[($number - 1) % $categories.Count]
    $spec = $catalog[$category]
    # Whole seconds avoid .NET Framework vs modern .NET fractional rounding differences.
    $created = $start.AddSeconds([math]::Floor($rng.NextDouble() * ($end - $start).TotalSeconds))
    $priceMin = [int]([math]::Floor($spec.min / 100) * 100)
    $priceMax = [int]([math]::Floor($spec.max / 100) * 100)
    $tags = @($spec.tags | Sort-Object { $rng.Next() } | Select-Object -First (2 + $rng.Next(3)))
    $document = [ordered]@{
      product_id = ('P-{0:d5}' -f $number)
      name = ('{0} {1} {2}' -f (Pick $spec.brands), (Pick @('프리미엄','실속형','컴팩트','데일리','스마트')), (Pick $spec.items))
      description = ('{0}에 잘 어울리는 {1} 상품입니다. 사용 편의성과 실용성을 함께 고려했습니다.' -f (Pick $spec.uses), $category)
      category = $category
      brand = $null
      price = $rng.Next($priceMin / 100, ($priceMax / 100) + 1) * 100
      rating = [math]::Round((2.0 + $rng.NextDouble() * 3.0), 1)
      review_count = [int](-[math]::Log(1.0 - $rng.NextDouble()) * 180) + $rng.Next(30)
      in_stock = ($rng.NextDouble() -lt 0.85)
      tags = $tags
      created_at = To-Iso $created
      updated_at = To-Iso ($created.AddDays($rng.Next(31)))
    }
    $document.brand = (($document.name -split ' ')[0])
    if ($rng.NextDouble() -lt 0.03) { $document.Remove('tags') }
    if ($rng.NextDouble() -lt 0.05) { $document.Remove('updated_at') }
    Write-BulkPair $bulkWriter $document
    if ($number -le 30) { Write-BulkPair $sampleWriter $document }
    $categoryCounts[$category]++
  }
} finally {
  $bulkWriter.Dispose()
  $sampleWriter.Dispose()
}

$summary = [ordered]@{
  index = $Index
  document_count = $Count
  seed = $Seed
  files = [ordered]@{ bulk = (Split-Path -Leaf $bulkPath); sample = (Split-Path -Leaf $samplePath) }
  category_counts = $categoryCounts
  generated_at = 'deterministic-from-seed'
  optional_field_exceptions = [ordered]@{ tags_missing_ratio = 0.03; updated_at_missing_ratio = 0.05 }
}
[System.IO.File]::WriteAllText($summaryPath, (($summary | ConvertTo-Json -Depth 5) + [Environment]::NewLine), $utf8NoBom)
$summary | ConvertTo-Json -Depth 5
