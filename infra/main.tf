terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.26.0"
    }
  }
}

provider "aws" {
    region = "ap-southeast-2"  
}

resource "aws_s3_bucket" "jeselnikdotxyz" {
    bucket = "jeselnikdotxyz" 
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