#!/bin/bash

# docker image for vpn

cd $(dirname $0)

DOCKERIMAGE=theshellland/docker-openfortinet-vpn

unset PID

if [ -f env.sh ]; then
  source env.sh
else
  echo "env.sh not found"
  exit 1
fi

docker volume create openfortinet-vpn-root
docker volume create openfortinet-vpn-ssh
docker volume create openfortinet-vpn-home

docker pull $DOCKERIMAGE || :

if [ -f vpn.log ]; then rm -v vpn.log; fi

while true; do

  docker rm -f openfortinet-vpn 2>/dev/null || :
  docker run --rm --privileged --name openfortinet-vpn \
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
    -v $(pwd)/config/resolv.conf.1:/etc/resolv.conf.1 \
    -v $(pwd)/ca-certificates:/usr/local/share/ca-certificates \
    -v $HOME/.ssh:/ssh:ro \
    $DOCKERIMAGE >vpn.log &

  until [ -f vpn.log ]; do sleep 1; done

  disconnect=no
  while true; do
    while read log; do
      check="Tunnel is up and running."
      if [[ "$log" == *"$check"* ]]; then
        echo -ne '\n\nConnected!'
        ssh dockerproxy -TN
        disconnect=yes
      fi

      if [ $disconnect = yes ]; then
        break
      fi
      sleep 1
    done <vpn.log

    if [ $disconnect = yes ]; then
      break
    fi
    sleep 1
  done

  PID=$!
  echo -ne "\n\n\n"
  read -p "Press any key to restart "
  kill "$PID" 2>/dev/null || killall docker-proxy.sh 2>/dev/null
  echo -ne "\n\n\n"
done
