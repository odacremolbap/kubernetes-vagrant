# Install kubernetes apiserver

Certificates
- tls (ca, cert, key) providing HTTPS access.
  - ca.crt
  - server.crt
  - server.key
- kubelet (ca, cert, key) to validate nodes
  - ca.crt
  - server.crt
  - server.key
- client-ca-file (ca) to validate client certs
  - ca.crt
- service-account-key-file (cert) to verify service acccount tokens
  - ca.crt
- etcd (ca, cert, key) secure etcd client.
  - ca.crt
  - etcd-client.crt
  - etcd-client.key


```

###### INSTALL BINARY
wget https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kube-apiserver
chmod +x kube-apiserver
sudo mv kube-apiserver /usr/local/bin/



###### COPY ETCD CLIENT AND APISERVER CERTS
cp ${WORKDIR}/assets/certs/etcd-client/etcd-client.crt ${KUBERNETES_CONF_DIR}/etcd-client/
cp ${WORKDIR}/assets/certs/etcd-client/etcd-client.key ${KUBERNETES_CONF_DIR}/etcd-client/
cp ${WORKDIR}/assets/certs/apiserver/server.key ${KUBERNETES_CONF_DIR}/apiserver/
cp ${WORKDIR}/assets/certs/apiserver/server.crt ${KUBERNETES_CONF_DIR}/apiserver/



###### CREATE SYSTEMD APISERVER UNIT
cat > ${WORKDIR}/assets/systemd/kube-apiserver.service <<EOF

[Unit]
Description=kube-apiserver
Documentation=https://kubernetes.io

[Service]
ExecStart=/usr/local/bin/kube-apiserver \\
  --admission-control=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \\
  --advertise-address=${APISERVER_IP1} \\
  --kubelet-preferred-address-types=InternalIP \\
  --allow-privileged=true \\
  --apiserver-count=1 \\
  --audit-log-maxage=30 \\
  --audit-log-maxbackup=3 \\
  --audit-log-maxsize=100 \\
  --audit-log-path=/var/log/audit.log \\
  --authorization-mode=RBAC \\
  --bind-address=0.0.0.0 \\
  --client-ca-file=${KUBERNETES_CONF_DIR}/ca/ca.crt \\
  --enable-swagger-ui=true \\
  --etcd-cafile=${KUBERNETES_CONF_DIR}/ca/ca.crt \\
  --etcd-certfile=${KUBERNETES_CONF_DIR}/etcd-client/etcd-client.crt \\
  --etcd-keyfile=${KUBERNETES_CONF_DIR}/etcd-client/etcd-client.key \\
  --etcd-servers=https://${APISERVER_IP1}:2379 \\
  --event-ttl=1h \\
  --insecure-port=0 \\
  --kubelet-certificate-authority=${KUBERNETES_CONF_DIR}/ca/ca.crt \\
  --kubelet-client-certificate=${KUBERNETES_CONF_DIR}/apiserver/server.crt \\
  --kubelet-client-key=${KUBERNETES_CONF_DIR}/apiserver/server.key \\
  --kubelet-https=true \\
  --runtime-config=rbac.authorization.k8s.io/v1alpha1 \\
  --service-account-key-file=${KUBERNETES_CONF_DIR}/ca/ca.crt \\
  --service-cluster-ip-range=${KUBERNETES_SERVICE_CIDR} \\
  --service-node-port-range=30000-32767 \\
  --tls-ca-file=${KUBERNETES_CONF_DIR}/ca/ca.crt \\
  --tls-cert-file=${KUBERNETES_CONF_DIR}/apiserver/server.crt \\
  --tls-private-key-file=${KUBERNETES_CONF_DIR}/apiserver/server.key \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF



###### START SYSTEMD APISERVER UNIT
cp ${WORKDIR}/assets/systemd/kube-apiserver.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable kube-apiserver
systemctl restart kube-apiserver


cd


```
