#!/bin/bash

curl https://mise.run/zsh | sh
# Installs mise and adds activation to ~/.zshrc

# Sets my languages
mise use --global node@lts
mise use --global go@latest
mise use --global python@latest
mise use --global java@latest
