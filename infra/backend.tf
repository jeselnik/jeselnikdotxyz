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
  role          = aws_iam_role.jeselnik_xyz_lambda_backend.arn
  package_type  = "Zip"
  handler       = "bootstrap"
  runtime       = "provided.al2023"
  architectures = ["arm64"]
  /* omg I didn't realise I had to update the code every deploy, that explains it */
  s3_bucket = aws_s3_bucket.jeselnik_xyz_lambda.bucket
  s3_key    = "backend.zip"
  timeout   = 10
}

resource "aws_lambda_function_url" "visit" {
  function_name      = aws_lambda_function.jeselnik_xyz_backend.function_name
  authorization_type = "NONE"

  cors {
    allow_methods = ["GET", "POST"]
    allow_origins = ["https://eddie.${local.domain}"]
  }
}
