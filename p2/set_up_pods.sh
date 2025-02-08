#! /bin/bash

alias k=kubectl
sudo systemctl stop firewalld
# sudo firewall-cmd --permanent --add-port=80/tcp
# sudo firewall-cmd --permanent --add-port=6443/tcp
# sudo firewall-cmd --reload
/usr/local/bin/kubectl apply -f /vagrant/configs/app-one.yaml
/usr/local/bin/kubectl apply -f /vagrant/configs/app-two.yaml
/usr/local/bin/kubectl apply -f /vagrant/configs/app-three.yaml
/usr/local/bin/kubectl apply -f /vagrant/configs/service-app-one.yaml
/usr/local/bin/kubectl apply -f /vagrant/configs/service-app-two.yaml
/usr/local/bin/kubectl apply -f /vagrant/configs/service-app-three.yaml
/usr/local/bin/kubectl apply -f /vagrant/configs/app-one-ingress.yaml
/usr/local/bin/kubectl apply -f /vagrant/configs/app-two-ingress.yaml
/usr/local/bin/kubectl apply -f /vagrant/configs/app-three-ingress.yaml

