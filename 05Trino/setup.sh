#!/bin/bash

# This script assumes that the stackable stuff from last excercise was deployed..
helm install -n stackable hive-operator stackable-stable/hive-operator --version 23.7.0
helm install -n stackable trino-operator stackable-stable/trino-operator --version 23.7.0

# The sames goes for installing minio. There are explanations in excercises.md

kubectl apply -f s3connection.yaml -n sebastian

helm install postgresql \
--version=12.1.5 \
--namespace sebastian \
--set auth.username=hive \
--set auth.password=hive \
--set auth.database=hive \
--set primary.extendedConfiguration="password_encryption=md5" \
--repo https://charts.bitnami.com/bitnami postgresql

kubectl apply -f hive.yaml -n sebastian
kubectl apply -f trino.yaml -n sebastian

