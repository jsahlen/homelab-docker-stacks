#!/usr/bin/with-contenv bash

DEVICE_GID=$(stat -c '%g' /dev/dri/renderD128)

# already a member? nothing to do
if id -G abc | grep -qw "$DEVICE_GID"; then
    exit 0
fi

# reuse an existing group at that GID if one exists, otherwise make one
GROUP_NAME=$(getent group "$DEVICE_GID" | cut -d: -f1)
if [ -z "$GROUP_NAME" ]; then
    groupadd -g "$DEVICE_GID" videogrp
    GROUP_NAME=videogrp
fi

usermod -aG "$GROUP_NAME" abc
