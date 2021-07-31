#!/usr/bin/env sh
set -eux

if [ -z "${UDEV_DEVNODE}" ]; then
    echo 'UDEV_DEVNODE environment variable was not set'
    exit 1
fi

exec ser2net -d -C "${PORT}:${STATE}:${TIMEOUT}:${UDEV_DEVNODE}:${DEVICE_OPTIONS}"
