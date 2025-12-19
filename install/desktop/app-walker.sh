#!/bin/bash

# Install dependencies
sudo dnf install -y gtk4 gtk4-layer-shell cairo poppler-glib protobuf-compiler

# Install Walker and Elephant from COPR repository
sudo dnf copr enable -y errornointernet/walker
sudo dnf install -y walker elephant

# Install common elephant providers
sudo dnf install -y elephant-desktopapplications elephant-calc elephant-runner elephant-menus elephant-websearch elephant-files

# Make sure elephant runs at boot
ELEPHANT_PATH=$(command -v elephant)
if [ -z "$ELEPHANT_PATH" ]; then
  echo "elephant not found in PATH" >&2
  exit 1
fi

mkdir -p ~/.config/systemd/user

cat > ~/.config/systemd/user/elephant.service <<EOF
[Unit]
Description=Elephant
After=network-online.target

[Service]
ExecStart=$ELEPHANT_PATH
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
EOF

# Reload systemd to recognize the new service
systemctl --user daemon-reload

# Enable and start elephant service
systemctl --user enable elephant.service
systemctl --user start elephant.service

# Create walker config directory
mkdir -p ~/.config/walker
cp -R ~/.local/share/forma/configs/walker/* ~/.config/walker/

# Start walker service for faster startup times
walker --gapplication-service &
disown
