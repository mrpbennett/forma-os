#!/bin/bash
set -euo pipefail

# https://github.com/pop-os/shell

sudo dnf install -y gnome-shell-extension-pop-shell xprop

# Set system defaults so Pop Shell is enabled for all users on first login.
sudo mkdir -p /etc/dconf/db/local.d
sudo tee /etc/dconf/db/local.d/00-pop-shell >/dev/null <<'EOF'
[org/gnome/shell]
enabled-extensions=['pop-shell@system76.com']
EOF

sudo dconf update
