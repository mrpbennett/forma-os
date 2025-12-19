#!/bin/bash

set_font() {
	local font_name=$1
	local url=$2
	local file_type=$3
	local file_name="${font_name/ Nerd Font/}"
	local ghostty_config="$HOME/.config/ghostty/config"

	if ! $(fc-list | grep -i "$font_name" >/dev/null); then
		cd /tmp
		wget -O "$file_name.zip" "$url"
		unzip "$file_name.zip" -d "$file_name"
		cp "$file_name"/*."$file_type" ~/.local/share/fonts
		rm -rf "$file_name.zip" "$file_name"
		fc-cache
		cd -
		clear
		source $FORMA_PATH/ascii.sh
	fi

	gsettings set org.gnome.desktop.interface monospace-font-name "$font_name 10"
	mkdir -p "$(dirname "$ghostty_config")"
	if [ ! -f "$ghostty_config" ]; then
		cp "$FORMA_PATH/configs/ghostty/config" "$ghostty_config"
	fi
	if grep -q "^font-family =" "$ghostty_config"; then
		sed -i "s/^font-family = .*/font-family = \"$font_name\"/g" "$ghostty_config"
	else
		echo "font-family = \"$font_name\"" >>"$ghostty_config"
	fi
	sed -i "s/\"editor.fontFamily\": \".*\"/\"editor.fontFamily\": \"$font_name\"/g" ~/.config/Code/User/settings.json
}

if [ "$#" -gt 1 ]; then
	choice=${!#}
else
	choice=$(gum choose "Cascadia Mono" "Fira Mono" "JetBrains Mono" "Meslo" "> Change size" "<< Back" --height 8 --header "Choose your programming font")
fi

case $choice in

"JetBrains Mono")
	set_font "JetBrainsMono Nerd Font" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" "ttf"
	;;
"> Change size")
	source $FORMA_PATH/bin/forma-sub/font-size.sh
	exit
	;;
esac

source $FORMA_PATH/bin/forma-sub/menu.sh
