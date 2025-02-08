terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.86.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }

    porkbun = {
      source  = "kyswtn/porkbun"
      version = "0.1.3"
    }
  }

  backend "s3" {
    bucket         = "jeselnik-tf-state"
    key            = "state/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "jeselnik-tf-lock"
  }

}

locals {
  origin_id = "jeselnik-s3-origin"
  domain    = "jeselnik.xyz"
}

provider "aws" {
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

resource "aws_s3_bucket" "jeselnikdotxyz" {
  bucket        = "jeselnik.xyz"
  force_destroy = true

  tags = {
    Name = "jeselnik.xyz"
  }
}

resource "aws_s3_bucket_public_access_block" "jeselnikdotxyz" {
  bucket                  = aws_s3_bucket.jeselnikdotxyz.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

data "aws_iam_policy_document" "jeselnikdotxyz" {
  statement {
    sid    = "PolicyCloudFrontPrivateContent"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.jeselnikdotxyz.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.jeselnikdotxyz.arn]
    }

  }
}

resource "aws_s3_bucket_policy" "jeselnikdotxyz" {
  bucket = aws_s3_bucket.jeselnikdotxyz.id
  policy = data.aws_iam_policy_document.jeselnikdotxyz.json
}

resource "aws_acm_certificate" "cert" {
  provider                  = aws.us-east-1
  domain_name               = "jeselnik.xyz"
  subject_alternative_names = ["*.jeselnik.xyz"]
  validation_method         = "DNS"
}

resource "aws_cloudfront_origin_access_control" "jeselnikdotxyz" {
  name                              = "jeselnik.xyz"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "jeselnikdotxyz" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases = [
    "jeselnik.xyz",
    "www.jeselnik.xyz"
  ]

  origin {
    domain_name              = aws_s3_bucket.jeselnikdotxyz.bucket_regional_domain_name
    origin_id                = local.origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.jeselnikdotxyz.id
  }

  default_cache_behavior {
    allowed_methods        = ["HEAD", "GET"]
    cached_methods         = ["HEAD", "GET"]
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "redirect-to-https"
    # CachingOptimized
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

}
