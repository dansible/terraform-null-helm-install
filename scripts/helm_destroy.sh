#!/usr/bin/env bash

echo "${kubeconfig}" > ./"${name}.kubeconfig"
export KUBECONFIG="./${name}.kubeconfig"

helm reset

kubectl -n kube-system delete po -l app=helm,name=tiller
kubectl -n kube-system delete deployment/tiller-deploy
kubectl -n kube-system delete service/tiller-deploy
kubectl -n kube-system delete serviceaccount/tiller
kubectl delete clusterrolebinding/tiller-cluster-rule

unset KUBECONFIG

rm -f "./${name}.kubeconfig"
