#!/usr/bin/env bash
set -euxo pipefail


pushd 01_vagrant

if (vagrant status | grep "not created\|poweroff" -q); then
  vagrant up
fi

# # TODO (pabs) This works for linux. Probably will need to add mac support
HOST_IP=$(ip addr show docker0 | grep -Po 'inet \K[\d.]+')
SSH_PRIVATE_KEY_ENV=`cat $(vagrant ssh-config master-1 | grep IdentityFile | rev|  cut -d' ' -f 1 | rev)`

popd

pushd 02_etcd

ETCD_COUNT=$(jq '.instances.etcd.count' ../config.json)
echo $ETCD_COUNT


popd
