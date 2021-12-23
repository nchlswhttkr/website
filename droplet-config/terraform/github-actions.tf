resource "github_actions_secret" "ssh_private_key" {
  repository      = "website"
  secret_name     = "SSH_PRIVATE_KEY"
  plaintext_value = data.pass_password.github_actions_ssh_private_key.password
}

data "pass_password" "github_actions_ssh_private_key" {
  name = "website/github-actions.pem"
}

resource "github_actions_secret" "host_ip" {
  repository      = "website"
  secret_name     = "HOST_IP"
  plaintext_value = digitalocean_droplet.server.ipv4_address
}

resource "github_actions_secret" "aws_access_key_id" {
  repository      = "website"
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = aws_iam_access_key.preview_credentials.id
}

resource "github_actions_secret" "aws_access_key_secret" {
  repository      = "website"
  secret_name     = "AWS_ACCESS_KEY_SECRET"
  plaintext_value = aws_iam_access_key.preview_credentials.secret
}
