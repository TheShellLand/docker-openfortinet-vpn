#!/usr/bin/env bash

# docker entrypoint

cd $(dirname $0)

set -e

# Create user
useradd -m -s /bin/bash $SSH_USER -u $USERID\
  && usermod -a -G sudo $SSH_USER \
  && echo "$SSH_USER:$SSH_USER_PASS" | chpasswd

# Copy ssh
if [ -d /ssh ]; then
  rm -rf /home/$SSH_USER/.ssh || :
  cp -r /ssh /home/$SSH_USER/.ssh
  chmod -R o=,g= /home/$SSH_USER/.ssh
  chown -R $SSH_USER:$SSH_USER /home/$SSH_USER
fi

# Install user mods
if [ -f user_mods.sh ]; then
  /bin/bash /user_mods.sh
else
  cp -v /user_mods.sh.example /user_mods.sh
fi

# Create vpn config
/bin/bash /create-profile.sh

# Fix permissions
cp -v /etc/resolv.conf.1 /etc/resolv.conf

set -x

# Start services
service ssh start
service openvpn start

# Update ca certs
update-ca-certificates

# Start vpn
openfortivpn -c $CONFIG

exec "$@"
