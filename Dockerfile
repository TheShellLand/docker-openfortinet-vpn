FROM ubuntu:18.04 as docker-openfortinet-vpn-base

# Install dependencies
RUN apt update 2>&1 >/dev/null \
    && apt install -y gpg \
    && apt install -y ca-certificates \
    && apt install -y iproute2 \
    && apt install -y iputils-ping \
    && apt install -y iptables

# Install OpenSSH service
RUN apt install -y openssh-server

# Install OpenVPN service
RUN apt install -y openvpn easy-rsa

# Installs tools
RUN apt install -y git wget curl vim rsync

# Install OpenFortiGUI
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2FAB19E7CCB7F415 \
    && mkdir -p /etc/apt/sources.list.d/ \
    && echo "deb https://apt.iteas.at/iteas bionic main" > /etc/apt/sources.list.d/iteas.list \
    && apt update \
    && apt install -y openfortigui \
    && apt install -y openfortivpn \
    && chmod u+s /usr/sbin/pppd

USER root



FROM docker-openfortinet-vpn-base
LABEL description="Openfortinet VPN client"

# Environment variables
ENV SSH_USER ubuntu
ENV SSH_USER_PASS ubuntu

ENV VPN_USER VPN_USER
ENV VPN_PASS VPN_PASS
ENV VPN_HOST VPN_HOST
ENV VPN_TRUSTED_CERT VPN_TRUSTED_CERT

ENV CERTS /usr/local/share/ca-certificates
ENV CONFIG /etc/openfortivpn/vpn.conf
ENV RESOLV /etc/resolv.conf

COPY entry.sh /
COPY requirements.txt /
COPY create-profile.sh /
COPY create_profile.py /
COPY user_mods.sh.example /
COPY config/resolv.conf.1 /etc/resolv.conf.1

# install pip
RUN apt install -y python3-distutils \
    && curl "https://bootstrap.pypa.io/get-pip.py" -o get-pip.py \
    && python3 "get-pip.py" \
    && pip3 install -r requirements.txt

VOLUME ["/etc/ssh"]
VOLUME ["/root"]
VOLUME ["/home"]

USER root
WORKDIR /root

EXPOSE 22

CMD ["/bin/bash"]

ENTRYPOINT ["/bin/bash", "/entry.sh"]
