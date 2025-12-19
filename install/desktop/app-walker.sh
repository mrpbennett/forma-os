#!/bin/bash

# Install Walker and Elephant from COPR repository
sudo dnf -y copr enable errornointernet/walker
sudo dnf install -y walker
sudo dnf install -y elephant

# Install common elephant providers
sudo dnf install -y elephant-desktopapplications elephant-calc elephant-runner elephant-menus elephant-websearch elephant-files

# Make sure elephant runs at boot
ELEPHANT_PATH=$(which elephant)

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

systemctl --user daemon-reload
systemctl --user enable elephant
systemctl --user start elephant
loginctl enable-linger $USER

# Create walker config directory
cp -R ~/.local/share/forma/configs/ghostty ~/.config/ghostty

# Enable and start elephant service
elephant service enable
systemctl --user start elephant.service

# Start walker service for faster startup times
walker --gapplication-service &
disown
