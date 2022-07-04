data "pass_password" "embed_proxy_secret" {
  name = "website/embed-proxy-secret.txt"
}

resource "local_file" "embed_proxy_secret" {
  sensitive_content = data.pass_password.embed_proxy_secret.password
  filename          = "../../secrets/embed-proxy-secret.txt"
  file_permission   = "0700"
}

data "pass_password" "remote_user_key" {
  name = "website/remote-user.pem"
}

resource "local_file" "remote_user_key" {
  sensitive_content = data.pass_password.remote_user_key.password
  filename          = "../../secrets/remote-user.pem"
  file_permission   = "0700"
}
