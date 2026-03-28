output "api_gateway_endpoint" {
  description = "API Gateway v2 HTTP API endpoint URI"
  value       = aws_apigatewayv2_stage.default.invoke_url
}
