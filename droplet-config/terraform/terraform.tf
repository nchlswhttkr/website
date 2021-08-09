terraform {
  required_providers {
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

provider "digitalocean" {
  token = data.external.do_secret_token.result.token
}

data "external" "do_secret_token" {
  program = ["bash", "-c", "echo \"{\\\"token\\\":\\\"$(pass show website/digitalocean-api-token)\\\"}\""]
}

provider "github" {
  token = data.external.github_secret_token.result.token

}

data "external" "github_secret_token" {
  program = ["bash", "-c", "echo \"{\\\"token\\\":\\\"$(pass show website/github-access-token)\\\"}\""]
}

data "digitalocean_ssh_key" "default" {
  name = "nchlswhttkr@Eupho on 2020-04-07"
}

locals {
  digitalocean_region = "sgp1"
}

resource "digitalocean_droplet" "server" {
  image      = "ubuntu-20-04-x64"
  name       = "gandra-dee"
  region     = local.digitalocean_region
  size       = "s-1vcpu-1gb"
  ssh_keys   = [data.digitalocean_ssh_key.default.fingerprint]
  monitoring = true

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

resource "digitalocean_volume_attachment" "server_backups" {
  droplet_id = digitalocean_droplet.server.id
  volume_id  = digitalocean_volume.backups.id
}

resource "github_actions_secret" "host_ip" {
  repository      = "website"
  secret_name     = "HOST_IP"
  plaintext_value = digitalocean_droplet.server.ipv4_address
}

output "droplet_ipv4_address" {
  value = digitalocean_droplet.server.ipv4_address
}

