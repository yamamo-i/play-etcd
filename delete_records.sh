#!/bin/bash -ex

if [ -z "$ETCDCTL_API" ] || [ "$ETCDCTL_API" != "3" ]; then
  echo 'have to set env variable. export ETCDCTL_API=3'
  exit 1
fi

if [ -z "$1" ] || [ -z "`ssh $1 etcdctl`" ]; then
  echo 'use default node etcd-peer-1'
  node=etcd-peer-1
else
  node=$1
fi

etcdctl --endpoints=["$node":2379] del etcd-peer-0 etcd-peer-4

