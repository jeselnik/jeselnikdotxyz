resource "aws_dynamodb_table" "jeselnikxyz-visitor-counter" {
  name         = "jeselnikxyz-visitor-counter"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "VisitorCounter"

  attribute {
    name = "VisitorCounter"
    type = "N"
  }

}
