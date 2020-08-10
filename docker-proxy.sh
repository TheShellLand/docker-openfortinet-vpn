#!/bin/bash

# docker image for vpn

cd $(dirname $0)

unset PID

source env.sh

docker volume create openfortinet-vpn-root >/dev/null
docker volume create openfortinet-vpn-ssh >/dev/null
docker volume create openfortinet-vpn-home >/dev/null

while true; do
  docker rm -f openfortinet 2>/dev/null

  docker run --rm --privileged --name openfortinet-vpn -p 2020:22 \
    -e SSH_USER=$SSH_USER \
    -e SSH_USER_PASS=$SSH_USER_PASS \
    -e VPN_USER=$VPN_USER \
    -e VPN_PASS=$VPN_PASS \
    -e VPN_HOST=$VPN_HOST \
    -e VPN_TRUSTED_CERT=$VPN_TRUSTED_CERT \
    -e CONFIG=$CONFIG \
    -v openfortinet-vpn-home:/home \
    -v openfortinet-vpn-root:/root \
    -v openfortinet-vpn-ssh:/etc/ssh \
    -v $(pwd)/ca-certificates:/usr/local/share/ca-certificates \
    docker-openfortinet-vpn

  disconnect=no
  while true; do
    while read log; do
      check="Tunnel is up and running."
      if [[ "$log" == *"$check"* ]]; then
        echo -ne '\rConnected!'
        ssh dockerproxy -TN
        disconnect=yes
      else
        progress
      fi

      if [ $disconnect = yes ]; then
        break
      fi
    done < vpn.log

    if [ $disconnect = yes ]; then
      break
    fi
  done

  PID=$!
  read -p ""
  kill "$PID" || killall docker-proxy.sh
done
