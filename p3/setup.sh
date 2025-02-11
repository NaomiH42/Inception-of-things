# install docker
# Add Docker's official GPG key:
#!/bin/bash

BASHRC="$HOME/.bashrc"
ALIAS_LINE="alias k=kubectl"

# Check if the alias is already present in .bashrc
if grep -Fxq "$ALIAS_LINE" "$BASHRC"; then
    echo "Alias already exists in $BASHRC"
else
    echo "$ALIAS_LINE" >> "$BASHRC"
    echo "Alias added to $BASHRC. Please run 'source ~/.bashrc' to apply the changes."
fi

sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# install argocd cli
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

#install k3d
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

sudo usermod -aG docker ehasalu
sudo reboot
