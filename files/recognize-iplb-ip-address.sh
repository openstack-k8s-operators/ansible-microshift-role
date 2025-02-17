#!/bin/bash

IP=$(oc get svc -n openshift-ingress router-internal-default -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
if [ -z "${IP}" ]; then
    IP=$(oc get svc -n openshift-ingress router-internal-default -o jsonpath='{.spec.clusterIP}');
fi
echo "${IP}"
