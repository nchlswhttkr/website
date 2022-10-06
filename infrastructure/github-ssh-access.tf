resource "tls_private_key" "ssh_deploy_key" {
  algorithm = "ED25519"
}

resource "pass_password" "github_ssh_key" {
  name     = "website/github-deploy-keys/id_ed25519_website"
  password = tls_private_key.ssh_deploy_key.private_key_openssh
}

resource "github_repository_deploy_key" "terraform_provider_pass" {
  title      = "Allow SSH access to website from host ${digitalocean_droplet.web.name}"
  repository = "website"
  read_only  = true
  key        = tls_private_key.ssh_deploy_key.public_key_openssh
}
