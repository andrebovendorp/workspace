#!/bin/bash
echo "Upgrading $1"
helm upgrade --install $1 --namespace $1 --create-namespace $1/ -f $1/values.yaml