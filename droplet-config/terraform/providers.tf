terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.56.0"
    }

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.10.1"
    }

    github = {
      source  = "integrations/github"
      version = "4.13.0"
    }
  }

  required_version = ">= 1.0"

  backend "local" {
    path = "/Users/nchlswhttkr/Google Drive/nicholas.cloud/terraform.tfstate"
  }
}

locals {
  aws_tags = {
    Project = "preview.nicholas.cloud"
  }
}

provider "aws" {
  region     = "ap-southeast-2"
  access_key = data.external.aws_access_key_id.result.token
  secret_key = data.external.aws_access_key_secret.result.token
  default_tags {
    tags = local.aws_tags
  }
}

provider "aws" {
  # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cnames-and-https-requirements.html#https-requirements-certificate-issuer
  # To use an ACM certificate with CloudFront, make sure you request (or import) the certificate in the US East (N. Virginia) Region (us-east-1).

  alias = "us_tirefire_1" # https://twitter.com/grepory/status/759204528382210049
  region = "us-east-1"
  access_key = data.external.aws_access_key_id.result.token
  secret_key = data.external.aws_access_key_secret.result.token
  default_tags {
    tags = local.aws_tags
  }
}

data "external" "aws_access_key_id" {
  program = ["bash", "-c", "jq --null-input \".token = \\\"$(pass show website/aws-access-key-id)\\\"\""]
}

data "external" "aws_access_key_secret" {
  program = ["bash", "-c", "jq --null-input \".token = \\\"$(pass show website/aws-access-key-secret)\\\"\""]
}

provider "digitalocean" {
  token = data.external.do_secret_token.result.token
}

data "external" "do_secret_token" {
  program = ["bash", "-c", "jq --null-input \".token = \\\"$(pass show website/digitalocean-api-token)\\\"\""]
}

provider "github" {
  token = data.external.github_secret_token.result.token
}

data "external" "github_secret_token" {
  program = ["bash", "-c", "jq --null-input \".token = \\\"$(pass show website/github-access-token)\\\"\""]
}
