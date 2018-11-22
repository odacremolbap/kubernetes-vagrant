#!/usr/bin/env bash
set -euxo pipefail

pushd 01_vagrant

if (vagrant status | grep "running" -q); then
  vagrant destroy -f
fi

popd

rm -rf ./ssh-config.file \
        ./01_vagrant/*.log \
        ./02_certificates/temp/ \
        ./03_etcd/temp/ \
