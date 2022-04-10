#!/usr/bin/env bash                                                                                                                                                    

# Debian 10
# First enable user namespaces as root user
echo 'kernel.unprivileged_userns_clone=1' > /etc/sysctl.d/00-local-userns.conf
systemctl restart procps

# Use buster-backports on Debian 10 for a newer libseccomp2
echo 'deb http://deb.debian.org/debian buster-backports main' >> /etc/apt/sources.list
echo 'deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_10/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_10/Release.key | sudo apt-key add -
sudo apt-get update
sudo apt-get -y -t buster-backports install libseccomp2
sudo apt-get -y install podman

# Restart dbus for rootless podman
systemctl --user restart dbus
