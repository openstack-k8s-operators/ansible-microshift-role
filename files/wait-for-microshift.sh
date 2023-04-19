#!/bin/bash

for i in {1..20}; do
    echo "Ensuring that containers are spawned... ${i}"
    count=$(oc get pods --all-namespaces | grep openshift | grep -vic 'running')
    if [ "$count" -eq "0" ]; then
        echo "Microshift is deployed, we can continue..."
        break
    else
        echo "The Microshift containers are not ready..."
        sleep 15
    fi
done
