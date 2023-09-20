#!/bin/bash

killall kubectl
sleep 1
kubectl delete -n kafka -f kafka-extra.yaml
kubectl delete -n kafka -f kafka.yaml
helm uninstall -n kafka strimzi-cluster-operator

read -p "I will open a watch window. Only close it when all pods are gone! Press any get to go!"
watch kubectl get pods -n kafka

kubectl delete namespace kafka

