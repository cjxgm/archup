#!/usr/bin/bash
set -e

machine_name="$1"
extra_flags="$2"
shift 2
packages="$@"

printf "Installing packages...\n"
pacstrap -c /tmp $packages

printf "Setting up environment...\n"
printf "  Creating user archup...\n"
rm /tmp/etc/default/useradd
useradd -R /tmp -md /archup -U archup
printf "  Setting up auto login for archup...\n"
install -Dm 644 /opt/archup/autologin.conf \
    /tmp/usr/lib/systemd/system/console-getty.service.d/archup-autologin.conf
printf "  Disabling root login...\n"
usermod -R /tmp -s /usr/bin/nologin root

printf "Starting container...\n"
exec systemd-nspawn -D /tmp -M "$machine_name" $extra_flags

