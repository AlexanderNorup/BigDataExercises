#!/bin/bash

sh set_default_context.sh
kubectl delete -f hdfs.yml
kubectl delete -f zookeeper.yml
kubectl delete -f znode.yml

sh set_stackable_context.sh
helm uninstall zookeeper-operator
helm uninstall hdfs-operator
helm uninstall commons-operator
helm uninstall secret-operator

echo "Going back to default namespace"
sh set_default_context.sh