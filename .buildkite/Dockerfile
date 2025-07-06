FROM ubuntu:jammy

RUN apt-get -y update && apt-get -y install build-essential curl git jq rsync
RUN curl --fail --location --show-error --silent https://apt.releases.hashicorp.com/gpg | gpg --dearmor --output /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com jammy main" | tee /etc/apt/sources.list.d/hashicorp.list
RUN curl --fail --location --show-error --silent https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg
RUN curl --fail --location --show-error --silent https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list
RUN apt-get -y update && apt-get -y install tailscale
RUN apt-get -y update && apt-get -y install vault

ARG HUGO_VERSION
RUN curl --fail --location --show-error --silent "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" | tar -C "/usr/local/bin/" -xz "hugo"
