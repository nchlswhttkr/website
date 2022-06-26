resource "digitalocean_ssh_key" "remote_user" {
  name       = "Remote access for machines hosting nicholas.cloud"
  public_key = file("./remote-user.pub")
}

locals {
  digitalocean_region = "sgp1"
}

resource "digitalocean_project" "nicholas_dot_cloud" {
  name        = "nicholas.cloud"
  description = "Resources hosting nicholas.cloud"
  environment = "Production"
}

resource "digitalocean_project_resources" "nicholas_dot_cloud" {
  project   = digitalocean_project.nicholas_dot_cloud.id
  resources = [digitalocean_droplet.server.urn]
}

resource "digitalocean_droplet" "server" {
  image      = "ubuntu-20-04-x64"
  name       = "gandra-dee"
  region     = local.digitalocean_region
  size       = "s-1vcpu-1gb"
  ssh_keys   = [digitalocean_ssh_key.remote_user.fingerprint]
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

output "droplet_ipv4_address" {
  value = digitalocean_droplet.server.ipv4_address
}
