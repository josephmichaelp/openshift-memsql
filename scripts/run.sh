#!/bin/sh

STAMP=$(date)

echo "memsql:saG0wPb9ztPZs:`id -u`:0:MemSQL Service Account:/memsql:/bin/sh" >> /etc/passwd

# generate host keys
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
  /usr/bin/ssh-keygen -A
fi

echo "[${STAMP}] Starting sshd on port 9022 ..."
/usr/sbin/sshd -p 9022

echo "[${STAMP}] Starting daemon..."
cd /memsql/memsql-ops/
./memsql-ops start --ignore-root-error -f 2>&1
sleep 3600
