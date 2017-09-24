# Build certificates

```

###### CA root
cd ${WORKDIR}/assets/certs/ca
openssl genrsa -out ./ca.key 2048
openssl req -x509 -new -nodes -key ./ca.key -days 3650 -out ./ca.crt -subj "/CN=spctest"



###### API server
cd ${WORKDIR}/assets/certs/apiserver
cat <<EOF > server.conf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
IP.1 = ${APISERVER_IP1}
IP.2 = 127.0.0.1
IP.3 = 10.3.0.1
EOF

openssl genrsa -out ./server.key 2048
openssl req -new -key ./server.key -out ./server.csr -subj "/CN=server-test" -config server.conf
openssl x509 -req -in ./server.csr \
  -CA ${WORKDIR}/assets/certs/ca/ca.crt \
  -CAkey ${WORKDIR}/assets/certs/ca/ca.key \
  -CAcreateserial -out ./server.crt \
  -days 3650 -extensions v3_req -extfile server.conf

# (optional) Clean
rm server.csr server.conf



###### Controller Manager
cd ${WORKDIR}/assets/certs/controller-manager

openssl genrsa -out ./cm.key 2048
openssl req -new -key ./cm.key -out ./cm.csr -subj "/CN=system:kube-controller-manager"
openssl x509 -req -in ./cm.csr \
  -CA ${WORKDIR}/assets/certs/ca/ca.crt \
  -CAkey ${WORKDIR}/assets/certs/ca/ca.key \
  -CAcreateserial -out ./cm.crt -days 3650

# (optional) Clean
rm cm.csr



###### Scheduler
cd ${WORKDIR}/assets/certs/scheduler

openssl genrsa -out ./scheduler.key 2048
openssl req -new -key ./scheduler.key -out ./scheduler.csr -subj "/CN=system:kube-scheduler"
openssl x509 -req -in ./scheduler.csr \
  -CA ${WORKDIR}/assets/certs/ca/ca.crt \
  -CAkey ${WORKDIR}/assets/certs/ca/ca.key \
  -CAcreateserial -out ./scheduler.crt -days 3650

# (optional) Clean
rm scheduler.csr



###### Etcd server
cd ${WORKDIR}/assets/certs/etcd
cat <<EOF > etcd.conf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = master1
DNS.2 = localhost
IP.1 = ${APISERVER_IP1}
IP.2 = 127.0.0.1
EOF

openssl genrsa -out ./etcd.key 2048
openssl req -new -key ./etcd.key -out ./etcd.csr -subj "/CN=etcd-test" -config etcd.conf
openssl x509 -req -in ./etcd.csr \
  -CA ${WORKDIR}/assets/certs/ca/ca.crt \
  -CAkey ${WORKDIR}/assets/certs/ca/ca.key \
  -CAcreateserial -out ./etcd.crt \
  -days 3650 -extensions v3_req -extfile etcd.conf

# (optional) Clean
rm etcd.csr etcd.conf



###### Etcd client
cd ${WORKDIR}/assets/certs/etcd-client

openssl genrsa -out ./etcd-client.key 2048
openssl req -new -key ./etcd-client.key -out ./etcd-client.csr -subj "/CN=etcd-client-test"
openssl x509 -req -in ./etcd-client.csr \
  -CA ${WORKDIR}/assets/certs/ca/ca.crt \
  -CAkey ${WORKDIR}/assets/certs/ca/ca.key \
  -CAcreateserial -out ./etcd-client.crt \
  -days 3650

# (optional) Clean
rm etcd-client.csr etcd-client.conf



###### Kubelet master
cd ${WORKDIR}/assets/nodes/master1

cat <<EOF > master.conf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kube-01
IP.1 = ${APISERVER_IP1}
IP.2 = 10.0.2.15
EOF

openssl genrsa -out ./master1.key 2048
openssl req -new -key ./master1.key -out ./master.csr -subj "/CN=system:nodes:master/O=system:nodes" -config master.conf
openssl x509 -req -in ./master.csr \
  -CA ${WORKDIR}/assets/certs/ca/ca.crt \
  -CAkey ${WORKDIR}/assets/certs/ca/ca.key \
  -CAcreateserial -out ./master1.crt \
  -days 3650 -extensions v3_req -extfile master.conf

# (optional) Clean
rm master.csr master.conf



###### Kubelet worker1
cd ${WORKDIR}/assets/nodes/worker1

cat <<EOF > worker1.conf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kube-01
IP.1 = ${WORKER1_IP1}
IP.2 = 10.0.2.15
EOF

openssl genrsa -out ./worker1.key 2048
openssl req -new -key ./worker1.key -out ./worker1.csr -subj "/CN=system:nodes:worker1/O=system:nodes" -config worker1.conf
openssl x509 -req -in ./worker1.csr \
  -CA ${WORKDIR}/assets/certs/ca/ca.crt \
  -CAkey ${WORKDIR}/assets/certs/ca/ca.key \
  -CAcreateserial -out ./worker1.crt \
  -days 3650 -extensions v3_req -extfile worker1.conf

# (optional) Clean
rm worker1.csr worker1.conf



###### Kubelet worker2
cd ${WORKDIR}/assets/nodes/worker2

cat <<EOF > worker2.conf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kube-01
IP.1 = ${WORKER2_IP1}
IP.2 = 10.0.2.15
EOF

openssl genrsa -out ./worker2.key 2048
openssl req -new -key ./worker2.key -out ./worker2.csr -subj "/CN=system:nodes:worker2/O=system:nodes" -config worker2.conf
openssl x509 -req -in ./worker2.csr \
  -CA ${WORKDIR}/assets/certs/ca/ca.crt \
  -CAkey ${WORKDIR}/assets/certs/ca/ca.key \
  -CAcreateserial -out ./worker2.crt \
  -days 3650 -extensions v3_req -extfile worker2.conf

# (optional) Clean
rm worker2.csr worker2.conf



###### Proxy
cd ${WORKDIR}/assets/certs/proxy

openssl genrsa -out ./proxy.key 2048
openssl req -new -key ./proxy.key -out ./proxy.csr -subj "/CN=system:kube-proxy/O=system:node-proxier"
openssl x509 -req -in ./proxy.csr \
  -CA ${WORKDIR}/assets/certs/ca/ca.crt \
  -CAkey ${WORKDIR}/assets/certs/ca/ca.key \
  -CAcreateserial -out ./proxy.crt -days 3650

# (optional) Clean
rm proxy.csr



###### Admin user
cd ${WORKDIR}/assets/users/admin

openssl genrsa -out ./admin.key 2048
openssl req -new -key ./admin.key -out ./admin.csr -subj "/CN=admin/O=system:masters"
openssl x509 -req -in ./admin.csr \
  -CA ${WORKDIR}/assets/certs/ca/ca.crt \
  -CAkey ${WORKDIR}/assets/certs/ca/ca.key \
  -CAcreateserial -out ./admin.crt -days 3650

# (optional) Clean
rm admin.csr


cd

```
