#!/usr/bin/env sh
set -eux

env_name=$(env | grep -o -e '^UDEV_DEVNODE\(_[A-F0-9]\{6\}\)\?' | head -n1)

if [ -z "${env_name}" ]; then
    echo 'No UDEV_DEVNODE or UDEV_DEVNODE_{instance id} environment variable was present'
    exit 1
fi

UDEV_DEVNODE="$(printenv "${env_name}")"

echo "Using device: ${env_name}=${UDEV_DEVNODE}"

exec ser2net -d -C "${PORT}:${STATE}:${TIMEOUT}:${UDEV_DEVNODE}:${DEVICE_OPTIONS}"
