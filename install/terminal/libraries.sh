#!/bin/bash

sudo dnf install -y \
    @development-tools pkg-config autoconf pipx bat \
    openssl-devel readline-devel libyaml-devel \
    ImageMagick \
    --skip-unavailable


curl https://sh.rustup.rs -sSf | sh -s -- -y && . "$HOME/.cargo/env"
