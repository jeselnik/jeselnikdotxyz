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