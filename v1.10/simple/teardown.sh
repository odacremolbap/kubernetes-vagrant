#!/usr/bin/env bash
set -euxo pipefail

pushd 01_vagrant

if (vagrant status | grep "running" -q); then
  vagrant destroy -f
fi

popd

rm -rf ./ssh-config.file ./02_etcd/temp/
