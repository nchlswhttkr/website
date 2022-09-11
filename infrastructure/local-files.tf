resource "local_file" "ansible_hosts_inventory" {
  filename = "../deploy/hosts.yml"
  content = yamlencode({
    "all" : {
      "children" : {
        "web" : {
          "hosts" : {
            "${digitalocean_droplet.web.name}" : {
              "ansible_user" : "nicholas"
            }
          }
        }
      }
    }
  })
}
