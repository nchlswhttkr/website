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
  resources = [digitalocean_droplet.web.urn]
}

resource "digitalocean_droplet" "web" {
  image      = "ubuntu-22-04-x64"
  name       = "gandra-dee"
  region     = local.digitalocean_region
  size       = "s-1vcpu-1gb"
  ssh_keys   = [digitalocean_ssh_key.remote_user.fingerprint]
  monitoring = true
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

resource "digitalocean_volume_attachment" "backups" {
  droplet_id = digitalocean_droplet.web.id
  volume_id  = digitalocean_volume.backups.id

  depends_on = [
    local_sensitive_file.remote_user_key # needed for SSH access
  ]

  provisioner "local-exec" {
    command = "./mount-digitalocean-volume-to-droplet.sh '${digitalocean_volume.backups.name}' '${digitalocean_droplet.web.ipv4_address}'"
  }

  # TODO: Create a destroy-time provisioner to shut down the droplet to prevent corruption
}
