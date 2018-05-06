#!/usr/bin/env bash

set -euxo pipefail

ETCD_VER="v3.3.4"
VAGRANT_DIR="$BASE_DIR/01_vagrant"
CONFIG_FILE="$BASE_DIR/config.json"
TEMP_DIR="$BASE_DIR/temp"
ETCD_ASSETS_DIR="$BASE_DIR/03_etcd"

ETCD_COUNT=$(jq '.instances.etcd.count' $CONFIG_FILE)
ETCD_START_IP=$(jq '.instances.etcd.first_ip' $CONFIG_FILE)
INITIAL_ETCD_CLUSTER=""

pushd $VAGRANT_DIR
for ((i=1; i<=$ETCD_COUNT; i++)); do
  SERVER_NAME="etcd-$i"
  IP=`vagrant ssh $SERVER_NAME -- -t ip -f inet addr show | grep 192.168 | grep -Po 'inet \K[\d.]+'`
  if [[ ! -z "$INITIAL_ETCD_CLUSTER" ]]; then
    INITIAL_ETCD_CLUSTER="$INITIAL_ETCD_CLUSTER,"
  fi
  INITIAL_ETCD_CLUSTER="$INITIAL_ETCD_CLUSTER$SERVER_NAME=http://$IP:2380"

  vagrant ssh $SERVER_NAME -- -t mkdir -p /home/vagrant/etcd-assets/
done
popd

mkdir -p $TEMP_DIR

for ((i=1; i<=$ETCD_COUNT; i++)); do
  SERVER_NAME="etcd-$i"

  pushd $VAGRANT_DIR
  SERVER_HOST_PORT=`vagrant port $SERVER_NAME --guest 22`
  vagrant ssh-config $SERVER_NAME > $TEMP_DIR/ssh-config.file
  SERVER_IP=`vagrant ssh $SERVER_NAME -- -t ip -f inet addr show | grep 192.168 | grep -Po 'inet \K[\d.]+'`
  chmod 600 $TEMP_DIR/ssh-config.file
  popd

  cp $ETCD_ASSETS_DIR/etcd-kube.service $TEMP_DIR/etcd-kube.service
  sed -i -e 's/{{ETCD_MEMBER_NAME}}/'$SERVER_NAME'/g' $TEMP_DIR/etcd-kube.service
  sed -i -e 's/{{ETCD_MEMBER_IP}}/'$SERVER_IP'/g' $TEMP_DIR/etcd-kube.service
  sed -i -e 's#{{INITIAL_ETCD_CLUSTER}}#'$INITIAL_ETCD_CLUSTER'#g' $TEMP_DIR/etcd-kube.service

  scp -F $TEMP_DIR/ssh-config.file $TEMP_DIR/etcd-kube.service vagrant@$SERVER_NAME:/home/vagrant/etcd-assets/

  pushd $VAGRANT_DIR
  vagrant ssh $SERVER_NAME << EOF
    sudo su;
    if [ ! -f /usr/bin/etcd ]; then

    groupadd --system etcd;
    useradd --home-dir "/var/lib/etcd" --system --shell /bin/false -g etcd etcd;
    mkdir -p /var/lib/etcd;
    chown etcd:etcd /var/lib/etcd;

    rm -rf /tmp/etcd && mkdir -p /tmp/etcd;
    curl -L https://github.com/coreos/etcd/releases/download/$ETCD_VER/etcd-$ETCD_VER-linux-amd64.tar.gz -o /tmp/etcd-$ETCD_VER-linux-amd64.tar.gz;
    tar xzvf /tmp/etcd-$ETCD_VER-linux-amd64.tar.gz -C /tmp/etcd --strip-components=1;
    cp /tmp/etcd/etcd /usr/bin/etcd;
    cp /tmp/etcd/etcdctl /usr/bin/etcdctl;

    fi;

    cp /home/vagrant/etcd-assets/etcd-kube.service /etc/systemd/system/etcd-kube.service;
    systemctl daemon-reload;
    systemctl enable etcd-kube;
    systemctl start etcd-kube --no-block;
EOF

  popd

done
