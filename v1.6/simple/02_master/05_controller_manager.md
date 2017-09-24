# Install kubernetes controller manager

Certificates
- kubeconfig providing secure apiserver client access and identity
  - encodes ca.crt
  - encodes cm.crt
  - encodes cm.key
- service account generated tokens
  - ca.crt (as root ca file included)
  - ca.crt (as signing cert)
  - ca.key (as signing key)


```

###### INSTALL BINARIES
wget  https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kube-controller-manager
chmod +x kube-controller-manager
sudo mv kube-controller-manager /usr/local/bin/



###### COPY CM CERTIFICATES TO FINAL LOCATION
cp ${WORKDIR}/assets/certs/controller-manager/cm.key ${KUBERNETES_CONF_DIR}/controller-manager
cp ${WORKDIR}/assets/certs/controller-manager/cm.crt ${KUBERNETES_CONF_DIR}/controller-manager



###### COPY KUBECONFIG
cp ${WORKDIR}/assets/master/controller-manager.kubeconfig ${KUBERNETES_CONF_DIR}/controller-manager/kubeconfig

###### CREATE SYSTEMD CM UNIT
cat > ${WORKDIR}/assets/systemd/kube-controller-manager.service <<EOF

[Unit]
Description=kube-controller-manager
Documentation=https://kubernetes.io

[Service]
ExecStart=/usr/local/bin/kube-controller-manager \\
  --address=0.0.0.0 \\
  --allocate-node-cidrs=true \\
  --cluster-cidr=${KUBERNETES_POD_CIDR} \\ \\
  --service-cluster-ip-range=${KUBERNETES_SERVICE_CIDR} \\ \\
  --cluster-name=kubernetes-vagrant \\
  --configure-cloud-routes=false \\
  --cluster-signing-cert-file=${KUBERNETES_CONF_DIR}/ca/ca.crt \\
  --cluster-signing-key-file=${KUBERNETES_CONF_DIR}/ca/ca.key \\
  --leader-elect=true \\
  --kubeconfig=${KUBERNETES_CONF_DIR}/controller-manager/kubeconfig \\
  --root-ca-file=${KUBERNETES_CONF_DIR}/ca/ca.crt \\
  --service-account-private-key-file=${KUBERNETES_CONF_DIR}/ca/ca.key \\
  --use-service-account-credentials=true \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF



###### START SYSTEMD CONTROLLER MANAGER UNIT
cp ${WORKDIR}/assets/systemd/kube-controller-manager.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable kube-controller-manager
systemctl restart kube-controller-manager


cd


```
