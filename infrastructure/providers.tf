terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.10"
    }

    github = {
      source  = "integrations/github"
      version = "~> 4.13"
    }

    pass = {
      source  = "nicholas.cloud/nchlswhttkr/pass"
      version = "~> 0.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  required_version = "~> 1.2"

  backend "local" {
    path = "/Users/nchlswhttkr/Google Drive/nicholas.cloud/terraform.tfstate"
  }
}

locals {
  aws_tags = {
    Project = "Website Previews"
  }
}

provider "aws" {
  region     = "ap-southeast-2"
  access_key = data.pass_password.aws_access_key_id.password
  secret_key = data.pass_password.aws_access_key_secret.password
  default_tags {
    tags = local.aws_tags
  }
}

provider "aws" {
  # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cnames-and-https-requirements.html#https-requirements-certificate-issuer
  # To use an ACM certificate with CloudFront, make sure you request (or import) the certificate in the US East (N. Virginia) Region (us-east-1).

  alias      = "us_tirefire_1" # https://twitter.com/grepory/status/759204528382210049
  region     = "us-east-1"
  access_key = data.pass_password.aws_access_key_id.password
  secret_key = data.pass_password.aws_access_key_secret.password
  default_tags {
    tags = local.aws_tags
  }
}

data "pass_password" "aws_access_key_id" {
  name = "website/aws-access-key-id"
}

data "pass_password" "aws_access_key_secret" {
  name = "website/aws-access-key-secret"
}

provider "digitalocean" {
  token = data.pass_password.do_secret_token.password
}

data "pass_password" "do_secret_token" {
  name = "website/digitalocean-api-token"
}

provider "github" {
  token = data.pass_password.github_secret_token.password
}

data "pass_password" "github_secret_token" {
  name = "website/github-access-token"
}

provider "pass" {
  store = "/Users/nchlswhttkr/Google Drive/.password-store"
}
