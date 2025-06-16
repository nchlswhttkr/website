FROM ubuntu:jammy

RUN apt-get -y update && apt-get -y install build-essential curl git rsync
RUN curl --fail --location --show-error --silent https://apt.releases.hashicorp.com/gpg | gpg --dearmor --output /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com jammy main" | tee /etc/apt/sources.list.d/hashicorp.list
RUN apt-get -y update && apt-get -y vault

ARG HUGO_VERSION
RUN curl --fail --location --show-error --silent "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" \
    | tar -C "/usr/local/bin/" -xz "hugo"
