#!/bin/bash
set -euo pipefail

# Favorite apps for dock
apps=(
	"org.gnome.Nautilus.desktop"
	"google-chrome.desktop"
	"com.mitchellh.ghostty.desktop"
	"dev.zed.Zed.desktop"
	"com.discordapp.Discord"
	"com.slack.Slack"
	"AppleMusic.desktop"
	"org.gnome.Settings.desktop"
)

if [ "$EUID" -eq 0 ]; then
	echo "Run as your regular user; the script will use sudo for system defaults."
	exit 1
fi

# Array to hold installed favorite apps
installed_apps=()

# Directory where .desktop files are typically stored
desktop_dirs=(
	"/var/lib/flatpak/exports/share/applications"
	"/usr/share/applications"
	"/usr/local/share/applications"
	"$HOME/.local/share/applications"
)

# Check if a .desktop file exists for each app
for app in "${apps[@]}"; do
	for dir in "${desktop_dirs[@]}"; do
		if [ -f "$dir/$app" ]; then
			installed_apps+=("$app")
			break
		fi
	done
done

# Convert the array to a format suitable for gsettings
favorites_list=$(printf "'%s'," "${installed_apps[@]}")
favorites_list="[${favorites_list%,}]"

# Set the favorite apps
gsettings set org.gnome.shell favorite-apps "$favorites_list"
