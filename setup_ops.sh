#!/bin/bash
set -e
set -x

VERSION_URL="http://versions.memsql.com/memsql-ops/4.1.11"
MEMSQL_VOLUME_PATH="/memsql"
OPS_URL=$(curl -s "$VERSION_URL" | jq -r .tar)

# download ops
curl -s $OPS_URL -o /tmp/memsql_ops.tar.gz

# install ops
mkdir -p /install
tar -xzf /tmp/memsql_ops.tar.gz -C /install --strip-components 1
chmod -R a+rw /install
