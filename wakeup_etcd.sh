#!/bin/bash -ex

end=3
for i in $(seq 1 ${end}) ; do
  target="etcd-peer-$i"
  ssh $target "sudo systemctl status etcd | grep running" > /dev/null
  if [ 0 = $? ]; then
    echo "$target's etcd is already running."
  else
    echo "wake up $target's etcd"
    ssh $target "sudo systemctl start etcd"
  fi
done

. ./check_status.sh

