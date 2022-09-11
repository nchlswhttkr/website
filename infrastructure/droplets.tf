resource "digitalocean_ssh_key" "remote_user" {
  name       = "Remote access for machines hosting nicholas.cloud"
  public_key = file("./remote-user.pub")
}

locals {
  digitalocean_region         = "sgp1"
  digitalocean_web_server_tag = "nicholas-dot-cloud-web-servers"
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
  vpc_uuid   = digitalocean_vpc.main.id
  tags       = [local.digitalocean_web_server_tag]

  provisioner "local-exec" {
    command = "./set-up-tailscale-on-droplet.sh '${self.id}'"
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

resource "digitalocean_volume_attachment" "backups" {
  droplet_id = digitalocean_droplet.web.id
  volume_id  = digitalocean_volume.backups.id

  provisioner "local-exec" {
    command = "./mount-digitalocean-volume-to-droplet.sh '${digitalocean_volume.backups.name}' '${digitalocean_droplet.web.name}'"
  }

  # TODO: Create a destroy-time provisioner to shut down the droplet to prevent corruption
}

resource "digitalocean_vpc" "main" {
  name   = "nicholas-dot-cloud"
  region = local.digitalocean_region
}

resource "digitalocean_firewall" "web" {
  name = "web-server-with-tailscale"
  tags = [local.digitalocean_web_server_tag]

  # Allow inbound SSH connections from within the project's VPC
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = [digitalocean_vpc.main.ip_range]
  }

  # Allow inbound HTTPS requests
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow outbound DNS requests (UDP)
  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow outbound DNS requests (TCP)
  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow outbound HTTP requests
  outbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow outbound HTTPS requests
  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow ICMP communication
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
