#!/bin/bash
echo "Will automatically open watch with pods. Only close when all pods are ready!"
read -p "Press any key to start ..."

kubectl create namespace kafka
sleep 1
helm install -n kafka strimzi-cluster-operator oci://quay.io/strimzi-helm/strimzi-kafka-operator --set watchAnyNamespace=true
watch kubectl get pods -n kafka

kubectl apply -n kafka -f kafka.yaml
watch kubectl get pods -n kafka

kubectl apply -n kafka -f kafka-extra.yaml
watch kubectl get pods -n kafka
# Hvis redpanda driller, så kør: kubectl rollout restart deployment/redpanda -n kafka

echo "Port-forwarding redpanda to :8080"
kubectl port-forward svc/redpanda  8080:8080 -n kafka &

echo "Port-forwarding kafka-schema-registry to :8081"
kubectl port-forward svc/kafka-schema-registry  8081:8081 -n kafka &

echo "Port-forwarding kafka-connect to :8083"
kubectl port-forward svc/kafka-connect  8083:8083 -n kafka &

echo "Connect to the ksqlDB using:"
echo kubectl exec --namespace=kafka --stdin --tty deployment/kafka-ksqldb-cli -- ksql http://kafka-ksqldb-server:8088