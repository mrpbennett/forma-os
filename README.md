![banner](misc/image.png)
Forma is a Fedora-first system bootstrapper and dotfiles repo that turns a fresh Fedora 39+ install into a configured, developer-ready GNOME workstation. It installs terminal tooling, desktop applications, GNOME extensions and settings, and applies curated configuration files for common apps.

This repo is intentionally opinionated: it targets Fedora, assumes GNOME, and optimizes for a clean, productive setup with minimal manual steps.

## Goals

- **Fast bootstrap**: one command to go from stock Fedora to a working dev environment.
- **GNOME polish**: defaults, extensions, hotkeys, workspace behavior, and theme tweaks.
- **Developer tooling**: modern shell, CLI utilities, language runtimes, and editor setups.
- **Consistency**: repeatable installs with curated configs.

## Requirements

- Fedora **39+** (checked in `install/check-version.sh`)
- **x86_64** or **i686** architecture
- GNOME (desktop setup and tweaks are only applied under GNOME)
- Network access and `sudo`

## Quick Install

```bash
curl -sSL https://raw.githubusercontent.com/mrpbennett/forma/refs/heads/main/boot.sh | bash
```

`boot.sh` updates the system, clones the repo to `~/.local/share/forma`, and runs `install.sh`.

If you want a different branch or ref, set `forma_REF` before running the script:

```bash
forma_REF=stable curl -sSL https://raw.githubusercontent.com/mrpbennett/forma/refs/heads/main/boot.sh | bash
```

## What The Install Does

### System & Shell

- Updates and upgrades the system via `dnf`.
- Installs base tooling: `curl`, `git`, `unzip`, `wget`, `dnf-plugins-core`.
- Installs and configures **zsh** with **oh-my-zsh**, syntax highlighting, and autosuggestions.
- Applies curated shell config from `configs/zshrc` and `defaults/zsh/*`.
- Sets inputrc defaults from `configs/inputrc`.

### Terminal Tooling

Installed by default:

- **CLI utilities**: `fzf`, `ripgrep`, `bat`, `mlocate`, `httpd-tools`, `fd-find`, **zoxide**, **eza**
- **Git tools**: `gh` (GitHub CLI), **lazygit**
- **Containers**: Docker Engine + buildx + compose plugin
- **Kubernetes**: `kubectl` + **krew** plugin manager
- **Monitoring**: **btop**, **fastfetch**
- **Editor**: **Neovim** (with bundled config)
- **Prompt**: **starship**
- **File manager**: **yazi**
- **TUI tools**: **lazydocker**, **k9s**

Developer libraries and runtimes:

- **Development tools**: `@development-tools`, `pkg-config`, `autoconf`, `pipx`, `openssl-devel`, `readline-devel`, `libyaml-devel`, `ImageMagick`
- **Rust toolchain** via `rustup`
- **mise** for language runtimes, with defaults for `node@lts`, `go@latest`, `python@latest`, `java@latest`

Git configuration:

- Sets common aliases and enables `pull.rebase`
- Uses the name/email you provide during install

### Desktop Apps

Installed by default (GNOME only):

- **Ghostty** terminal (and set as default terminal)
- **Google Chrome** (plus basic password store flag and default browser)
- **Bitwarden** (Flatpak)
- **Discord** (Flatpak)
- **Slack** (Flatpak)
- **LocalSend** (Flatpak)
- **Ulauncher**
- **Flameshot**
- **GNOME Tweaks**
- **GNOME Sushi**
- **Pop Shell** tiling extension
- **wl-clipboard**
- **Zed** editor (plus `television` via cargo)

Web apps added as `.desktop` launchers:

- Apple Music
- WhatsApp

### GNOME Extensions & Settings

Extensions installed and configured:

- Just Perfection
- Blur My Shell
- Space Bar
- Undecorate
- TopHat
- Alphabetical App Grid
- Dash to Dock
- Pop Shell

GNOME tweaks include:

- Dock behavior, positioning, and styling
- App grid folders (Utilities, LibreOffice, Web Apps, etc.)
- Workspace count and workspace hotkeys
- Custom hotkeys (Ulauncher, Flameshot, Ghostty, Chrome)
- Font and clock settings
- World clock locations
- Default terminal and browser behavior
- GNOME theme settings and background

### Fonts & Theme

- Installs **JetBrains Mono Nerd Font**
- Applies **Catppuccin** theme for GNOME and btop

### Keyboard Remapping (Kanata)

- Builds and installs **Kanata** from source
- Adds udev rules for `/dev/uinput`
- Installs a systemd user service for automatic startup
- Copies the homerow-mods configuration

## Configuration Files Applied

Key configs shipped in this repo and copied during install:

- `configs/zshrc` + `defaults/zsh/*`
- `configs/inputrc`
- `configs/ghostty/`
- `configs/zed/`
- `configs/neovim/`
- `configs/yazi/`
- `configs/k9s/`
- `configs/btop.conf`
- `configs/fastfetch.jsonc`
- `configs/xcompose`
- `configs/chrome-flags.conf`

## CLI Menu

There is an interactive `gum`-based menu in `bin/aurios` and `bin/aurios-sub/*` for tasks like theme switching, fonts, updates, installs, and uninstalls. It expects the repo to live at `~/.local/share/forma`.

## Directory Structure

```
applications/     # Web app .desktop installers (Apple Music, WhatsApp)
bin/              # CLI menu scripts
configs/          # App configs (zsh, neovim, ghostty, etc.)
defaults/         # Default system configs (zsh, keyboard)
install/          # Installation scripts
  desktop/        # GNOME + desktop apps and tweaks
  terminal/       # CLI tooling and dev environment
migrations/       # Migration scripts (if present)
themes/           # Theme assets and settings
boot.sh           # Main bootstrap entrypoint
install.sh        # Main installer
```

## Notes

- Most installers are designed to be idempotent, but some scripts replace existing configs or back them up.
- Desktop setup is **GNOME-only**. Non-GNOME environments will still get the terminal tooling.
- The repo is intentionally opinionated; review scripts before running if you want a lighter setup.

## Manual Install

If you already have the repo locally:

```bash
source install.sh
```

## Troubleshooting

- If the boot script fails, rerun it after fixing network or package issues.
- If a GNOME extension install fails, rerun `install/desktop/set-gnome-extensions.sh` once GNOME is fully logged in.
- For Docker group changes, log out and back in (or run `newgrp docker`).
