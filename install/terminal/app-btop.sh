#!/bin/bash

# This script installs btop, a resource monitor that shows usage and stats for processor, memory, disks, network and processes.
sudo dnf install -y btop

# Use forma btop config
mkdir -p ~/.config/btop/themes
cp ~/.local/share/forma/configs/btop.conf ~/.config/btop/btop.conf
cp ~/.local/share/forma/themes/catppuccin/btop.theme ~/.config/btop/themes/catppuccin.theme
