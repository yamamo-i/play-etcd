#!/bin/bash -ex

ENDPOINTS=etcd-peer-1:2379,etcd-peer-2:2379,etcd-peer-3:2379

echo '-------------------check status-------------------'
date
echo $ENDPOINTS | tr -s ',' ' ' | xargs -n 1 | xargs -I{} etcdctl --endpoints=[{}] endpoint status
echo $ENDPOINTS | tr -s ',' ' ' | xargs -n 1 | xargs -I{} etcdctl --endpoints=[{}] endpoint health
echo '--------------------------------------------------'

