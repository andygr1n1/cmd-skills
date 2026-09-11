#!/bin/sh
# Creates /Volumes/minio at boot so rclone (or other tools) can mount without sudo mkdir.
set -eu
MOUNTPOINT="/Volumes/minio"

mkdir -p "$MOUNTPOINT"
# World read/write/execute + sticky bit (like /tmp): any user can use the mount point.
chmod 1777 "$MOUNTPOINT"

