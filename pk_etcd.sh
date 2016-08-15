#!/bin/bash -ex

ENDPOINTS=etcd-peer-1:2379,etcd-peer-2:2379,etcd-peer-3:2379
LEADER=false

# get args
for OPT in "$@"
do
  case "$OPT" in
    'true'|'false' )
      LEADER=$OPT
      ;;
    1|2|3 )
      KILL_NUM=$OPT
      ;;
    -9 )
      KILL_OPT=$OPT
      ;;
  esac
done

kill_proc () {
  echo $1
  node=`echo $1 | cut -d ':' -f 1`
  echo "kill etcd proc at $node"
  `ssh "$node" sudo pkill "$KILL_OPT" etcd`
}

export -f kill_proc

. ./check_status.sh
LEADER_NODE=`etcdctl --endpoints=["$ENDPOINTS"] endpoint status | grep 'true' | cut -d',' -f 1`
FOLLOWER_NODES="`etcdctl --endpoints=["$ENDPOINTS"] endpoint status | grep 'false' | cut -d',' -f 1`"

kill_follower_proc () {
  case $1 in
    1 )
      target=`echo $FOLLOWER_NODES | head -1`
      kill_proc $target
      ;;
    2 )
      echo $FOLLOWER_NODES | xargs -n 1 -I{} bash -c "kill_proc {}"
      ;;
    3 )
      echo 'kill the all peers process'
      echo $ENDPOINTS | tr -s ',' ' ' | xargs -n 1 echo |  xargs -n 1 -I{} bash -c "kill_proc {}"
      ;;
  esac
}

echo "LEADER_NODE is $LEADER_NODE"
echo "FOLLOWER_NODES is $FOLLOWER_NODES"
echo "Start Kill Process!!"
if [ $LEADER = true ]; then
    KILL_NUM=`expr $KILL_NUM - 1`
    echo 'kill the follower peers'
    kill_follower_proc $KILL_NUM
    echo 'kill the leader peer'
    kill_proc $LEADER_NODE
else
  echo 'kill the follower peers'
  kill_follower_proc $KILL_NUM
fi

. ./check_status.sh

