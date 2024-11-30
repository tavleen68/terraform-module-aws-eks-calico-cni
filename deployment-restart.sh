#!/bin/bash

# Loop through namespaces
for namespace in $(kubectl get namespaces -o go-template='{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'); do
  # List deployments and DaemonSets
  echo "** Namespace: $namespace **"
  kubectl get deployments -n "$namespace" || true  # Suppress errors if no deployments exist
  kubectl get daemonsets -n "$namespace" || true   # Suppress errors if no DaemonSets exist

  # Restart deployments and DaemonSets (optional confirmation)

  kubectl rollout restart deployment -n "$namespace" || true  # Suppress errors for empty deployments
  kubectl rollout restart daemonsets -n "$namespace" || true   # Suppress errors for empty DaemonSets
  echo "restarted deployments and DaemonSets in $namespace."
done

echo "Finished processing all namespaces."
