#!/usr/bin/env bash

echo "$KCONFIG" > ./"$NAME.kubeconfig"
export KUBECONFIG="./$NAME.kubeconfig"

CRB_INIT=$(kubectl create clusterrolebinding "$(gcloud config get-value account)" --clusterrole=cluster-admin --user="$(gcloud config get-value account)" 2>&1)
if ! echo "$CRB_INIT" | grep -E 'created|AlreadyExists' ; then
  exit 1
fi

SA=$(kubectl --namespace kube-system create serviceaccount tiller 2>&1)
if ! echo "$SA" | grep -E 'created|AlreadyExists' ; then
  exit 1
fi

CRB=$(kubectl create clusterrolebinding tiller-cluster-rule \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:tiller 2>&1)
if ! echo "$CRB" | grep -E 'created|AlreadyExists' ; then
  exit 1
fi

set -o errexit

helm init \
  --upgrade \
  --wait \
  --service-account tiller \
  --tiller-namespace kube-system \
  --tiller-image "gcr.io/kubernetes-helm/tiller:${TILLER_VERSION}" \
  --override spec.template.metadata.annotations."sidecar\.istio\.io/inject"="false" \
  --override 'spec.template.spec.containers[0].command'='{/tiller,--listen=localhost:44134,--storage=secret}'

rm -f "./$NAME.kubeconfig"
