#!/usr/bin/env bash

set -euxo pipefail

VAGRANT_DIR="$BASE_DIR/01_vagrant"

pushd $VAGRANT_DIR
if (vagrant status | grep "not created\|poweroff" -q); then
  vagrant up
fi
popd

# TODO (pabs) This works for linux. Probably will need to add mac support
# HOST_IP=127.0.0.1
# SSH_PRIVATE_KEY=`vagrant ssh-config master-1 | grep IdentityFile | rev|  cut -d' ' -f 1 | rev`
