#!/usr/bin/env bash

# test docker image

cd $(dirname $0)

if [ -f env.sh ]; then
  source env.sh
else
  echo "env.sh not found"
  exit 1
fi

set -ex

docker rm -f openfortinet-vpn || :
docker run --rm --privileged -it --name openfortinet-vpn \
  -e SSH_USER=$SSH_USER \
  -e SSH_USER_PASS=$SSH_USER_PASS \
  -e VPN_USER=$VPN_USER \
  -e VPN_PASS=$VPN_PASS \
  -e VPN_HOST=$VPN_HOST \
  -e VPN_TRUSTED_CERT=$VPN_TRUSTED_CERT \
  -e CONFIG=$CONFIG \
  -v $(pwd)/config/resolv.conf.1:/etc/resolv.conf \
  -v $(pwd)/ca-certificates:/usr/local/share/ca-certificates \
  docker-openfortinet-vpn