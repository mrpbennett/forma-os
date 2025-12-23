#!/bin/bash

# Kanata homerow mods installation script

set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "Installing kanata homerow mods configuration..."

# Install kanata if not already installed
if ! command -v kanata &> /dev/null; then
    echo "Installing kanata..."

    # Check if we're on Fedora
    if command -v dnf &> /dev/null; then
        # Update package list
        echo "Updating package list..."
        sudo dnf update -y || {
            echo "Error: Failed to update package list"
            exit 1
        }

        # Rust toolchain is installed via ~/.local/share/forma/install/rust.sh
        if [ -f "$HOME/.cargo/env" ]; then
            # shellcheck source=/dev/null
            source "$HOME/.cargo/env"
        fi
        if ! command -v cargo &> /dev/null; then
            echo "Error: cargo not found. Install Rust by running: ~/.local/share/forma/install/rust.sh"
            exit 1
        fi

        # Clone and build kanata from source
        echo "Building kanata from source..."
        cd /tmp || exit 1

        # Remove existing clone if present
        rm -rf kanata

        git clone https://github.com/jtroo/kanata.git || {
            echo "Error: Failed to clone kanata repository"
            exit 1
        }

        cd kanata || exit 1
        cargo build --release || {
            echo "Error: Failed to build kanata"
            cd /
            rm -rf /tmp/kanata
            exit 1
        }

        # Install binary to /usr/local/bin
        if [ ! -f target/release/kanata ]; then
            echo "Error: kanata binary not found after build"
            cd /
            rm -rf /tmp/kanata
            exit 1
        fi

        sudo cp target/release/kanata /usr/local/bin/ || {
            echo "Error: Failed to install kanata binary"
            cd /
            rm -rf /tmp/kanata
            exit 1
        }

        sudo chmod +x /usr/local/bin/kanata

        # Clean up
        cd / || exit 1
        rm -rf /tmp/kanata

        echo "Kanata successfully installed to /usr/local/bin/kanata"
    else
        echo "Error: Unsupported package manager. Please install kanata manually."
        echo "This script requires dnf (Fedora)."
        exit 1
    fi
else
    echo "Kanata is already installed at $(command -v kanata)"
fi

# Check if user is in input group (needed to read input devices)
if ! groups | grep -q "\binput\b"; then
    echo "Adding $USER to input group for device access..."
    sudo usermod -aG input "$USER"
    NEEDS_RELOGIN=true
fi

# Setup udev rule for uinput
# We use the 'input' group because the user is already in it for reading devices
UDEV_RULE='KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"'
UDEV_FILE="/etc/udev/rules.d/99-kanata-uinput.rules"

echo "Configuring udev rules for /dev/uinput..."
echo "$UDEV_RULE" | sudo tee "$UDEV_FILE" > /dev/null

echo "Reloading udev rules and uinput device..."
sudo udevadm control --reload-rules
sudo modprobe -r uinput 2>/dev/null || true
sudo modprobe uinput
sudo udevadm trigger

# Verify permissions
echo "Verifying /dev/uinput permissions..."
ls -l /dev/uinput


# Create config directory
mkdir -p "$HOME/.config/kanata"

# Copy kbd file to config location
echo "Copying kanata configuration..."
cp "$SCRIPT_DIR/kanata-homerow-mods.kbd" "$HOME/.config/kanata/homerow-mods.kbd"

# Create systemd user directory
mkdir -p "$HOME/.config/systemd/user"

# Generate systemd service file
echo "Creating systemd user service..."
cat > "$HOME/.config/systemd/user/kanata.service" << EOF
[Unit]
Description=Kanata keyboard remapper
Documentation=https://github.com/jtroo/kanata
After=graphical-session.target

[Service]
Type=simple
Environment=DISPLAY=:0
ExecStart=$(command -v kanata) -c %h/.config/kanata/homerow-mods.kbd
Restart=always
RestartSec=3
Nice=-20

[Install]
WantedBy=default.target
EOF

# Reload systemd daemon
echo "Reloading systemd..."
systemctl --user daemon-reload

# Enable and start the service
echo "Enabling kanata service..."
systemctl --user enable kanata.service

echo "Restarting kanata service..."
systemctl --user restart kanata.service

# Check service status
echo ""
echo "Checking service status..."
systemctl --user status kanata.service --no-pager

echo ""
echo "Installation complete!"
echo "Kanata configuration: $HOME/.config/kanata/homerow-mods.kbd"
echo "Service file: $HOME/.config/systemd/user/kanata.service"
