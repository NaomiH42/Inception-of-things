# Inception-of-Things

This project leverages lightweight Kubernetes and automation tools to simplify development, testing, and deployment. Below are brief explanations of the core technologies used.

## 📌 Technologies Explained

### 🐳 K3s: Lightweight Kubernetes
[K3s](https://k3s.io/) is a lightweight, fully compliant Kubernetes distribution designed for edge computing, IoT, and CI/CD environments. It simplifies Kubernetes by reducing dependencies and optimizing resource usage, making it ideal for development and small-scale production.

### 📦 Vagrant: Virtual Machine Automation
[Vagrant](https://www.vagrantup.com/) is a tool for managing virtual machines in a repeatable and automated way. It allows developers to create, configure, and share development environments using a simple configuration file (`Vagrantfile`), making it easy to ensure consistency across different machines.

### 🚀 K3d: Kubernetes in Docker
[K3d](https://k3d.io/) is a lightweight wrapper for running K3s inside Docker. It enables fast and simple local Kubernetes cluster deployment without the need for a full virtual machine, making it a great tool for testing Kubernetes-based applications.

### 🔄 Continuous Integration (CI) & Argo CD
- **Continuous Integration (CI)** is a DevOps practice where code changes are automatically tested and integrated into the main branch using tools like GitHub Actions, Jenkins, or GitLab CI/CD. This helps detect issues early and speeds up development.
- **Argo CD** is a declarative, GitOps continuous delivery tool for Kubernetes. It monitors Git repositories for configuration changes and automatically synchronizes them with the Kubernetes cluster, ensuring that deployments stay consistent with the desired state.


# 🚀 Part 1: K3s Cluster Setup with Vagrant

Part 1 sets up a **lightweight Kubernetes cluster (K3s) using Vagrant** and **VirtualBox**. It provisions one **K3s server node** and one **K3s worker node** on **CentOS 9 Stream** virtual machines.

## 📌 What This Vagrantfile Does

- Creates **two virtual machines**:
  - **`ehasaluS`** (Master/Server) - IP: `192.168.56.110`
  - **`ehasaluSW`** (Worker) - IP: `192.168.56.111`
- Installs **K3s** on the server (`ehasaluS`) and sets up the cluster.
- Configures a **firewall rule** to allow Kubernetes API (`6443/tcp`).
- Saves the **K3s server token** to `/vagrant/server_token.txt` for the worker node to join.
- Installs **K3s on the worker (`ehasaluSW`)** and joins it to the cluster.

## 🚀 How to Set Up

1. Start the VMs:

`vagrant up`

This will provision the server node (ehasaluS) first.

The worker node (ehasaluSW) will then join the cluster.



2. Access the Kubernetes Cluster:

SSH into the server node:

`vagrant ssh ehasaluS`

Verify K3s is running:

`kubectl get nodes`

You should see output similar to:
```
NAME         STATUS   ROLES                  AGE   VERSION
ehasaluS     Ready    control-plane,master   2m    v1.25.x
ehasaluSW    Ready    <none>                 1m    v1.25.x
```
SSH into worker node:

`vagrant ssh ehasaluSW`

Verify interface is configured with correct IP:

`ifconfig eth1`


3. Destroy the VMs (removes all data):

`vagrant destroy -f`
