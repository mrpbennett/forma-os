#!/bin/bash

# Needed for all installers
sudo dnf update -y
sudo dnf upgrade -y
sudo dnf install -y curl git unzip wget dnf-plugins-core

# Run terminal installers
for installer in ~/.local/share/forma/install/terminal/*.sh; do
    if [[ -f "$installer" ]]; then
        echo "Running $(basename "$installer")..."
        if ! source "$installer"; then
            echo "Warning: Failed to run $(basename "$installer"). Continuing with installation..."
        fi
    fi
done
