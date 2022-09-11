#!/bin/bash

# https://docs.digitalocean.com/products/volumes/how-to/mount/
# $1 - The volume name
# $2 - The droplet's name

set -euo pipefail

VOLUME_NAME="$1"
DROPLET_NAME="$2"

echo "Ensuring volume $VOLUME_NAME is mounted/persistent for host $DROPLET_NAME"

# shellcheck disable=SC2087
ssh -T "root@$DROPLET_NAME" <<EOF
    # Create a mount point for your volume:
    mkdir -p /mnt/$VOLUME_NAME

    # Mount your volume at the newly-created mount point:
    mount -o discard,defaults,noatime /dev/disk/by-id/scsi-0DO_Volume_$VOLUME_NAME /mnt/$VOLUME_NAME

    # Change fstab so the volume will be mounted after a reboot
    echo "/dev/disk/by-id/scsi-0DO_Volume_$VOLUME_NAME /mnt/$VOLUME_NAME ext4 defaults,nofail,discard 0 0" | sudo tee -a /etc/fstab
EOF
