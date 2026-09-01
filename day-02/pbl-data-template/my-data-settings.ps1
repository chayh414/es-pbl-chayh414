# 메모장에서 '=' 오른쪽 값과 field 규칙만 자신의 주제에 맞게 바꿉니다.
# 이 파일은 생성기가 읽는 PowerShell 변수 설정입니다. 제공된 형식을 유지하고 값과 규칙만 수정합니다.

$IndexName = 'library-books'
$DocumentCount = 1000
$Seed = 20260901
$IdPrefix = 'BOOK'
$IdField = 'book_id'
$SampleCount = 30

# choice와 tags 규칙이 참조하는 도메인별 후보 목록입니다.
$Vocabularies = [ordered]@{
  categories = @('소설', '과학', '역사', '예술')
  adjectives = @('입문', '추천', '주말', '핵심', '새로운')
  tags = @('초보자', '인기', '국내', '전자책', '추천')
}

# 문서는 위에서 아래 순서로 만들어집니다.
# template는 앞에서 만든 field와 {{sequence}}을 사용할 수 있습니다.
$FieldRules = @(
  @{ Name = 'book_id'; Kind = 'id'; Digits = 5 }
  @{ Name = 'category'; Kind = 'choice'; Source = 'categories' }
  @{ Name = 'status'; Kind = 'weighted_choice'; Values = @(
      @{ Value = '대출 가능'; Weight = 70 },
      @{ Value = '대출 중'; Weight = 30 }
    ) }
  @{ Name = 'published_year'; Kind = 'integer'; Min = 2000; Max = 2026 }
  @{ Name = 'loan_count'; Kind = 'integer'; Min = 0; Max = 300 }
  @{ Name = 'rating'; Kind = 'decimal'; Min = 2.0; Max = 5.0; Digits = 1 }
  @{ Name = 'adjective'; Kind = 'choice'; Source = 'adjectives' }
  @{ Name = 'title'; Kind = 'template'; Template = '{{category}} {{adjective}} 도서 {{sequence}}' }
  @{ Name = 'description'; Kind = 'template'; Template = '{{category}} 분류의 학습·독서용 자료입니다.' }
  @{ Name = 'tags'; Kind = 'tags'; Source = 'tags'; MinItems = 1; MaxItems = 3; MissingRatio = 0.03 }
  @{ Name = 'created_at'; Kind = 'date'; Start = '2025-01-01T00:00:00Z'; End = '2026-08-29T23:59:59Z' }
  @{ Name = 'featured'; Kind = 'boolean'; TrueRatio = 0.20 }
)
