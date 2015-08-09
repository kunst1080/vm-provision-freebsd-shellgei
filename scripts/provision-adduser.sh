#!/bin/sh
set -euv

### -------------------- Add default user.
cd /root

USER=$1


### ADD user
echo 'usptomo' | pw useradd -n $USER -G "operator, wheel" -h 0 -m -s /bin/tcsh


### ADD sudoers
cat <<EOS > /usr/local/etc/sudoers.d/${USER}
${USER} ALL=(ALL) NOPASSWD: ALL
EOS
chmod 440 /usr/local/etc/sudoers.d/${USER}


### SETUP ssh keys
mkdir -p /home/$USER/.ssh
mv /provision/authorized_keys /home/$USER/.ssh/
chown -R $USER:$USER /home/$USER/.ssh
chmod 700 /home/$USER/.ssh
chmod 600 /home/$USER/.ssh/*
