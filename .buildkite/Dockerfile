FROM ubuntu:jammy

RUN apt-get update && apt-get install -y curl git

ARG HUGO_VERSION
RUN curl --silent --fail --show-error --location "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" \
    | tar -C "/usr/local/bin/" -xz "hugo"
