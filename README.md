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

You'll need a few tools installed and set up beforehand.

-   Google Drive for credentials, Terraform state and backups of assorted files
-   [Terraform](https://www.terraform.io/downloads.html)
-   [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html)
-   [Pass](https://www.passwordstore.org/)

```sh
git clone https://github.com/nchlswhttkr/website.git
cd website
make infra
make server
```

If a new droplet is created, you can restore the most recent backup.

```sh
./scripts/mount-digitalocean-backups-volume.sh
make backup-restore
```
