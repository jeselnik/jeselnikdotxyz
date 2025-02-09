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

resource "aws_lambda_function" "jeselnik_xyz_backend" {
  function_name = "jeselnik-xyz-backend"
  role          = "arn:aws:iam::862357640489:role/jeselnik-xyz-lambda-role"
  package_type  = "Zip"
  handler       = "bootstrap"
  runtime       = "provided.al2023"
  s3_bucket     = aws_s3_bucket.jeselnik_xyz_lambda.bucket
  s3_key        = "backend.zip"
  timeout       = 10
}
