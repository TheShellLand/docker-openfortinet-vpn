#!/usr/bin/env bash

# test docker image

cd $(dirname $0)

if [ -f env.sh ]; then
  source env.sh
else
  echo "env.sh not found"
  exit 1
fi

set -e

docker volume create openfortinet-vpn-root
docker volume create openfortinet-vpn-ssh
docker volume create openfortinet-vpn-home

docker pull theshellland/docker-openfortinet-vpn || :
docker rm -f openfortinet-vpn || :
docker run --rm --privileged -it --name openfortinet-vpn \
  -p 127.0.0.1:2020:22 \
  -e SSH_USER=$SSH_USER \
  -e SSH_USER_PASS=$SSH_USER_PASS \
  -e USERID=$USERID \
  -e VPN_USER=$VPN_USER \
  -e VPN_PASS=$VPN_PASS \
  -e VPN_HOST=$VPN_HOST \
  -e VPN_TRUSTED_CERT=$VPN_TRUSTED_CERT \
  -e CONFIG=$CONFIG \
  -v openfortinet-vpn-home:/home \
  -v openfortinet-vpn-root:/root \
  -v openfortinet-vpn-ssh:/etc/ssh \
  -v $HOME/.ssh:/home/$SSH_USER/.ssh:ro \
  -v $(pwd)/config/resolv.conf.1:/etc/resolv.conf.1 \
  -v $(pwd)/ca-certificates:/usr/local/share/ca-certificates \
  theshellland/docker-openfortinet-vpn "$@"
