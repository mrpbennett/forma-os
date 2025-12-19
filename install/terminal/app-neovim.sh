#!/bin/bash

cd /tmp
wget -O nvim.tar.gz "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz"
tar -xf nvim.tar.gz
sudo install nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
sudo cp -R nvim-linux-x86_64/lib /usr/local/
sudo cp -R nvim-linux-x86_64/share /usr/local/
rm -rf nvim-linux-x86_64 nvim.tar.gz
cd -

# Install luarocks and tree-sitter-cli to resolve lazyvim :checkhealth warnings
sudo dnf install -y luarocks
if ! sudo dnf install -y tree-sitter-cli; then
    if command -v cargo >/dev/null 2>&1; then
        cargo install tree-sitter-cli --locked --force || true
    else
        echo "Warning: tree-sitter-cli package not available and cargo not found; skipping tree-sitter-cli install"
    fi
fi

# Only attempt to set configuration if Neovim has never been run
if [ ! -d "$HOME/.config/nvim" ]; then
    cp -R ~/.local/share/forma/configs/neovim ~/.config/nvim
fi
