#!/usr/bin/with-contenv bash

MEDIA_GID=${MEDIA_GID:-4000}

groupadd -f -g ${MEDIA_GID} media
usermod -aG ${MEDIA_GID} abc
