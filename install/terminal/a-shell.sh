#!/bin/bash

# Install zsh with error handling
echo "Installing zsh..."
if ! sudo dnf install zsh -y; then
    echo "Failed to install zsh"
    exit 1
fi

# make zsh default
echo "Setting zsh as default shell..."
ZSH_PATH=$(which zsh)
if [ -z "$ZSH_PATH" ]; then
    echo "Failed to find zsh path"
    exit 1
fi

if ! sudo chsh -s "$ZSH_PATH" $USER; then
    echo "Warning: Failed to set zsh as default shell"
fi

# Install oh-my-zsh
echo "Installing oh-my-zsh..."
if ! sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
    echo "Failed to install oh-my-zsh"
    exit 1
fi

# zsh syntax highlighting and auto suggestions
echo "Installing zsh plugins..."
if ! git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting; then
    echo "Warning: Failed to install zsh-syntax-highlighting plugin"
fi

if ! git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions; then
    echo "Warning: Failed to install zsh-autosuggestions plugin"
fi

# Configure the zsh shell using forma defaults
echo "Configuring zsh with forma defaults..."
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak
if ! cp ~/.local/share/forma/configs/zshrc ~/.zshrc; then
    echo "Warning: Failed to copy zshrc configuration"
fi

# Load the PATH for use later in the installers
if ! source ~/.local/share/forma/defaults/zsh/shell; then
    echo "Warning: Failed to load shell defaults"
fi

# Configure the inputrc using forma defaults
[ -f ~/.inputrc ] && mv ~/.inputrc ~/.inputrc.bak
if ! cp ~/.local/share/forma/configs/inputrc ~/.inputrc; then
    echo "Warning: Failed to copy inputrc configuration"
fi

echo "Shell configuration complete!"
