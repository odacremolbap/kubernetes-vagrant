# Install kubernetes scheduler at master

Certificates
- kubeconfig providing secure apiserver client access and identity
  - encodes ca.crt
  - encodes scheduler.crt
  - encodes scheduler.key

```

###### INSTALL BINARIES
wget  https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kube-scheduler
chmod +x kube-scheduler
mv kube-scheduler /usr/local/bin/



###### COPY SCHEDULER CERTIFICATES TO FINAL LOCATION
cp ${WORKDIR}/assets/certs/scheduler/scheduler.key ${KUBERNETES_CONF_DIR}/scheduler
cp ${WORKDIR}/assets/certs/scheduler/scheduler.crt ${KUBERNETES_CONF_DIR}/scheduler



###### COPY KUBECONFIG
cp ${WORKDIR}/assets/master/scheduler.kubeconfig ${KUBERNETES_CONF_DIR}/scheduler/kubeconfig



###### CREATE SYSTEMD SCHEDULER UNIT
cat > ${WORKDIR}/assets/systemd/kube-scheduler.service <<EOF

[Unit]
Description=kube-scheduler
Documentation=https://kubernetes.io

[Service]
ExecStart=/usr/local/bin/kube-scheduler \\
  --leader-elect=true \\
  --kubeconfig=${KUBERNETES_CONF_DIR}/scheduler/kubeconfig \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF



###### START SYSTEMD CONTROLLER MANAGER UNIT
cp ${WORKDIR}/assets/systemd/kube-scheduler.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable kube-scheduler
systemctl restart kube-scheduler


cd


```
