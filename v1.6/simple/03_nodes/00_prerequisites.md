# Set variables and install prerequisites

You need to execute all scripts included in this folder at all nodes.

Make sure that `WORKER_NAME` below contains the node being installed.

```

###### BECOME ROOT
sudo su -



###### CHANGE THIS ENV VAR FOR EVERY NODE (master, worker1, worker2)
export WORKER_NAME=master1


###### PREPARE
export CNI_VERSION=v0.6.0
export KUBE_VERSION=v1.6.2

export WORKDIR=/vagrant/run
export KUBELET_CONF_DIR=/var/lib/kubelet
export KUBERNETES_CONF_DIR=/var/lib/kubernetes
export KUBERNETES_DNS_SERVICE=10.3.0.10
export KUBERNETES_POD_CIDR=10.2.0.0/16



###### CREATE WORKING DIRECTORIES
mkdir -p /opt/cni/bin
mkdir -p ${KUBELET_CONF_DIR}
mkdir -p ${KUBERNETES_CONF_DIR}/proxy/
mkdir -p ~/.kube/


###### INSTALL DOCKER
apt update
apt install docker.io -y



```
