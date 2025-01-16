#!/bin/bash

for i in {1..20}; do
    echo "Ensuring that containers are spawned... ${i}"
    count=$(oc get pods --all-namespaces | grep openshift | grep -vic 'running')
    if [ "$count" -eq "0" ]; then
        # Ensure that all pods are in expected count
        for ns in $(oc get pods --all-namespaces | grep openshift | awk '{print $1}'); do
            echo "Checking pods from namespace: $ns";
            if ! kubectl -n "$ns" wait --for=condition=Ready pod --all; then
                echo -e "\nThe namespace $ns pods count does not match. Waiting..."
                sleep 15
            fi
        done
        echo -e "\nMicroshift is deployed, we can continue..."
        exit 0
    else
        echo "The Microshift containers are not ready..."
        sleep 15
    fi
done

# Normally, the script should finished in the for loop, but if it's not
# it should exit with an error. Before that, describe all pods that
# are not running correctly.
echo -e "\nSomething is not deployed in Microshift!\n"
oc get pods --all-namespaces --no-headers | grep -Evi 'running|completed' | while read -r ns pod rest; do
    echo -e "\nChecking ${pod} in namespace ${ns}"
    kubectl -n "${ns}" describe pod "${pod}";
    kubectl -n "${ns}" logs "${pod}" || true
done

# Print additional information related to the storage
systemctl status microshift-loop-device
losetup
lsblk
sudo vgdisplay
sudo lvdisplay
sudo vgs

exit 1
