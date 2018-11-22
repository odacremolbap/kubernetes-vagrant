kubeadm init --apiserver-advertise-address 0.0.0.0 \
  --apiserver-bind-port 6443 \
  --apiserver-cert-extra-sans 192.168.56.20,10.0.2.15 \
  --cert-dir /etc/kubernetes/pki \
  --cri-socket /var/run/dockershim.sock \
  --feature-gates CoreDNS=true \
  --kubernetes-version v1.11.0 \
  --node-name master-1 \
  --pod-network-cidr

  
