#!/bin/bash -ex

#get args
if [ -z "$1" ]; then
  echo "must specify dir"
  exit 1
fi

. ./stop_logging.sh

OUTPUT_DIR="log/$1"
mkdir -p $OUTPUT_DIR
start_log () {
  echo "start logging $1"
  mkdir -p $OUTPUT_DIR/$1
  ssh $1 sudo journalctl -u etcd -f >> $OUTPUT_DIR/$1/etcd.log&
}

end=3
for i in $(seq 1 ${end}); do
  target="etcd-peer-$i"
  test=`start_log $target`
done

