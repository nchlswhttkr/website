data "pass_password" "embed_proxy_secret" {
  name = "website/embed-proxy-secret.txt"
}

resource "local_sensitive_file" "embed_proxy_secret" {
  content  = data.pass_password.embed_proxy_secret.password
  filename = "../secrets/embed-proxy-secret.txt"
}

data "pass_password" "remote_user_key" {
  name = "website/remote-user.pem"
}

resource "local_sensitive_file" "remote_user_key" {
  content  = data.pass_password.remote_user_key.password
  filename = "../secrets/remote-user.pem"
}

resource "local_file" "ansible_hosts_inventory" {
  filename = "../deploy/hosts.yml"
  content = yamlencode({
    "all" : {
      "children" : {
        "web" : {
          "hosts" : {
            "${digitalocean_droplet.web.name}" : {
              "ansible_host" : "${digitalocean_droplet.web.ipv4_address}",
              "ansible_user" : "nicholas"
            }
          }
        }
      }
    }
  })
}
