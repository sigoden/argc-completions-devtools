# NEED-MANUALLY-SYNC
RELEASE="$(curl -sSL https://dl.k8s.io/release/stable.txt)"
curl -L --remote-name-all https://dl.k8s.io/release/${RELEASE}/bin/linux/amd64/kubeadm
chmod +x kubeadm
mv kubeadm ~/.local/bin/