#!/usr/bin/env bash
set -euxo pipefail

pushd 01_vagrant

if (vagrant status master1 | grep "master1" | grep "not created" -q ||
   vagrant status worker1 | grep "worker1" | grep "not created" -q ||
   vagrant status worker2 | grep "worker2" | grep "not created" -q); then
   echo "Creating vagrant nodes"
   vagrant up
fi

MASTER_SSH_PORT=$(vagrant port master1 --guest 22)
WORKER1_SSH_PORT=$(vagrant port worker1 --guest 22)
WORKER2_SSH_PORT=$(vagrant port worker2 --guest 22)

# TODO (pabs) This works for linux. Probably will need to add mac support
HOST_IP=$(ip addr show docker0 | grep -Po 'inet \K[\d.]+')
SSH_PRIVATE_KEY_ENV=`cat $(vagrant ssh-config master1 | grep IdentityFile | rev|  cut -d' ' -f 1 | rev)`

popd

# LINUX_DISTRIBUTION_ENV=containerLinux
# ARCH_ENV=amd64
#
# MASTERS_ENV=KUBERNETES_NAME=spc-master1:IP=$HOST_IP:PORT=$MASTER_SSH_PORT
#
# WORKERS_ENV=KUBERNETES_NAME=spc-worker1:IP=$HOST_IP:PORT=$WORKER1_SSH_PORT
# WORKERS_ENV+=,KUBERNETES_NAME=spc-worker2:IP=$HOST_IP:PORT=$WORKER2_SSH_PORT
#
# KUBEADM_RELEASE_ENV=v1.8.1
#
# docker run \
#   -e LINUX_DISTRIBUTION=$LINUX_DISTRIBUTION_ENV \
#   -e ARCH=$ARCH_ENV \
#   -e KUBERNETES_MASTERS=$MASTERS_ENV \
#   -e KUBERNETES_WORKERS=$WORKERS_ENV \
#   -e "SSH_PRIVATE_KEY=$SSH_PRIVATE_KEY_ENV" \
#   -e KUBEADM_RELEASE=$KUBEADM_RELEASE_ENV \
#   quay.io/stackpoint/kubernetes-ops ansible-playbook /opt/stackpoint/playbook/kubernetes_create.yml
