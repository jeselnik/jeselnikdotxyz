resource "aws_dynamodb_table" "jeselnikxyz-visitor-counter" {
  name         = "jeselnikxyz-visitor-counter"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "CounterID"

  attribute {
    name = "CounterID"
    type = "S"
  }
}

resource "aws_s3_bucket" "jeselnik_xyz_lambda" {
  bucket        = "jeselnik-xyz-lambda"
  force_destroy = true

  tags = {
    Name = "jeselnik.xyz lambda storage"
  }
}
