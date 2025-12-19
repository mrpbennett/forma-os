#!/bin/bash

# Browse the web with the most popular browser. See https://www.google.com/chrome/
# Google Chrome installation with proper error handling
ORIGINAL_DIR=$(pwd)

# Change to temporary directory
if ! cd /tmp; then
    echo "Failed to change to /tmp directory"
    exit 1
fi

# Download Google Chrome
echo "Downloading Google Chrome..."
if ! wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm; then
    echo "Failed to download Google Chrome"
    cd "$ORIGINAL_DIR"
    exit 1
fi

# Install Google Chrome
echo "Installing Google Chrome..."
if ! sudo dnf install -y ./google-chrome-stable_current_x86_64.rpm; then
    echo "Failed to install Google Chrome via dnf"
    rm -f google-chrome-stable_current_x86_64.rpm
    cd "$ORIGINAL_DIR"
    exit 1
fi

# Clean up
rm -f google-chrome-stable_current_x86_64.rpm
cd "$ORIGINAL_DIR"

# Ensure Chrome uses basic password store to avoid keyring prompts
echo "Configuring Chrome flags..."
FLAGS_FILE="$HOME/.config/chrome-flags.conf"
mkdir -p "$(dirname "$FLAGS_FILE")"
cp ~/.local/share/forma/configs/chrome-flags.conf "$FLAGS_FILE"

# Patch desktop entry locally so all launches include the flag
SYSTEM_DESKTOP="/usr/share/applications/google-chrome.desktop"
LOCAL_DESKTOP="$HOME/.local/share/applications/google-chrome.desktop"
if [ -f "$SYSTEM_DESKTOP" ]; then
    mkdir -p "$(dirname "$LOCAL_DESKTOP")"
    cp "$SYSTEM_DESKTOP" "$LOCAL_DESKTOP"
    sed -i 's#Exec=/usr/bin/google-chrome-stable#Exec=/usr/bin/google-chrome-stable --password-store=basic#g' "$LOCAL_DESKTOP"
    sed -i 's#Exec=/usr/bin/google-chrome #Exec=/usr/bin/google-chrome --password-store=basic #g' "$LOCAL_DESKTOP"
fi

# Set as default browser
echo "Setting Google Chrome as default browser..."
if ! xdg-settings set default-web-browser google-chrome.desktop; then
    echo "Warning: Failed to set Google Chrome as default browser"
fi

echo "Google Chrome installed successfully!"
