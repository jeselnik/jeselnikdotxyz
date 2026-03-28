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

resource "aws_apigatewayv2_api" "jeselnik_xyz_api" {
  name          = "jeselnik-xyz-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_origins = ["https://eddie.${local.domain}"]
    allow_headers = ["*"]
  }
}

resource "aws_apigatewayv2_integration" "jeselnik_xyz_lambda" {
  api_id                 = aws_apigatewayv2_api.jeselnik_xyz_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.jeselnik_xyz_backend.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "jeselnik_xyz_default" {
  api_id    = aws_apigatewayv2_api.jeselnik_xyz_api.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.jeselnik_xyz_lambda.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.jeselnik_xyz_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.jeselnik_xyz_backend.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.jeselnik_xyz_api.execution_arn}/*/*"
}
