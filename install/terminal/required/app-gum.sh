#!/bin/bash

echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo
sudo rpm --import https://repo.charm.sh/yum/gpg.key

# yum
sudo yum install -y gum

# install zypper
sudo dnf install zypper

# zypper
sudo zypper -y refresh
sudo zypper install -y gum
