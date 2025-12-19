#!/bin/bash
set -e

sudo dnf install -y fzf ripgrep bat mlocate httpd-tools fd-find

# Zoxide install
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh


#
# EZA Install
#

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
REPO="eza-community/eza"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="eza"

echo -e "${GREEN}eza installer for Fedora${NC}"
echo "=================================="

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        RELEASE_ARCH="x86_64-unknown-linux-gnu"
        ;;
    aarch64)
        RELEASE_ARCH="aarch64-unknown-linux-gnu"
        ;;
    armv7l)
        RELEASE_ARCH="arm-unknown-linux-gnueabihf"
        ;;
    *)
        echo -e "${RED}Unsupported architecture: $ARCH${NC}"
        exit 1
        ;;
esac

echo -e "${YELLOW}Detected architecture: $ARCH ($RELEASE_ARCH)${NC}"

# Get latest release info
echo "Fetching latest release information..."
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/$REPO/releases/latest")
VERSION=$(echo "$LATEST_RELEASE" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$VERSION" ]; then
    echo -e "${RED}Failed to fetch latest version${NC}"
    exit 1
fi

echo -e "${GREEN}Latest version: $VERSION${NC}"

# Construct download URL
DOWNLOAD_URL="https://github.com/$REPO/releases/download/$VERSION/eza_${RELEASE_ARCH}.tar.gz"

echo "Downloading from: $DOWNLOAD_URL"

# Create temporary directory
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

cd "$TMP_DIR"

# Download the release
if ! curl -L -o "eza.tar.gz" "$DOWNLOAD_URL"; then
    echo -e "${RED}Failed to download eza${NC}"
    exit 1
fi

# Extract the archive
echo "Extracting archive..."
tar -xzf "eza.tar.gz"

# Find the binary (it should be in the extracted directory)
if [ ! -f "./eza" ]; then
    echo -e "${RED}Binary not found in archive${NC}"
    exit 1
fi

# Check if we need sudo
if [ -w "$INSTALL_DIR" ]; then
    SUDO=""
else
    SUDO="sudo"
    echo -e "${YELLOW}Requires sudo to install to $INSTALL_DIR${NC}"
fi

# Install the binary
echo "Installing eza to $INSTALL_DIR..."
$SUDO install -m 755 "./eza" "$INSTALL_DIR/$BINARY_NAME"

# Verify installation
if command -v eza &> /dev/null; then
    INSTALLED_VERSION=$(eza --version | head -n1)
    echo -e "${GREEN}Successfully installed: $INSTALLED_VERSION${NC}"
    echo -e "${GREEN}Location: $(which eza)${NC}"
else
    echo -e "${RED}Installation failed - eza command not found${NC}"
    exit 1
fi
