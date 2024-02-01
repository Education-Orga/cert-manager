#!/bin/bash

# set context to application-cluster
KUBE_CONTEXT="kind-application-cluster"
kubectl config use-context "$KUBE_CONTEXT"

# create cert-manager and hr-system namespace if not present
CERT_MANAGER_NAMESPACE="cert-manager"
kubectl get ns "$CERT_MANAGER_NAMESPACE" || kubectl create ns "$CERT_MANAGER_NAMESPACE"

HR_SYSTEM_NAMESPACE="hr-system"
kubectl get ns "$HR_SYSTEM_NAMESPACE" || kubectl create ns "$HR_SYSTEM_NAMESPACE"

# install OLM
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.26.0/install.sh | bash -s v0.26.0

# deploy cert-manager from operatorhub manifests
echo "deploy cert-manager..."
kubectl create -f https://operatorhub.io/install/cert-manager.yaml

# deploy cert-manager crds
kubectl apply -f configs/certificate.yaml -n "$HR_SYSTEM_NAMESPACE"
kubectl apply -f configs/cluster-issuer.yaml -n "$CERT_MANAGER_NAMESPACE"

echo "Cert-Manager and CRDs deployed successfully in namespace '$HR_SYSTEM_NAMESPACE' and '$CERT_MANAGER_NAMESPACE' of context '$KUBE_CONTEXT'."