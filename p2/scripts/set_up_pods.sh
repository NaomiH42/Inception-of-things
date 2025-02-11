#! /bin/bash

echo alias k=kubectl >> /home/vagrant/.bashrc
sudo systemctl stop firewalld
# sudo firewall-cmd --permanent --add-port=80/tcp
# sudo firewall-cmd --permanent --add-port=6443/tcp
# sudo firewall-cmd --reload
/usr/local/bin/kubectl apply -f /vagrant/confs/app-one.yaml
/usr/local/bin/kubectl apply -f /vagrant/confs/app-two.yaml
/usr/local/bin/kubectl apply -f /vagrant/confs/app-three.yaml
/usr/local/bin/kubectl apply -f /vagrant/confs/service-app-one.yaml
/usr/local/bin/kubectl apply -f /vagrant/confs/service-app-two.yaml
/usr/local/bin/kubectl apply -f /vagrant/confs/service-app-three.yaml
/usr/local/bin/kubectl apply -f /vagrant/confs/app-one-ingress.yaml
/usr/local/bin/kubectl apply -f /vagrant/confs/app-two-ingress.yaml
/usr/local/bin/kubectl apply -f /vagrant/confs/app-three-ingress.yaml

