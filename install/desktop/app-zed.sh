#!/bin/bash

curl -f https://zed.dev/install.sh | sh

cargo install television

# use the configs from forma
rm -rf ~/.config/zed
cp -R ~/.local/share/forma/configs/zed ~/.config/zed
