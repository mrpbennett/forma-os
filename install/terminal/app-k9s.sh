#!/bin/bash

# Removed set -e to handle errors gracefully

# k9s installation script for Fedora
# Fetches the latest release from GitHub and installs it

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        K9S_ARCH="amd64"
        ;;
    aarch64|arm64)
        K9S_ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

echo "Detected architecture: $K9S_ARCH"

# Get the latest version from GitHub
echo "Fetching latest k9s version..."
LATEST_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo "Failed to fetch latest version from GitHub API"
    echo "Check your internet connection and try again"
    exit 1
fi

echo "Latest version: $LATEST_VERSION"

# Construct download URL
DOWNLOAD_URL="https://github.com/derailed/k9s/releases/download/${LATEST_VERSION}/k9s_Linux_${K9S_ARCH}.tar.gz"

# Create temporary directory
TMP_DIR=$(mktemp -d)
if ! cd "$TMP_DIR"; then
    echo "Failed to change to temporary directory"
    exit 1
fi

# Download the tarball
echo "Downloading k9s..."
if ! curl -LO "$DOWNLOAD_URL"; then
    echo "Failed to download k9s from $DOWNLOAD_URL"
    cd -
    rm -rf "$TMP_DIR"
    exit 1
fi

# Extract the tarball
echo "Extracting archive..."
if ! tar -xzf "k9s_Linux_${K9S_ARCH}.tar.gz"; then
    echo "Failed to extract k9s archive"
    cd -
    rm -rf "$TMP_DIR"
    exit 1
fi

# Install k9s binary
echo "Installing k9s to /usr/local/bin..."
if ! sudo install -m 755 k9s /usr/local/bin/k9s; then
    echo "Failed to install k9s binary"
    cd -
    rm -rf "$TMP_DIR"
    exit 1
fi

# Clean up
cd -
rm -rf "$TMP_DIR"

# use the configs from forma
echo "Setting up k9s configuration..."
rm -rf ~/.config/k9s
if ! cp -R ~/.local/share/forma/configs/k9s ~/.config/k9s; then
    echo "Warning: Failed to copy k9s configuration, using defaults"
fi

# Verify installation
if command -v k9s &> /dev/null; then
    echo "k9s installed successfully!"
    echo "Version: $(k9s version --short)"
else
    echo "Installation failed!"
    exit 1
fi
