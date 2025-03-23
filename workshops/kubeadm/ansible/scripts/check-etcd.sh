#!/bin/bash

ETCD1="192.168.1.11"
ETCD2="192.168.1.12"
ETCD3="192.168.1.4"

ETCDCTL_API=3 etcdctl \
--cert /tmp/etcd_certs/ca/peer.crt \
--key /tmp/etcd_certs/ca/peer.key \
--cacert /tmp/etcd_certs/ca/ca.crt \
--endpoints https://$ETCD1:2379,https://$ETCD2:2379,https://$ETCD3:2379  endpoint health
