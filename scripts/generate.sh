#!/bin/bash

export CLUSTER_NAME="<YOUR_K8S_CLUSTER_NAME>"

export APISERVER=$(kubectl config view -o jsonpath="{.clusters[?(@.name==\"$CLUSTER_NAME\")].cluster.server}")

export TOKEN=$(kubectl get secret mbition-secret-token -o jsonpath='{.data.token}' | base64 --decode)


server="<YOUR_K8S_CLUSTER_EXT_DNS>"
ca=$(kubectl get secret/mbition-secret-token -o jsonpath='{.data.ca\.crt}')
token=$(kubectl get secret/mbition-secret-token -o jsonpath='{.data.token}' | base64 --decode)
namespace=$(kubectl get secret/mbition-secret-token -o jsonpath='{.data.namespace}' | base64 --decode)

echo "
apiVersion: v1
kind: Config
clusters:
- name: default-cluster
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: default-context
  context:
    cluster: default-cluster
    namespace: default
    user: default-user
current-context: default-context
users:
- name: default-user
  user:
    token: ${token}
"
