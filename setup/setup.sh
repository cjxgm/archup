#!/usr/bin/bash
set -e

machine_name="$1"
shift
packages="$*"

pacstrap -c /tmp $packages

install -Dm 644 /opt/archup/autologin.conf \
    /tmp/usr/lib/systemd/system/console-getty.service.d/archup-autologin.conf
useradd -R /tmp -md /archup archup
usermod -R /tmp -s /usr/bin/nologin root

exec systemd-nspawn -bD /tmp -M "$machine_name"

