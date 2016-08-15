#!/bin/bash -ex

if [ -z "$ETCDCTL_API" ] || [ "$ETCDCTL_API" != "3" ]; then
  echo 'have to set env variable. export ETCDCTL_API=3'
  exit 1
fi

if [ -z "$1" ] || [ -z "`ssh $1 etcdctl`" ]; then
  echo 'must specify etcd host.'
  exit 1
fi

if [ -z "$2 " ]; then
  echo 'must specify log directory.'
  exit 1
fi

LOG_DIR=log/$2/$1
mkdir -p $LOG_DIR

key_id=0
while true
do
  echo "insert: key="$1"-`printf "%06d" $key_id`, value=`date +"%Y/%m/%d-%I:%M:%S-%Z"`" >> $LOG_DIR/client.log 
  etcdctl --endpoints=["$1":2379] put "$1"-`printf "%06d" $key_id` `date +"%Y/%m/%d-%I:%M:%S-%Z"` >> $LOG_DIR/client.log 2>&1
  key_id=`expr $key_id + 1`
  sleep 1
done

