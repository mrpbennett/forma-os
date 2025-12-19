#!/bin/bash

# Set common git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global pull.rebase true

# Set identification from install inputs
if [[ -n "${FORMA_USER_NAME//[[:space:]]/}" ]]; then
  git config --global user.name "$FORMA_USER_NAME"
fi

if [[ -n "${FORMA_USER_EMAIL//[[:space:]]/}" ]]; then
  git config --global user.email "$FORMA_USER_EMAIL"
fi
