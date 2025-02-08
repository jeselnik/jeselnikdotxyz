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
  cloudflare_account_id = "8940638f1a127e97ec240934e06b73e5"
  cloudflare_zone_id    = "8fbf559fa97a8369c33564ddc4bdddf4"
  domain                = "jeselnik.xyz"
}

provider "aws" {
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}
