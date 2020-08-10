#!/usr/bin/env bash

# docker entrypoint

cd $(dirname $0)

set -ex

# Create user
useradd -m -s /bin/bash $SSH_USER \
    && usermod -a -G sudo $SSH_USER \
    && echo "$SSH_USER:$SSH_USER_PASS" | chpasswd \
    && mkdir -p /home/$SSH_USER/.ssh \
    && chown -R $SSH_USER:$SSH_USER /home/$SSH_USER

# Create vpn config
/bin/bash /create-profile.sh

service ssh start
service openvpn start

# Update ca certs
update-ca-certificates

# Start vpn
#openfortivpn -v -c /etc/openfortivpn/config/vpn.conf
openfortivpn -c $CONFIG

exec "$@"
