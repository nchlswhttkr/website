#!/bin/bash

# https://tailscale.com/kb/1077/secure-server-ubuntu-18-04/
# $1 - The droplet's ID 

set -euo pipefail

DROPLET_ID="$1"

DROPLET_IP=$(doctl compute droplet get "$DROPLET_ID" --no-header --format PrivateIPv4)
VPC_UUID=$(doctl compute droplet get "$DROPLET_ID" --no-header --format VPCUUID)

if ! doctl compute droplet list --no-header --format Name | grep --line-regexp "bastion" >/dev/null; then
    echo "Could not find \"bastion\" droplet, provisioning it now..."
    SSH_KEY_FINGERPRINT=$(ssh-keygen -l -E md5 -f - <remote-user.pub | cut -d " " -f 2 | tail -c +5)
    VPC_REGION=$(doctl vpcs get "$VPC_UUID" --no-header --format Region)

    doctl compute droplet create "bastion" \
        --image "ubuntu-22-04-x64" \
        --region "$VPC_REGION" \
        --size "s-1vcpu-512mb-10gb"\
        --ssh-keys "$SSH_KEY_FINGERPRINT" \
        --vpc-uuid "$VPC_UUID" \
        --wait

    # There seems to be flakiness when connecting to new droplets, so delay
    sleep 30
fi

BASTION_ID=$(doctl compute droplet get "bastion" --no-header --format ID)
BASTION_IP=$(doctl compute droplet get "bastion" --no-header --format PublicIPv4)

IDENTITY_FILE=$(mktemp)
SSH_CONFIG=$(mktemp)

pass show website/remote-user.pem >"$IDENTITY_FILE"

cat <<EOF >"$SSH_CONFIG"
IdentityFile "$IDENTITY_FILE"
StrictHostKeyChecking no
Host bastion
Hostname $BASTION_IP
Host droplet
Hostname $DROPLET_IP
EOF

echo "Setting up to host droplet via bastion ($BASTION_ID)"
echo "$SSH_CONFIG" "$IDENTITY_FILE"
TAILSCALE_AUTHENTICATION_KEY=$(pass show website/tailscale-authentication-key)

# Delay to allow cloud-init time to resolve
sleep 120

# shellcheck disable=SC2087
ssh -F "$SSH_CONFIG" -T -J "root@bastion" "root@droplet" <<EOF
    set -euo pipefail

    curl --fail --silent --show-error --location https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg >/usr/share/keyrings/tailscale-archive-keyring.gpg
    curl --fail --silent --show-error --location https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list >/etc/apt/sources.list.d/tailscale.list
    apt-get update
    apt-get install tailscale

    tailscale up --ssh --authkey "$TAILSCALE_AUTHENTICATION_KEY"

    ufw allow in on tailscale0
    ufw allow 41641/udp
    ufw allow ssh
    ufw default deny incoming
    ufw default allow outgoing
    ufw --force enable
    ufw reload

    reboot
EOF

# Testing the SSH connection after allowing time for the host to reboot
sleep 60
DROPLET_NAME=$(doctl compute droplet get "$DROPLET_ID" --no-header --format Name)
ssh -o "StrictHostKeyChecking=accept-new" -T "root@$DROPLET_NAME" sleep 1

doctl compute droplet delete --force "$BASTION_ID"
rm "$SSH_CONFIG" "$IDENTITY_FILE"
