#!/usr/bin/bash
set -e

machine_name="$1"
extra_flags="$2"
shift 2
packages="$@"

printf "Installing packages...\n"
pacstrap -c /tmp $packages

printf "Setting up environment...\n"
install -Dm 644 /opt/archup/autologin.conf \
    /tmp/usr/lib/systemd/system/console-getty.service.d/archup-autologin.conf
useradd -R /tmp -md /archup archup
usermod -R /tmp -s /usr/bin/nologin root

printf "Starting container...\n"
exec systemd-nspawn -D /tmp -M "$machine_name" $extra_flags

