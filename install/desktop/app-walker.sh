
#!/usr/bin/env bash
set -euo pipefail

# Build & install Elephant + Walker from source on Fedora, set up autostart for
# Elephant, and wire a GNOME keybinding to launch Walker (with Elephant running).

if [[ $(id -u) -eq 0 ]]; then
  echo "Run as your user (not root) so gsettings and systemd user services are correct." >&2
  exit 1
fi

if ! command -v dnf >/dev/null 2>&1; then
  echo "This script targets Fedora (dnf not found)." >&2
  exit 1
fi

# Base build/toolchain deps (Rust + GTK stack Walker uses)
echo "Installing build dependencies..."
sudo dnf install -y \
  git gcc gcc-c++ make pkg-config \
  rust cargo \
  gtk4-devel gtk4-layer-shell-devel libadwaita-devel \
  cairo-devel poppler-glib-devel protobuf-compiler

# Source + ref can be overridden via env (ELEPHANT_REF, WALKER_REF)
ELEPHANT_REPO="${ELEPHANT_REPO:-https://github.com/abenz1267/elephant.git}"
ELEPHANT_REF="${ELEPHANT_REF:-main}"
WALKER_REPO="${WALKER_REPO:-https://github.com/abenz1267/walker.git}"
WALKER_REF="${WALKER_REF:-main}"

workdir=$(mktemp -d)
cleanup() { rm -rf "$workdir"; }
trap cleanup EXIT

build_one() {
  local name="$1" repo="$2" ref="$3"
  echo "Building $name from $repo ($ref)..."
  git clone --depth=1 --branch "$ref" "$repo" "$workdir/$name"
  pushd "$workdir/$name" >/dev/null
  cargo build --release --locked
  install -Dm755 "target/release/$name" "$HOME/.local/bin/$name"
  popd >/dev/null
}

build_one elephant "$ELEPHANT_REPO" "$ELEPHANT_REF"
build_one walker "$WALKER_REPO" "$WALKER_REF"

# Ensure Elephant starts at login (user systemd service)
mkdir -p "$HOME/.config/systemd/user"
cat > "$HOME/.config/systemd/user/elephant.service" <<'EOF_SERVICE'
[Unit]
Description=Elephant provider daemon
After=network-online.target

[Service]
ExecStart=%h/.local/bin/elephant
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
EOF_SERVICE

systemctl --user daemon-reload
systemctl --user enable --now elephant.service

echo "Elephant user service enabled."

# Walker config (only create if missing to avoid clobbering user tweaks)
mkdir -p "$HOME/.config/walker"
if [[ ! -f "$HOME/.config/walker/config.toml" ]]; then
  cat > "$HOME/.config/walker/config.toml" <<'EOF_CFG'
force_keyboard_focus = true
selection_wrap = true
theme = "default"
hide_action_hints = true

[placeholders]
"default" = { input = "   Search...", list = "No Results" }

[keybinds]
quick_activate = []

[columns]
symbols = 1

[providers]
max_results = 256
default = ["desktopapplications", "websearch"]

[[providers.prefixes]]
prefix = "/"
provider = "providerlist"

[[providers.prefixes]]
prefix = "."
provider = "files"

[[providers.prefixes]]
prefix = ":"
provider = "symbols"

[[providers.prefixes]]
prefix = "="
provider = "calc"

[[providers.prefixes]]
prefix = "@"
provider = "websearch"

[[providers.prefixes]]
prefix = "$"
provider = "clipboard"
EOF_CFG
  echo "Installed default Walker config to ~/.config/walker/config.toml"
else
  echo "Walker config already exists; leaving it untouched."
fi

# GNOME hotkey: Super+Alt+Space -> ensure Elephant is up then launch Walker
if command -v gsettings >/dev/null 2>&1; then
  python3 - <<'PY'
import ast, subprocess
schema = "org.gnome.settings-daemon.plugins.media-keys"
key = "custom-keybindings"
path = "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/walker-launch/"

current_raw = subprocess.check_output(["gsettings", "get", schema, key], text=True).strip()
if current_raw.startswith("@as "):
    current_raw = current_raw[4:]
try:
    current = ast.literal_eval(current_raw)
except Exception:
    current = []
if path not in current:
    current.append(path)
subprocess.check_call(["gsettings", "set", schema, key, str(current)])

subprocess.check_call([
    "gsettings", "set",
    f"{schema}.custom-keybinding:{path}",
    "name", "Walker"
])
subprocess.check_call([
    "gsettings", "set",
    f"{schema}.custom-keybinding:{path}",
    "command", "elephant && walker"
])
subprocess.check_call([
    "gsettings", "set",
    f"{schema}.custom-keybinding:{path}",
    "binding", "<Super><Alt>space"
])
PY
  echo "GNOME hotkey set: Super+Alt+Space -> elephant && walker"
else
  echo "gsettings not found; skipping GNOME hotkey setup."
fi

# Pre-start Walker's GApplication service to reduce first-launch latency
if command -v walker >/dev/null 2>&1; then
  (walker --gapplication-service >/dev/null 2>&1 & disown) || true
fi

echo "Done. Log out/in (or restart your session) to ensure the Elephant service and hotkey are active."
