#!/usr/bin/env bash

set -euxo pipefail

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. ./01_vagrant.sh
. ./02_etcd.sh

# Step 2: Install etcd

# pushd 02_etcd
# ./run.sh
# popd


# ETCD_COUNT=$(jq '.instances.etcd.count' ./config.json)
# ETCD_START_IP=$(jq '.instances.etcd.first_ip' ./config.json)
# INITIAL_ETCD_CLUSTER=""
# pushd 01_vagrant
# for ((i=1; i<=$ETCD_COUNT; i++)); do
#   SERVER_NAME="etcd-$i"
#   IP=`vagrant ssh $SERVER_NAME -- -t ip -f inet addr show | grep 192.168 | grep -Po 'inet \K[\d.]+'`
#   if [[ ! -z "$INITIAL_ETCD_CLUSTER" ]]; then
#     INITIAL_ETCD_CLUSTER="$INITIAL_ETCD_CLUSTER,"
#   fi
#   INITIAL_ETCD_CLUSTER="$INITIAL_ETCD_CLUSTER$SERVER_NAME=http://$IP:2380"
#
#   vagrant ssh $SERVER_NAME -- -t mkdir -p /home/vagrant/etcd-assets/
#
# done
# popd
#
# for ((i=1; i<=$ETCD_COUNT; i++)); do
#   SERVER_NAME="etcd-$i"
#
#   pushd 01_vagrant
#   SERVER_HOST_PORT=`vagrant port $SERVER_NAME --guest 22`
#   vagrant ssh-config $SERVER_NAME > ../ssh-config.file
#   SERVER_IP=`vagrant ssh $SERVER_NAME -- -t ip -f inet addr show | grep 192.168 | grep -Po 'inet \K[\d.]+'`
#   chmod 600 ../ssh-config.file
#   popd
#
#   mkdir -p ./02_etcd/temp/
#   cp ./02_etcd/etcd-kube.service ./02_etcd/temp/etcd-kube.service
#   sed -i -e 's/{{ETCD_MEMBER_NAME}}/'$SERVER_NAME'/g' ./02_etcd/temp/etcd-kube.service
#   sed -i -e 's/{{ETCD_MEMBER_IP}}/'$SERVER_IP'/g' ./02_etcd/temp/etcd-kube.service
#   sed -i -e 's#{{INITIAL_ETCD_CLUSTER}}#'$INITIAL_ETCD_CLUSTER'#g' ./02_etcd/temp/etcd-kube.service
#
#   scp -F ./ssh-config.file ./02_etcd/temp/etcd-kube.service vagrant@$SERVER_NAME:/home/vagrant/etcd-assets/
#
#   pushd 01_vagrant
#   vagrant ssh $SERVER_NAME << EOF
#     sudo su;
#     cp /home/vagrant/etcd-assets/etcd-kube.service /etc/systemd/system/etcd-kube.service;
#     systemctl daemon-reload;
#     systemctl enable etcd-kube;
#     systemctl start etcd-kube;
# EOF
#
#   popd
#
#   # configure service
#   # check status
# done

# Clean up
rm -rf ./temp/
