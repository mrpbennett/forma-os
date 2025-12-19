#!/bin/bash

echo "Installing Bitwarden..."
if ! sudo flatpak install -y flathub com.bitwarden.desktop; then
    echo "Failed to install Bitwarden via Flatpak"
    exit 1
fi
