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

/* keep it simple for now, let's just use a lambda function url
resource "aws_apigatewayv2_api" "jeselnik_xyz_backend" {
  name          = "jeselnik_xyz"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "jeselnik_xyz_lambda_int" {
  api_id           = aws_apigatewayv2_api.jeselnik_xyz_backend.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.jeselnik_xyz_backend.invoke_arn
}

resource "aws_apigatewayv2_route" "jeselnik_xyz_visitorcounter" {
  api_id    = aws_apigatewayv2_api.jeselnik_xyz_backend.id
  route_key = "GET /visit"
  target    = "integrations/${aws_apigatewayv2_integration.jeselnik_xyz_lambda_int.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.jeselnik_xyz_backend.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "jeselnik_api" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.jeselnik_xyz_backend.arn
  principal     = "apigateway.amazonaws.com"
}
*/
