#!/bin/bash

# install docker
apt update

apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common -y

apt update && apt install docker.io

curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

usermod -aG docker $USER

# install kubeadm
apt update && apt install ebtables ethtool -y

apt update && apt install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt update && apt install -y kubelet kubeadm kubectl
