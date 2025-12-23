#!/usr/bin/env bash
set -euo pipefail

# This script installs wtype on Fedora and sets GNOME custom keybindings
# to mirror the Hyprland clipboard shortcuts (Super+C/V/X and Super+Ctrl+V).

if [[ $(id -u) -eq 0 ]]; then
  echo "Run as your user (not root) so gsettings writes to your session."
  exit 1
fi

if ! command -v dnf >/dev/null 2>&1; then
  echo "This script is intended for Fedora (dnf not found)."
  exit 1
fi

# wtype sends Wayland key events; wl-clipboard provides wl-copy/wl-paste helpers.
echo "Installing wtype (and wl-clipboard for Wayland clipboard access)..."
sudo dnf install -y wtype wl-clipboard

# Define the custom keybindings we want to create/ensure.
KEY_IDS=(
  wtype-copy
  wtype-paste
  wtype-cut
  wtype-clipboard-manager
)
KEY_NAMES=(
  "Universal copy (wtype)"
  "Universal paste (wtype)"
  "Universal cut (wtype)"
  "Clipboard manager (wofi + cliphist)"
)
KEY_COMMANDS=(
  "wtype --mods ctrl --key insert"
  "wtype --mods shift --key insert"
  "wtype --mods ctrl --key x"
  "bash -lc 'if command -v cliphist >/dev/null 2>&1 && command -v wofi >/dev/null 2>&1; then cliphist list | wofi --dmenu | cliphist decode | wl-copy; else notify-send \"Super+Ctrl+V\" \"Install cliphist and wofi for clipboard picker\"; fi'"
)
KEY_BINDINGS=(
  "<Super>c"
  "<Super>v"
  "<Super>x"
  "<Super><Control>v"
)

# Add the custom keybinding paths to the GNOME list without clobbering existing ones.
python3 - <<'PY'
import ast
import subprocess

schema = "org.gnome.settings-daemon.plugins.media-keys"
key = "custom-keybindings"
key_ids = [
    "wtype-copy",
    "wtype-paste",
    "wtype-cut",
    "wtype-clipboard-manager",
]
paths = [f"/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/{kid}/" for kid in key_ids]

current_raw = subprocess.check_output(["gsettings", "get", schema, key], text=True).strip()
if current_raw.startswith("@as "):
    current_raw = current_raw[4:]
try:
    current = ast.literal_eval(current_raw)
except Exception:
    current = []

for path in paths:
    if path not in current:
        current.append(path)

subprocess.check_call(["gsettings", "set", schema, key, str(current)])
PY

# Populate each custom keybinding entry.
for i in "${!KEY_IDS[@]}"; do
  PATH_KEY="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${KEY_IDS[$i]}/"
  gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${PATH_KEY}" name "${KEY_NAMES[$i]}"
  gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${PATH_KEY}" command "${KEY_COMMANDS[$i]}"
  gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${PATH_KEY}" binding "${KEY_BINDINGS[$i]}"
done
