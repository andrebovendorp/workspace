# Kubernetes

## Overview

Welcome to my personal Kubernetes cluster setup, deployed in my HomeLab. This project leverages `kubeadm` for cluster initialization and configuration. The setup includes an external ETCD cluster configuration, ensuring high availability and reliability for the Kubernetes control plane. This guide will walk you through the steps I followed to set up the cluster, including the installation of necessary tools, network configuration, and the deployment of ETCD and control plane nodes using Ansible.

## Introduction

This is my personal Kubernetes cluster deployed in my HomeLab. I'm using kubeadm to deploy the cluster.

## Prerequisites

Before you begin, ensure you have the following:
- VirtualBox installed
- SSH configured
- Basic understanding of Ansible and Kubernetes

## Steps to Follow

### 1. Install VirtualBox
Download and install VirtualBox from the official website.

### 2. Setup SSH Config
Configure SSH to allow passwordless login between your nodes.

### 3. Setup Network on VM
Ensure your VMs are networked correctly to communicate with each other and the host.

### 4. Setup Base Image with SSH Key
Create a base VM image with your SSH key installed for easy duplication.

### 5. Update inventory.ini file
Update the inventory.ini file with the IP addresses and hostname of your nodes.

## Steps to follow
- [x] Install VirtualBox
- [x] Setup SSH config
- [x] Setup Network on VM
- [x] Setup base image with SSH key
- [x] Install kubeadm, kubelet, and kubectl
- [x] Verify networking between nodes and host
- [x] Setup networking with internet access
- [x] Save image and duplicate VMs
  - [x] 3 etcd nodes
  - [x] 3 control plane nodes
  - [x] 3 worker nodes
- [x] Setup ETCD
  - [x] Setup Ansible
- [x] Setup Control Plane
  - [x] Setup Ansible
  - [ ] Automate join command
  - [x] Setup CNI
  - [x] Setup DNS
- [ ] Setup Worker Nodes (Not developed but should be just joining the cluster as easy as it sounds.)


## Configuration

```yaml
network:
  nodes:
    CIDR: 10.10.0.0/16
  kubernetes:
    podCIDR: 10.100.0.0/16
    serviceCIDR: 10.200.0.0/16
nodes:
  etcd01:
    ip: 10.10.1.1
  etcd02:
    ip: 10.10.1.2
  etcd03:
    ip: 10.10.1.3
  apiserver01:
    ip: 10.10.2.1
  apiserver02:
    ip: 10.10.2.2
  apiserver03:
    ip: 10.10.2.3
  w01:
    ip: 10.10.3.1
  w02:
    ip: 10.10.3.2
  w03:
    ip: 10.10.3.3
```

## Additional Information

This setup is intended for educational purposes and to gain hands-on experience with Kubernetes in a controlled environment. The configuration and steps provided are tailored to a HomeLab setup and may require adjustments for different environments.
