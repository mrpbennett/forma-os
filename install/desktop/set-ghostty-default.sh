#!/usr/bin/env sh

# Make ghostty default terminal emulator
if command -v update-alternatives >/dev/null 2>&1; then
  sudo update-alternatives --set x-terminal-emulator /usr/bin/ghostty || true
elif command -v alternatives >/dev/null 2>&1; then
  sudo alternatives --set x-terminal-emulator /usr/bin/ghostty || true
fi

# Configure GNOME to launch ghostty for terminal requests
if command -v gsettings >/dev/null 2>&1; then
  gsettings set org.gnome.desktop.default-applications.terminal exec 'ghostty'
  gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''
fi

# use the configs from forma
rm -rf ~/.config/ghostty
cp -R ~/.local/share/forma/configs/ghostty ~/.config/ghostty
