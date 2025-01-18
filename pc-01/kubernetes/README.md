# Kubernetes

## Introduction

This is my personal Kubernetes cluster deployed in my HomeLab. I'm using kubeadm to deploy the cluster.

### Steps to follow
- [x] Install VirtualBox
- [x] Setup SSH config
- [x] Setup Network on vm
- [x] Setup base image with SSH key
- [x] Install kubeadm, kubelet and kubectl
- [x] Check Networking is working between nodes and Host
- [ ] Setup Networking with Internet
- [x] Save image and duplicate vms
- - [x] 3 etcd nodes
- - [x] 3 control plane nodes
- - [x] 3 worker nodes
- [ ] Setup Ansible # ongoing
- [ ] Setup ETCD
- [ ] Setup Control Plane
- - [ ] Setup CNI
- - [ ] Setup DNS
- [ ] Setup Worker Nodes


## Config

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
