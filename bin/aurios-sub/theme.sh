#!/bin/bash

THEME_NAMES=("Catppuccin")
THEME=$(gum choose "${THEME_NAMES[@]}" "<< Back" --header "Choose your theme" --height 4 | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')

if [ -n "$THEME" ] && [ "$THEME" != "<<-back" ]; then
  cp $FORMA_PATH/themes/$THEME/zellij.kdl ~/.config/zellij/themes/$THEME.kdl
  sed -i "s/theme \".*\"/theme \"$THEME\"/g" ~/.config/zellij/config.kdl
  if [ -d "$HOME/.config/nvim" ]; then
    cp $FORMA_PATH/themes/$THEME/neovim.lua ~/.config/nvim/lua/plugins/theme.lua
  fi

  if [ -f "$FORMA_PATH/themes/$THEME/btop.theme" ]; then
    cp $FORMA_PATH/themes/$THEME/btop.theme ~/.config/btop/themes/$THEME.theme
    sed -i "s/color_theme = \".*\"/color_theme = \"$THEME\"/g" ~/.config/btop/btop.conf
  else
    sed -i "s/color_theme = \".*\"/color_theme = \"Default\"/g" ~/.config/btop/btop.conf
  fi

  source $FORMA_PATH/themes/$THEME/gnome.sh
  source $FORMA_PATH/themes/$THEME/tophat.sh
  source $FORMA_PATH/themes/$THEME/vscode.sh

  # Forgo setting the Chrome theme until we might find a less disruptive way of doing it.
  # Having to quit Chrome, and all Chrome-based apps, is too much of an inposition.
  # source $FORMA_PATH/themes/$THEME/chrome.sh
fi

source $FORMA_PATH/bin/forma-sub/menu.sh
