#!/bin/bash

# Clear the cluster
minikube delete

# Remove minikube directory from the system
rm -rf ~/.minikube

# Remove the minikube binary
sudo rm $(which minikube)

# Remove the .kube directory
rm -rf ~/.kube