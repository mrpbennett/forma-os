#!/bin/bash

set -e

# Improved error handling for boot script
trap 'echo "forma boot failed! Check your internet connection and try again."' ERR

ascii_art='

  ______                       __   ______    ______
 /      \                     |  \ /      \  /      \
|  $$$$$$\ __    __   ______   \$$|  $$$$$$\|  $$$$$$\
| $$__| $$|  \  |  \ /      \ |  \| $$  | $$| $$___\$$
| $$    $$| $$  | $$|  $$$$$$\| $$| $$  | $$ \$$    \
| $$$$$$$$| $$  | $$| $$   \$$| $$| $$  | $$ _\$$$$$$\
| $$  | $$| $$__/ $$| $$      | $$| $$__/ $$|  \__| $$
| $$  | $$ \$$    $$| $$      | $$ \$$    $$ \$$    $$
 \$$   \$$  \$$$$$$  \$$       \$$  \$$$$$$   \$$$$$$


'

echo -e "$ascii_art"
echo "=> forma is for fresh Fedora 39+ installations only!"
echo -e "\nBegin installation (or abort with ctrl+c)..."

echo "Updating system packages..."
if ! sudo dnf update -y; then
    echo "Failed to update system packages"
    exit 1
fi

echo "Cloning forma..."
rm -rf ~/.local/share/forma
if ! git clone https://github.com/mrpbennett/forma.git ~/.local/share/forma; then
    echo "Failed to clone forma repository"
    exit 1
fi
if [[ $forma_REF != "master" ]]; then
	cd ~/.local/share/forma
	git fetch origin "${forma_REF:-stable}" && git checkout "${forma_REF:-stable}"
	cd -
fi

echo "Installation starting..."
if ! source ~/.local/share/forma/install.sh; then
    echo "Installation failed! Check the error messages above."
    exit 1
fi
