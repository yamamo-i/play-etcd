#!/bin/bash -ex

if [ -z "$1" ]; then
  echo 'must specify log directory.'
  exit 1
fi


stop_insert () {
  pkill -f 'insert_records.sh'
  echo "finish inserting. `date`"
  exit 0
}

trap stop_insert SIGINT

echo "start inserting. `date`"
end=3
for i in $(seq ${end}); do
  . ./insert_records.sh etcd-peer-$i $1&
done
while true; do : sleep 1;done

