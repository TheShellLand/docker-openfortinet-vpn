#!/bin/bash


cd $(dirname $0) && set -xe

source env.sh

# Install dependencies
apt update 2>&1 >/dev/null \
    && apt install -y gpg \
    && apt install -y ca-certificates \
    && apt install -y iproute2 \
    && apt install -y iputils-ping \
    && apt install -y iptables

pip3 install --upgrade pip setuptools wheel
pip3 install minepy

# Install OpenFortiGUI
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2FAB19E7CCB7F415 \
    && mkdir -p /etc/apt/sources.list.d/ \
    && echo "deb https://apt.iteas.at/iteas bionic main" > /etc/apt/sources.list.d/iteas.list \
    && apt update \
    && apt install -y openfortigui \
    && apt install -y openfortivpn \
    && chmod u+s /usr/sbin/pppd

#cp -v config/resolv.conf.1 /etc/resolv.conf.1

# Create vpn config
#/bin/bash create-profile.sh
cp -v vpn.conf $CONFIG

# Fix permissions
#cp -v /etc/resolv.conf.1 /etc/resolv.conf

# copy certs
cp -rv ca-certificates/*.crt /usr/local/share/ca-certificates/

# Update ca certs
update-ca-certificates -v | grep cdn1

# Start vpn
if [ "$1" == "-v" ]; then
  openfortivpn -v -c $CONFIG
else
  openfortivpn -c $CONFIG
fi
