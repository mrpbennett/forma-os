#!/bin/bash

sudo flatpak install flathub -y org.gnome.Extensions
sudo dnf install -y libgtop2-devel
sudo dnf install -y clutter-devel

# Install pipx non-interactively (Fedora package name is pipx/python3-pipx)
if ! sudo dnf install -y pipx; then
    sudo dnf install -y python3-pipx
fi

pipx ensurepath
export PATH="$HOME/.local/bin:$PATH"

pipx install --force gnome-extensions-cli --system-site-packages

# Ensure gext is available before continuing
if ! command -v gext >/dev/null 2>&1; then
    echo "Error: gext command not found even after installing gnome-extensions-cli."
    exit 1
fi

# Turn off default Fedora extensions that may conflict
gnome-extensions disable ding@rastersoft.com

# Pause to assure user is ready to accept confirmations
gum confirm "To install Gnome extensions, you need to accept some confirmations. Ready?"

# Install new extensions
gext install just-perfection-desktop@just-perfection
gext install blur-my-shell@aunetx
gext install space-bar@luchrioh
gext install undecorate@sun.wxg@gmail.com
gext install tophat@fflewddur.github.io
gext install AlphabeticalAppGrid@stuarthayhurst
gext install dash-to-dock@micxgx.gmail.com

# Compile gsettings schemas in order to be able to set them
sudo cp ~/.local/share/gnome-shell/extensions/just-perfection-desktop\@just-perfection/schemas/org.gnome.shell.extensions.just-perfection.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/blur-my-shell\@aunetx/schemas/org.gnome.shell.extensions.blur-my-shell.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/space-bar\@luchrioh/schemas/org.gnome.shell.extensions.space-bar.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/tophat@fflewddur.github.io/schemas/org.gnome.shell.extensions.tophat.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/AlphabeticalAppGrid\@stuarthayhurst/schemas/org.gnome.shell.extensions.AlphabeticalAppGrid.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/dash-to-dock\@micxgx.gmail.com/schemas/org.gnome.shell.extensions.dash-to-dock.gschema.xml /usr/share/glib-2.0/schemas/
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

#  Configure PopOS Shell Tiling Mgnr
gsettings set org.gnome.shell.extensions.pop-shell gap-inner 4
gsettings set org.gnome.shell.extensions.pop-shell gap-outer 4
gsettings set org.gnome.shell.extensions.pop-shell active-hint true
gsettings set org.gnome.shell.extensions.pop-shell active-hint-border-radius 20
gsettings set org.gnome.shell.extensions.pop-shell hint-color-rgba "rgba(234,252,252)"

# PopOS Shell Tiling Mgnr KeyBindings
gsettings set org.gnome.shell.extensions.pop-shell focus-down "['<Super>j']"
gsettings set org.gnome.shell.extensions.pop-shell focus-left "['<Super>h']"
gsettings set org.gnome.shell.extensions.pop-shell focus-right "['<Super>l']"
gsettings set org.gnome.shell.extensions.pop-shell focus-up "['<Super>k']"

gsettings set org.gnome.shell.extensions.pop-shell tile-move-down "['<Super><Shift>j']"
gsettings set org.gnome.shell.extensions.pop-shell tile-move-left "['<Super><Shift>h']"
gsettings set org.gnome.shell.extensions.pop-shell tile-move-right "['<Super><Shift>l']"
gsettings set org.gnome.shell.extensions.pop-shell tile-move-up "['<Super><Shift>k']"

gsettings set org.gnome.shell.extensions.pop-shell tile-resize-down "['<Shift>j', '<Shift>Down', '<Shift>KP_Down']"
gsettings set org.gnome.shell.extensions.pop-shell tile-resize-left "['<Shift>h', '<Shift>Left', '<Shift>KP_Left']"
gsettings set org.gnome.shell.extensions.pop-shell tile-resize-right "['<Shift>l', '<Shift>Right', '<Shift>KP_Right']"
gsettings set org.gnome.shell.extensions.pop-shell tile-resize-up "['<Shift>k', '<Shift>Up', '<Shift>KP_Up']"

gsettings set org.gnome.shell.extensions.pop-shell toggle-tiling "['<Super>y']"

# Configure Just Perfection
gsettings set org.gnome.shell.extensions.just-perfection animation 2
gsettings set org.gnome.shell.extensions.just-perfection dash-app-running true
gsettings set org.gnome.shell.extensions.just-perfection workspace true
gsettings set org.gnome.shell.extensions.just-perfection workspace-popup false

# Configure Blur My Shell
gsettings set org.gnome.shell.extensions.blur-my-shell.appfolder blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.lockscreen blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.screenshot blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.window-list blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.overview blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.overview pipeline "pipeline_default"
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock brightness 0.6
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock sigma 30
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock static-blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock style-dash-to-dock 0

# Configure Space Bar
gsettings set org.gnome.shell.extensions.space-bar.behavior smart-workspace-names false
gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-activate-workspace-shortcuts false
gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-move-to-workspace-shortcuts true
gsettings set org.gnome.shell.extensions.space-bar.shortcuts open-menu "@as "[]""

# Configure TopHat
gsettings set org.gnome.shell.extensions.tophat show-icons false
gsettings set org.gnome.shell.extensions.tophat show-cpu false
gsettings set org.gnome.shell.extensions.tophat show-disk false
gsettings set org.gnome.shell.extensions.tophat show-mem false
gsettings set org.gnome.shell.extensions.tophat show-fs false
gsettings set org.gnome.shell.extensions.tophat network-usage-unit bits

# Configure AlphabeticalAppGrid
gsettings set org.gnome.shell.extensions.alphabetical-app-grid folder-order-position 'end'

# Dash-to-Dock
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
gsettings set org.gnome.shell.extensions.dash-to-dock force-straight-corner false
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'DYNAMIC'
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.8
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 40
gsettings set org.gnome.shell.extensions.dash-to-dock unity-backlit-items false
gsettings set org.gnome.shell.extensions.dash-to-dock running-indicator-style 'DOTS'
gsettings set org.gnome.shell.extensions.dash-to-dock apply-custom-theme false
gsettings set org.gnome.shell.extensions.dash-to-dock animation-time 0.25
gsettings set org.gnome.shell.extensions.dash-to-dock hide-delay 0.15
gsettings set org.gnome.shell.extensions.dash-to-dock show-delay 0.2
gsettings set org.gnome.shell.extensions.dash-to-dock pressure-threshold 50.0
