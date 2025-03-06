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



# 🚀 Part 2: Host based Routing

Part 2 provisions a **single-node Kubernetes cluster (K3s)** on a **Vagrant-managed VirtualBox VM**. It deploys multiple applications, services, and Ingress rules using **Traefik** as the ingress controller.

## 📌 Overview

- **Provisioning**:
  - A **K3s master node** (`ehasaluS`) running on CentOS 9 Stream.
  - Firewall configuration and aliases for ease of use.
  - Automated deployment script (`set_up_pods.sh`) to apply Kubernetes resources.

## 🚀 How to Set Up

1. Start the Virtual Machine:

`vagrant up`

This sets up the K3s master node (ehasaluS).

Configures firewall rules.

Applies Kubernetes manifests via set_up_pods.sh.



2. Verify Kubernetes Cluster:

SSH into the VM:

`vagrant ssh ehasaluS`

Check the Kubernetes node:

`kubectl get nodes`

Expected output:
```
NAME         STATUS   ROLES                  AGE   VERSION
ehasaluS     Ready    control-plane,master   2m    v1.25.x
```


3. Verify Deployments:

`kubectl get deployments`

Expected output:
```
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
app-one     1/1     1            1           1m
app-two     3/3     3            3           1m
app-three   1/1     1            1           1m
```

4. Check Services:

`kubectl get services`

Expected output:
```
NAME        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
app-one     ClusterIP   10.43.45.12      <none>        80/TCP    1m
app-two     ClusterIP   10.43.78.34      <none>        80/TCP    1m
app-three   ClusterIP   10.43.23.56      <none>        80/TCP    1m
```

5. Test Ingress Routes:

Add the following entries to /etc/hosts:
```
192.168.56.110  app1.com
192.168.56.110  app2.com
192.168.56.110  app3.com
```
Open a browser and navigate to:

http://app1.com → Should display "Hello from app1."

http://app2.com → Should display "Hello from app2."

192.168.56.110 → Should display "Hello from app3." As default non-host route.

6. Destroy the VM:

`vagrant destroy -f`

# 🚀 Part3: Argo CD Deployment with K3d

This section of the project sets up **Argo CD** on a **K3d-managed Kubernetes cluster** and deploys applications using **GitOps** principles. 

## 📌 Overview

- **Creates a K3d cluster** named `iot` with exposed ports.
- **Installs Argo CD** in a dedicated Kubernetes namespace (`argocd`).
- **Configures Argo CD for external access** via a LoadBalancer service.
- **Deploys an application (`argocd-app`)** managed by Argo CD.
- **Automatically syncs Kubernetes manifests** from a Git repository.

## 🚀 Setup Instructions

### start.sh

1. Creates a **K3d cluster** named `iot` with necessary ports:
2. Installs ArgoCD
3. Exposes ArgoCD server and waits for it to be ready
4. Changes initial password to allow us to login through GUI
5. Deploys Application via ArgoCD

ArgoCD is available on port 8080 (I hope).

To test, change version of deployed application on public GitHub repository and wait for changes to apply on ArgoCD
Access application on port 8888

# 🚀 Bonus: Local GitLab CI/CD with Argo CD

This setup integrates **Argo CD** with a **self-hosted GitLab instance** to enable **GitOps-based application deployment**. It includes:
- **Local GitLab setup**
- **Argo CD configuration for GitLab integration**
- **CoreDNS adjustments for local domain resolution**
- **A test application deployment (`argocd-app-bonus.yaml`)**

---

## 📌 Overview

- **GitLab is self-hosted** inside the Kubernetes cluster.
- **Argo CD fetches manifests from the local GitLab instance**.
- **CoreDNS is configured to resolve `.local` domain names** for internal services.
- **A test app (`argocd-app-bonus`) is deployed using Argo CD**.

---

## 🚀 Setup Instructions

Run bonus.sh, which does stuff
