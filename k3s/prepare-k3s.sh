#!/bin/bash

# Bootstrapping K3s
echo ">>>>> Bootstrapping K3s"

# Copy crictl configuration - K3s uses crictl (containerd) for container management
sudo cp crictl.yaml /etc

# Setup K3s without additional controllers (we will do it all by ourselves)
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable traefik,metrics-server --disable-helm-controller --write-kubeconfig-mode 644 --tls-san 127.0.0.1" sh -

# Switch to k3s kubeconfig context
mkdir -p ~/.kube
cp /etc/rancher/k3s/k3s.yaml ~/.kube/k3s.yaml
chmod 600 ~/.kube/k3s.yaml
export KUBECONFIG=~/.kube/k3s.yaml

# Configure K3s to use external Traefik once it is available
cat <<EOF | sudo tee /etc/rancher/k3s/config.yaml
# Minimal configuration for K3s
# All custom settings are already applied via the INSTALL_K3S_EXEC flag.
EOF

# K3s ready
echo "<<<<< K3s ready."
