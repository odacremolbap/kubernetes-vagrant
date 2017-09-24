# Set variables an install prerequisites

```
###### BECOME ROOT
sudo su -



###### PREPARE
export KUBE_VERSION=v1.6.2
export APISERVER_IP1=192.168.56.101
export WORKER1_IP1=192.168.56.102
export WORKER2_IP1=192.168.56.103
export WORKDIR=/vagrant/run
export KUBERNETES_CONF_DIR=/var/lib/kubernetes
export KUBELET_CONF_DIR=/var/lib/kubelet

export ETCD_VERSION=v3.2.7
export ETCD_DIR=/var/lib/etcd
export KUBERNETES_CONF_DIR=/var/lib/kubernetes

export KUBERNETES_SERVICE_CIDR=10.3.0.0/24
export KUBERNETES_POD_CIDR=10.2.0.0/16


###### DELETE PREVIOUS DATA
rm -rf ${WORKDIR}



###### CREATE WORKING DIRECTORIES
mkdir -p ${WORKDIR}/assets/certs/ca
mkdir -p ${WORKDIR}/assets/certs/apiserver
mkdir -p ${WORKDIR}/assets/certs/controller-manager
mkdir -p ${WORKDIR}/assets/certs/scheduler
mkdir -p ${WORKDIR}/assets/certs/proxy
mkdir -p ${WORKDIR}/assets/certs/etcd
mkdir -p ${WORKDIR}/assets/certs/etcd-client

mkdir -p ${WORKDIR}/assets/master
mkdir -p ${WORKDIR}/assets/systemd

mkdir -p ${WORKDIR}/assets/nodes/master1
mkdir -p ${WORKDIR}/assets/nodes/worker1
mkdir -p ${WORKDIR}/assets/nodes/worker2

mkdir -p ${WORKDIR}/assets/users/admin



###### CREATE KUBERNETES MASTER DIRECTORIES
mkdir -p ${KUBERNETES_CONF_DIR}/ca
mkdir -p ${KUBERNETES_CONF_DIR}/apiserver
mkdir -p ${KUBERNETES_CONF_DIR}/controller-manager
mkdir -p ${KUBERNETES_CONF_DIR}/scheduler
mkdir -p ${KUBERNETES_CONF_DIR}/etcd-client

mkdir -p ${ETCD_DIR}/data
mkdir -p ${ETCD_DIR}/config



###### INSTALL DOCKER
apt update
apt install docker.io -y



###### INSTALL BINARIES
wget  https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/


```
