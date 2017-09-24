# Install etcd at master

```

###### INSTALL BINARIES
wget https://github.com/coreos/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz -P /tmp/
tar -xvf /tmp/etcd-${ETCD_VERSION}-linux-amd64.tar.gz -C /tmp/
sudo mv /tmp/etcd-${ETCD_VERSION}-linux-amd64/etcd /tmp/etcd-${ETCD_VERSION}-linux-amd64/etcdctl /usr/local/bin/



###### COPY CA CERTIFICATE TO KUBERNETES DEFINITIVE LOCATION
cp ${WORKDIR}/assets/certs/ca/ca.crt ${KUBERNETES_CONF_DIR}/ca/
cp ${WORKDIR}/assets/certs/ca/ca.key ${KUBERNETES_CONF_DIR}/ca/


###### COPY ETCD SERVER CERTIFICATES
cp ${WORKDIR}/assets/certs/etcd/etcd.key ${ETCD_DIR}/config/
cp ${WORKDIR}/assets/certs/etcd/etcd.crt ${ETCD_DIR}/config/



###### CREATE SYSTEMD UNIT
cat > ${WORKDIR}/assets/systemd/etcd.service <<EOF
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
Type=notify
ExecStart=/usr/local/bin/etcd \\
  --name master1 \\
  --cert-file=${ETCD_DIR}/config/etcd.crt \\
  --key-file=${ETCD_DIR}/config/etcd.key \\
  --peer-cert-file=${ETCD_DIR}/config/etcd.crt \\
  --peer-key-file=${ETCD_DIR}/config/etcd.key \\
  --trusted-ca-file=${KUBERNETES_CONF_DIR}/ca/ca.crt \\
  --peer-trusted-ca-file=${KUBERNETES_CONF_DIR}/ca/ca.crt \\
  --peer-client-cert-auth \\
  --client-cert-auth \\
  --initial-advertise-peer-urls https://${APISERVER_IP1}:2380 \\
  --listen-peer-urls https://${APISERVER_IP1}:2380 \\
  --listen-client-urls https://${APISERVER_IP1}:2379 \\
  --advertise-client-urls https://${APISERVER_IP1}:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster master1=https://${APISERVER_IP1}:2380 \\
  --initial-cluster-state new \\
  --data-dir=${ETCD_DIR}/data
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF



###### START SYSTEMD ETCD UNIT
cp ${WORKDIR}/assets/systemd/etcd.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable etcd
systemctl restart etcd

cd


```
