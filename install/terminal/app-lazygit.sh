#!/bin/bash

# Lazygit installation with proper error handling
ORIGINAL_DIR=$(pwd)

# Change to temporary directory
if ! cd /tmp; then
    echo "Failed to change to /tmp directory"
    exit 1
fi

# Get latest version from GitHub API
echo "Fetching latest lazygit version..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

if [ -z "$LAZYGIT_VERSION" ]; then
    echo "Failed to fetch lazygit version from GitHub API"
    echo "Check your internet connection and try again"
    cd "$ORIGINAL_DIR"
    exit 1
fi

echo "Latest lazygit version: $LAZYGIT_VERSION"

# Download lazygit
echo "Downloading lazygit..."
if ! curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"; then
    echo "Failed to download lazygit"
    cd "$ORIGINAL_DIR"
    exit 1
fi

# Extract lazygit
echo "Extracting lazygit..."
if ! tar -xf lazygit.tar.gz lazygit; then
    echo "Failed to extract lazygit archive"
    rm -f lazygit.tar.gz
    cd "$ORIGINAL_DIR"
    exit 1
fi

# Install lazygit
echo "Installing lazygit..."
if ! sudo install lazygit /usr/local/bin; then
    echo "Failed to install lazygit binary"
    rm -f lazygit.tar.gz lazygit
    cd "$ORIGINAL_DIR"
    exit 1
fi

# Clean up
rm -f lazygit.tar.gz lazygit
cd "$ORIGINAL_DIR"

# Create config directory
echo "Setting up lazygit configuration..."
mkdir -p ~/.config/lazygit/
touch ~/.config/lazygit/config.yml

echo "Lazygit installed successfully!"
