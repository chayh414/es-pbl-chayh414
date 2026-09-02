# 메모장에서 '=' 오른쪽 값과 field 규칙만 자신의 주제에 맞게 바꿉니다.
# 이 파일은 생성기가 읽는 PowerShell 변수 설정입니다. 제공된 형식을 유지하고 값과 규칙만 수정합니다.

$IndexName = 'vintage-items'
$DocumentCount = 5000
$Seed = 20260902
$IdPrefix = 'VI'
$IdField = 'item_id'
$SampleCount = 30

# choice와 tags 규칙이 참조하는 도메인별 후보 목록입니다.
$Vocabularies = [ordered]@{
  categories  = @('아우터', '상의', '하의', '원피스', '신발', '가방')
  brands      = @("Levi's", 'Carhartt', 'SANSAN GEAR', 'Nike', 'Adidas', 'Champion', 'Dickies', 'Wrangler', 'Polo Ralph Lauren', 'Fila')
  brand_tiers = @('일반', '하이엔드스트릿', '디자이너')
  sizes       = @('S', 'M', 'L', 'XL', '28', '30', '32')
  colors      = @('블랙', '화이트', '인디고', '카키', '베이지', '그레이', '네이비', '라임', '브라운')
  eras        = @('80s', '90s', '2000s', '2010s')
  materials   = @('데님', '캔버스', '나일론', '울', '코튼', '폴리에스터', '가죽')
  platforms   = @('번개장터', '당근마켓', '동묘구제', '에이블리빈티지', '민팃')
}

# 문서는 위에서 아래 순서로 만들어집니다.
# template는 앞에서 만든 field와 {{sequence}}을 사용할 수 있습니다.
$FieldRules = @(
  @{ Name = 'item_id'; Kind = 'id'; Digits = 5 }
  @{ Name = 'category'; Kind = 'choice'; Source = 'categories' }
  @{ Name = 'brand'; Kind = 'choice'; Source = 'brands' }
  @{ Name = 'brand_tier'; Kind = 'choice'; Source = 'brand_tiers' }
  @{ Name = 'size'; Kind = 'choice'; Source = 'sizes' }
  @{ Name = 'color'; Kind = 'choice'; Source = 'colors' }
  @{ Name = 'condition'; Kind = 'weighted_choice'; Values = @(
      @{ Value = 'S급'; Weight = 10 },
      @{ Value = 'A급'; Weight = 35 },
      @{ Value = 'B급'; Weight = 35 },
      @{ Value = 'C급'; Weight = 20 }
    ) }
  @{ Name = 'price'; Kind = 'integer'; Min = 5000; Max = 150000 }
  @{ Name = 'original_price'; Kind = 'integer'; Min = 10000; Max = 300000 }
  @{ Name = 'era'; Kind = 'choice'; Source = 'eras' }
  @{ Name = 'material'; Kind = 'choice'; Source = 'materials' }
  @{ Name = 'platform'; Kind = 'choice'; Source = 'platforms' }
  @{ Name = 'seller_rating'; Kind = 'decimal'; Min = 3.0; Max = 5.0; Digits = 1 }
  @{ Name = 'listed_date'; Kind = 'date'; Start = '2025-01-01T00:00:00Z'; End = '2026-08-30T23:59:59Z' }
  @{ Name = 'sold'; Kind = 'boolean'; TrueRatio = 0.30 }
  @{ Name = 'item_name'; Kind = 'template'; Template = '{{brand}} {{era}} {{material}} {{category}}' }
  @{ Name = 'description'; Kind = 'template'; Template = '{{era}} {{material}} 소재, {{condition}} 상태의 {{category}}. {{platform}}에서 판매.' }
  @{ Name = 'defects'; Kind = 'weighted_choice'; Values = @(
      @{ Value = ''; Weight = 60 },
      @{ Value = '무릎 부분 미세한 얼룩 있음'; Weight = 10 },
      @{ Value = '밑단 보풀 약간'; Weight = 10 },
      @{ Value = '소매 끝 마모 있음'; Weight = 10 },
      @{ Value = '단추 하나 헐거움'; Weight = 10 }
    ) }
)
