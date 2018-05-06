#!/usr/bin/env bash

set -euxo pipefail

BASE_DIR=${BASE_DIR:-$PWD}
CERTS_DIR="$BASE_DIR/02_certificates"

echo $CERTS_DIR
pushd $CERTS_DIR
# CA Key
if [ ! -f ./ca.key ]; then
openssl genrsa -out ./ca.key 2048
fi

if [ ! -f ./ca.crt ]; then
openssl req -x509 -new -nodes -key ./ca.key -days 3650 -out ./ca.crt -subj "/CN=test-ca"
fi

# Admin user

# Etcd certificate
# Etcd client certificate

# Masters kubelets
# Masters proxy
# Masters apiserver

# Workers kubelets
# Workers proxy

popd
