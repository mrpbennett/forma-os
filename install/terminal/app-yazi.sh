#!/bin/bash
sudo dnf copr enable -y lihaohong/yazi
sudo dnf install -y yazi

# use the configs from forma
rm -rf ~/.config/yazi
cp -R ~/.local/share/forma/configs/yazi ~/.config/yazi
