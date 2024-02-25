resource "aws_dynamodb_table" "jeselnikxyz-visitor-counter" {
  name           = "jeselnikxyz-visitor-counter"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "VisitorCounter"

  attribute {
    name = "VisitorCounter"
    type = "N"
  }

}
