#!/bin/bash

choice=$(gum choose {7..14} "<< Back" --height 11 --header "Choose your terminal font size")

if [[ $choice =~ ^[0-9]+$ ]]; then
	ghostty_config="$HOME/.config/ghostty/config"
	mkdir -p "$(dirname "$ghostty_config")"
	if [ ! -f "$ghostty_config" ]; then
		cp "$FORMA_PATH/configs/ghostty/config" "$ghostty_config"
	fi
	if grep -q "^font-size =" "$ghostty_config"; then
		sed -i "s/^font-size = .*/font-size = $choice/g" "$ghostty_config"
	else
		echo "font-size = $choice" >>"$ghostty_config"
	fi
	source $FORMA_PATH/bin/forma-sub/font-size.sh
else
	source $FORMA_PATH/bin/forma-sub/font.sh
fi
