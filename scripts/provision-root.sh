#!/bin/sh
set -euv

### -------------------- Provisioning by root.
cd /root

### Install Applications
export ASSUME_ALWAYS_YES=yes
cat /provision/provision-pkg.list | xargs pkg install


### EDIT loader.conf
cat <<EOS>> /boot/loader.conf
fdescfs_load="YES"
EOS


### EDIT sysctl.conf
cat >> /etc/sysctl.conf << EOS

kern.maxfiles=65536
EOS


### EDIT sshd_config
mv /etc/ssh/sshd_config /etc/ssh/sshd_config.org
cat /etc/ssh/sshd_config.org \
    | sed "s/#UseDNS yes/UseDNS no/" \
    | sed "s/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/" > /etc/ssh/sshd_config
