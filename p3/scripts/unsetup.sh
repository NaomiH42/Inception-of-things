#!/bin/bash
set -e

echo "Starting uninstallation process..."

### 1. Remove the alias from .bashrc

BASHRC="$HOME/.bashrc"
ALIAS_LINE="alias k=kubectl"

if grep -Fxq "$ALIAS_LINE" "$BASHRC"; then
    echo "Removing alias from $BASHRC"
    # Use sed to delete the exact line
    sed -i "\~$ALIAS_LINE~d" "$BASHRC"
else
    echo "Alias not found in $BASHRC"
fi

### 2. Uninstall Docker packages

echo "Uninstalling Docker packages..."
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo apt-get autoremove -y

### 3. Remove Docker repository configuration and keyring

DOCKER_LIST="/etc/apt/sources.list.d/docker.list"
DOCKER_KEYRING="/etc/apt/keyrings/docker.asc"

if [ -f "$DOCKER_LIST" ]; then
    echo "Removing Docker repository file: $DOCKER_LIST"
    sudo rm "$DOCKER_LIST"
else
    echo "Docker repository file not found: $DOCKER_LIST"
fi

if [ -f "$DOCKER_KEYRING" ]; then
    echo "Removing Docker keyring: $DOCKER_KEYRING"
    sudo rm "$DOCKER_KEYRING"
else
    echo "Docker keyring not found: $DOCKER_KEYRING"
fi

### 4. Remove kubectl binary

if [ -f /usr/local/bin/kubectl ]; then
    echo "Removing kubectl from /usr/local/bin"
    sudo rm /usr/local/bin/kubectl
else
    echo "kubectl not found in /usr/local/bin"
fi

### 5. Remove ArgoCD CLI binary

if [ -f /usr/local/bin/argocd ]; then
    echo "Removing ArgoCD CLI from /usr/local/bin"
    sudo rm /usr/local/bin/argocd
else
    echo "ArgoCD CLI not found in /usr/local/bin"
fi

### 6. Remove k3d binary

if [ -f /usr/local/bin/k3d ]; then
    echo "Removing k3d from /usr/local/bin"
    sudo rm /usr/local/bin/k3d
else
    echo "k3d not found in /usr/local/bin"
fi

echo "Uninstallation complete. Please restart your terminal session for changes to take effect."
