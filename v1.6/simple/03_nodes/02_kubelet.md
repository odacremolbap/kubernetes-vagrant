# Install kubelet

Certificates
- kubeconfig providing secure apiserver client access and identity
  - encodes ca.crt
  - encodes <node>.crt
  - encodes <node>.key
- tls (ca, cert, key) providing HTTPS access.
  - ca.crt
  - <node>.crt
  - <node>.key

TODO: use `--client-ca-file` to validate requests

```

###### INSTALL BINARIES
wget https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubelet
chmod +x kubelet
mv kubelet /usr/local/bin/



###### COPY KUBELET CERTS AND KUBECONFIG
cp -a ${WORKDIR}/assets/nodes/${WORKER_NAME}/* ${KUBELET_CONF_DIR}
cp -a ${WORKDIR}/assets/nodes/${WORKER_NAME}/kubelet.kubeconfig ${KUBELET_CONF_DIR}/kubeconfig



###### CREATE SYSTEMD KUBELET UNIT
cat > ${WORKDIR}/assets/nodes/${WORKER_NAME}/kubelet.service <<EOF

[Unit]
Description=kubelet
Documentation=https://kubernetes.io

[Service]
ExecStart=/usr/local/bin/kubelet \\
--allow-privileged=true \\
--cluster-dns=${KUBERNETES_DNS_SERVICE} \\
--cluster-domain=cluster.local \\
--image-pull-progress-deadline=2m \\
--kubeconfig=${KUBELET_CONF_DIR}/kubeconfig \\
--network-plugin=cni \\
--register-node=true \\
--require-kubeconfig \\
--runtime-request-timeout=10m \\
--tls-cert-file=${KUBELET_CONF_DIR}/${WORKER_NAME}.crt \\
--tls-private-key-file=${KUBELET_CONF_DIR}/${WORKER_NAME}.key \\
--v=2


Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF



###### START SYSTEMD KUBELET UNIT
cp ${WORKDIR}/assets/nodes/${WORKER_NAME}/kubelet.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable kubelet
systemctl restart kubelet


cd


```
