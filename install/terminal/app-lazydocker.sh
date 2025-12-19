#!/bin/bash

# Lazydocker installation with proper error handling
ORIGINAL_DIR=$(pwd)

# Change to temporary directory
if ! cd /tmp; then
    echo "Failed to change to /tmp directory"
    exit 1
fi

# Get latest version from GitHub API
echo "Fetching latest lazydocker version..."
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

if [ -z "$LAZYDOCKER_VERSION" ]; then
    echo "Failed to fetch lazydocker version from GitHub API"
    echo "Check your internet connection and try again"
    cd "$ORIGINAL_DIR"
    exit 1
fi

echo "Latest lazydocker version: $LAZYDOCKER_VERSION"

# Download lazydocker
echo "Downloading lazydocker..."
if ! curl -sLo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"; then
    echo "Failed to download lazydocker"
    cd "$ORIGINAL_DIR"
    exit 1
fi

# Extract lazydocker
echo "Extracting lazydocker..."
if ! tar -xf lazydocker.tar.gz lazydocker; then
    echo "Failed to extract lazydocker archive"
    rm -f lazydocker.tar.gz
    cd "$ORIGINAL_DIR"
    exit 1
fi

# Install lazydocker
echo "Installing lazydocker..."
if ! sudo install lazydocker /usr/local/bin; then
    echo "Failed to install lazydocker binary"
    rm -f lazydocker.tar.gz lazydocker
    cd "$ORIGINAL_DIR"
    exit 1
fi

# Clean up
rm -f lazydocker.tar.gz lazydocker
cd "$ORIGINAL_DIR"

echo "Lazydocker installed successfully!"
