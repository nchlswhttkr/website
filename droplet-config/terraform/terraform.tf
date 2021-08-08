terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.9.0"
    }
  }

  required_version = ">= 0.15"

  backend "local" {
    path = "/Users/nchlswhttkr/Google Drive/nicholas.cloud/terraform.tfstate"
  }
}

provider "digitalocean" {
  token = data.external.do_secret_token.result.token
}

data "external" "do_secret_token" {
  program = ["bash", "-c", "echo \"{\\\"token\\\":\\\"$(pass show website/digitalocean-api-token)\\\"}\""]
}

variable "droplet_name" {
  type = string
}

data "digitalocean_ssh_key" "default" {
  name = "nchlswhttkr@Eupho on 2020-04-07"
}

locals {
  digitalocean_region = "sgp1"
}

resource "digitalocean_droplet" "website" {
  image      = "ubuntu-20-04-x64"
  name       = var.droplet_name
  region     = local.digitalocean_region
  size       = "s-1vcpu-1gb"
  ssh_keys   = [data.digitalocean_ssh_key.default.fingerprint]
  monitoring = true
  volume_ids = [digitalocean_volume.backups.id]

  lifecycle {
    ignore_changes = [monitoring]
  }
}

resource "digitalocean_volume" "backups" {
  region                  = local.digitalocean_region
  name                    = "backups"
  size                    = 1
  initial_filesystem_type = "ext4"

  lifecycle {
    prevent_destroy = true
  }
}

output "droplet_ipv4_address" {
  value = digitalocean_droplet.website.ipv4_address
}

