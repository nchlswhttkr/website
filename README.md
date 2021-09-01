# website [![Build status](https://badge.buildkite.com/5ec9e994380bc49e3c9bd5e6be0341ca874a272b0e61f900f8.svg?branch=main)](https://buildkite.com/nchlswhttkr/website)

Source code for [my website](https://nicholas.cloud/). I also run [several workers](https://github.com/nchlswhttkr/workers/).

See the [main site](https://nicholas.cloud/site/#acknowledgements) for acknowledgements and attributions.

### Build

To make changes and preview this website locally, you only need to have [Hugo](https://gohugo.io/) installed.

```sh
git clone https://github.com/nchlswhttkr/website.git
cd website
hugo serve
```

### Deploy

This is only intended for my use, as it expects a number of hardcoded filepaths/secrets/names.

You'll need a few tools installed, and a couple of secrets from your password store.

-   [Terraform](https://www.terraform.io/downloads.html) (with Google Drive installed to serve as a backend)
-   [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html)
-   [Pass](https://www.passwordstore.org/) (with accompanying secrets)

```sh
pass list website # verify secrets are available
git clone https://github.com/nchlswhttkr/website.git
cd website
make infra
make server
./scripts/mount-digitalocean-backups-volume.sh # if new droplet created
make backup-restore # if backup exists
```
