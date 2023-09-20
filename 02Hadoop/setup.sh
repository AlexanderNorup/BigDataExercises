#!/bin/bash

# In Stackable namespace
sh set_stackable_context.sh
helm install --wait zookeeper-operator stackable-stable/zookeeper-operator --version 23.7.0
helm install --wait hdfs-operator stackable-stable/hdfs-operator --version 23.7.0
helm install --wait commons-operator stackable-stable/commons-operator --version 23.7.0
helm install --wait secret-operator stackable-stable/secret-operator --version 23.7.0

# Change namespace

sh set_default_context.sh
kubectl apply -f zookeeper.yml
kubectl apply -f znode.yml

# Waiting for it all to be up
kubectl rollout status --watch --timeout=5m statefulset/simple-zk-server-default

# Start HDFS cluster
kubectl apply -f hdfs.yml