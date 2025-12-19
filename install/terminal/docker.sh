#!/bin/bash

set -euo pipefail

# Docker Engine install for Fedora (incl. Fedora 43)
# Docs: https://docs.docker.com/engine/install/fedora/

sudo dnf remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine \
                  podman-docker || true

# Fedora 41+ uses dnf5; ensure the config-manager plugin is installed.
if ! dnf config-manager --help >/dev/null 2>&1; then
    sudo dnf install -y dnf5-plugins || sudo dnf install -y dnf-plugins-core
fi

sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo

sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Limit log size to avoid running out of disk
sudo mkdir -p /etc/docker
echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json >/dev/null

sudo systemctl enable --now docker

# Allow this user to run Docker commands without sudo.
# Note: you must log out/in (or run `newgrp docker`) for this to take effect.
sudo usermod -aG docker "${USER}"
