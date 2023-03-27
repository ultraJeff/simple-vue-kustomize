#!/bin/bash
# Function to check if all pods are running
function check_pods_running {
  # Loop until all pods are running
  while true; do
    # Get all pods in the current namespace
    pods=$(oc get pods -o=name)

    # Flag to track if all pods are running
    all_running=true

    # Loop through each pod and check if it's running
    for pod in $pods; do
      status=$(oc get $pod -o=jsonpath='{.status.phase}')
      if [[ "$status" != "Running" ]]; then
        echo "Error: Pod $pod is not running (status: $status)."
        all_running=false
      fi
    done

    # Exit the loop if all pods are running
    if $all_running; then
      echo "All pods are running."
      break
    fi

    # Wait for a few seconds before checking again
    sleep 5
  done
}



# Check if the user is logged in to OpenShift
if ! oc whoami &> /dev/null; then
  echo "Error: You are not logged in to OpenShift."
  exit 1
fi

oc create namespace openshift-gitops
oc create -f init/
check_pods_running