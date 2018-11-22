#!/usr/bin/env bash

set -euxo pipefail

BASE_DIR=${BASE_DIR:-$PWD/..}
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VAGRANT_DIR="$BASE_DIR/01_vagrant"
CERTS_DIR="$BASE_DIR/02_certificates"
GEN_DIR="$CERTS_DIR/temp"
CONFIG_FILE="$BASE_DIR/config.json"
DAYS=${DAYS:-3650}

ETCD_COUNT=$(jq '.instances.etcd.count' $CONFIG_FILE)
MASTER_COUNT=$(jq '.instances.masters.count' $CONFIG_FILE)
WORKER_COUNT=$(jq '.instances.workers.count' $CONFIG_FILE)

pushd $CERTS_DIR

mkdir -p $GEN_DIR

# CA Key
if ! test -e $GEN_DIR/ca.key;  then
  openssl genrsa -out $GEN_DIR/ca.key 4096
fi

# CA Cert
if ! test -e $GEN_DIR/ca.cert;  then
CONFIG="
[ req ]
default_bits       = 4096
distinguished_name = req_distinguished_name
x509_extensions    = x509_ext
string_mask        = utf8only

[ req_distinguished_name ]
commonName                 = kubernetest

[ x509_ext ]
basicConstraints       = CA:true
keyUsage               = keyCertSign,cRLSign
subjectKeyIdentifier   = hash
"

cat <(echo "$CONFIG")

openssl req \
        -x509 \
        -new \
        -nodes \
        -key $GEN_DIR/ca.key \
        -days $DAYS \
        -out $GEN_DIR/ca.crt \
        -subj '/CN=kubernetes' \
        -config <(echo "$CONFIG")
fi

# Etcd certificates
pushd $VAGRANT_DIR
INITIAL_ETCD_CLUSTER=
for ((i=1; i<=$ETCD_COUNT; i++)); do

  SERVER_NAME="etcd-$i"
  IP=`vagrant ssh $SERVER_NAME -- -t ip -f inet addr show | grep 192.168 | grep -Po 'inet \K[\d.]+'`
  if [[ -z "${INITIAL_ETCD_CLUSTER}" ]]; then
    INITIAL_ETCD_CLUSTER="$IP"
  else
    INITIAL_ETCD_CLUSTER="$INITIAL_ETCD_CLUSTER,$IP"
  fi

  SERVER_KEY=$GEN_DIR/$SERVER_NAME-server.key;
  if ! test -e $SERVER_KEY;  then
    openssl genrsa -out $SERVER_KEY 4096
  fi

  if ! test -e $GEN_DIR/$SERVER_NAME-server.crt;  then
    openssl req \
            -new \
            -nodes \
            -key $SERVER_KEY \
            -days $DAYS \
            -out $GEN_DIR/ca.crt \
            -subj '/CN=kubernetes' \
            -config <(echo "$CONFIG")

    openssl genrsa -out $GEN_DIR/$SERVER_NAME-server.key 4096
  fi



  # Generate serving certificate per each etcd member
  CONFIG="
  [ req ]
  default_bits       = 4096
  distinguished_name = req_distinguished_name
  x509_extensions    = x509_ext
  string_mask        = utf8only

  [ req_distinguished_name ]
  commonName                 = kubernetest

  [ x509_ext ]
  basicConstraints       = CA:true
  keyUsage               = keyCertSign,cRLSign
  subjectKeyIdentifier   = hash
  "

  cat <(echo "$CONFIG")

  # openssl req \
  #         -new \
  #         -nodes \
  #         -keyout
  #         -key $GEN_DIR/ca.key \
  #         -days $DAYS \
  #         -out $GEN_DIR/ca.crt \
  #         -subj '/CN=kubernetes' \
  #         -config <(echo "$CONFIG")

  # Generate peer certificate per each etcd member

  # Copy certificates to etcd servers

  vagrant ssh $SERVER_NAME -- -t mkdir -p /home/vagrant/etcd-assets/

  # openssl req -config openssl.cnf -new -nodes \
  #   -keyout private/etcd0.example.com.key -out etcd0.example.com.csr

done
popd


# # kube-apiserver
# if [ ! -f ./apiserver.crt ]; then
#
#
# cat <<EOF > server.conf
# [req]
# req_extensions = v3_req
# distinguished_name = req_distinguished_name
# [req_distinguished_name]
# [ v3_req ]
# basicConstraints = CA:FALSE
# keyUsage = nonRepudiation, digitalSignature, keyEncipherment
# subjectAltName = @alt_names
# [alt_names]
# DNS.1 = kubernetes
# DNS.2 = kubernetes.default
# DNS.3 = kubernetes.default.svc
# DNS.4 = kubernetes.default.svc.cluster.local
# IP.1 = ${APISERVER_IP1}
# IP.2 = 127.0.0.1
# IP.3 = 10.3.0.1
# EOF

# Etcd certificate
# Etcd client certificate

# Masters kubelets
# Masters proxy
# Masters apiserver

# Workers kubelets
# Workers proxy

popd
