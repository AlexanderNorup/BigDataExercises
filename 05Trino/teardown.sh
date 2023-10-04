#!/bin/bash

# This script only undos what's done in setup.sh

kubectl delete -f s3connection.yaml -n sebastian
kubectl delete -f hive.yaml -n sebastian
kubectl delete -f trino.yaml -n sebastian

helm uninstall postgresql -n sebastian

helm uninstall -n stackable hive-operator
helm uninstall -n stackable trino-operator 