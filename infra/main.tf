terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.26.0"
    }
  }

  backend "s3" {
    bucket = "jeselnik-tf-state"
    key = "state/terraform.tfstate"
    region = "ap-southeast-2"
    dynamodb_table = "jeselnik-tf-lock"
  }

}

locals {
  origin_id = "jeselnik-s3-origin"
}

provider "aws" {
  region = "ap-southeast-2"  
}

resource "aws_s3_bucket" "jeselnikdotxyz" {
  bucket = "jeselnik.xyz" 
  force_destroy = true

  tags = {
    Name = "jeselnik.xyz"
  }
}

resource "aws_s3_bucket_website_configuration" "jeselnikdotxyz" {
  bucket = aws_s3_bucket.jeselnikdotxyz.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "jeselnikdotxyz" {
  bucket = aws_s3_bucket.jeselnikdotxyz.id
  block_public_acls = false
  block_public_policy = false
}

data "aws_iam_policy_document" "jeselnikdotxyz" {
  statement {
    sid = "PublicReadGetObject"
    effect = "Allow"

    principals {
      type = "*"
      identifiers = [ "*" ]
    }

    actions = [ "s3:GetObject" ]
    resources = [ "${aws_s3_bucket.jeselnikdotxyz.arn}/*" ]
  } 
}

resource "aws_s3_bucket_policy" "jeselnikdotxyz" {
  bucket = aws_s3_bucket.jeselnikdotxyz.id
  policy = data.aws_iam_policy_document.jeselnikdotxyz.json
}

resource "aws_cloudfront_origin_access_control" "jeselnikdotxyz" {
  name = "jeselnik.xyz"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

resource "aws_cloudfront_distribution" "jeselnikdotxyz" {
  enabled = true
  is_ipv6_enabled = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.jeselnikdotxyz.bucket_regional_domain_name
    origin_id = local.origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.jeselnikdotxyz.id
  }

  default_cache_behavior {
    allowed_methods = [ "HEAD", "GET" ]
    cached_methods = [ "HEAD", "GET" ]
    target_origin_id = local.origin_id
    viewer_protocol_policy = "redirect-to-https"
    # CachingOptimized
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  viewer_certificate {
    cloudfront_default_certificate = true 
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
}