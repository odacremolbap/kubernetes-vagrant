# Install kubelet

Certificates
- kubeconfig providing secure apiserver client access and identity
  - encodes ca.crt
  - encodes proxy.crt
  - encodes proxy.key

TODO: use a different cert key pair for each node


```

###### INSTALL BINARIES

wget https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kube-proxy
chmod +x kube-proxy
mv kube-proxy /usr/local/bin/



###### COPY PROXY CERTS AND KUBECONFIG
${KUBERNETES_CONF_DIR}/controller-manager
cp -a ${WORKDIR}/assets/certs/proxy/* ${KUBERNETES_CONF_DIR}/proxy/
cp -a ${WORKDIR}/assets/nodes/${WORKER_NAME}/proxy.kubeconfig ${KUBERNETES_CONF_DIR}/proxy/kubeconfig




###### CREATE SYSTEMD PROXY UNIT
cat > ${WORKDIR}/assets/nodes/${WORKER_NAME}/kube-proxy.service <<EOF

[Unit]
Description=proxy
Documentation=https://kubernetes.io

[Service]
ExecStart=/usr/local/bin/kube-proxy \\
  --cluster-cidr=${KUBERNETES_POD_CIDR} \\
  --kubeconfig=${KUBERNETES_CONF_DIR}/proxy/kubeconfig \\
  --proxy-mode=iptables \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF



###### START SYSTEMD PROXY UNIT
cp ${WORKDIR}/assets/nodes/${WORKER_NAME}/kube-proxy.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable kube-proxy
systemctl restart kube-proxy


cd



```
