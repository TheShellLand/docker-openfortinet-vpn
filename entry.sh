#!/usr/bin/env bash

# docker entrypoint

cd $(dirname $0)

set -xe

# Create user
useradd -m -s /bin/bash $SSH_USER -u $USERID\
    && usermod -a -G sudo $SSH_USER \
    && echo "$SSH_USER:$SSH_USER_PASS" | chpasswd

# Create vpn config
/bin/bash /create-profile.sh

service ssh start
service openvpn start

# Update ca certs
update-ca-certificates

# Start vpn
openfortivpn -c $CONFIG

exec "$@"
