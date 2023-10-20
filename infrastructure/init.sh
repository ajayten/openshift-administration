#!/bin/bash

# update packaghe sources
apt-get update

# upgrade system
apt-get -y dist-upgrade

# autoremove unused stuff
apt-get -y autoremove

# install useful packages
apt-get install -y python3-certbot python3-certbot-dns-route53 certbot jq 

# download and extract openshift installer and client
cd /tmp
wget https://github.com/okd-project/okd/releases/download/4.13.0-0.okd-2023-09-30-084937/openshift-client-linux-4.13.0-0.okd-2023-09-30-084937.tar.gz
wget https://github.com/okd-project/okd/releases/download/4.13.0-0.okd-2023-09-30-084937/openshift-install-linux-4.13.0-0.okd-2023-09-30-084937.tar.gz

tar xf openshift-client-linux-4.13.0-0.okd-2023-09-30-084937.tar.gz
tar xf openshift-install-linux-4.13.0-0.okd-2023-09-30-084937.tar.gz
cp oc /usr/local/bin
cp kubectl /usr/local/bin
cp openshift-install /usr/local/bin

echo '{"auths":{"fake":{"auth": "bar"}}}' > /home/ubuntu/pull-secret
chown ubuntu:ubuntu /home/ubuntu/pull-secret

# make aws configuration
mkdir -p /home/ubuntu/.aws
echo "[default]" > /home/ubuntu/.aws/config
echo "region = eu-central-1"  >> /home/ubuntu/.aws/config
echo "output = json" >> /home/ubuntu/.aws/config

echo "[default]" > /home/ubuntu/.aws/credentials
chown -R ubuntu:ubuntu /home/ubuntu/.aws

