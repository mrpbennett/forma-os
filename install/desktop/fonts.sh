#!/bin/bash

mkdir -p ~/.local/share/fonts

cd /tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip JetBrainsMono.zip -d JetBrainsMonoFont
cp JetBrainsMonoFont/*.ttf ~/.local/share/fonts
rm -rf JetBrainsMono.zip JetBrainsMonoFont

fc-cache
cd -
