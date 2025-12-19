#!/bin/bash

sudo dnf install -y dnf-plugins-core
sudo dnf copr enable scottames/ghostty -y
sudo dnf install -y ghostty

# use the configs from forma
rm -rf ~/.config/ghostty
cp -R ~/.local/share/forma/configs/ghostty ~/.config/ghostty
