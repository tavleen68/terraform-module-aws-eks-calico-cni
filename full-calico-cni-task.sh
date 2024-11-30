#!/bin/bash

# Temporarily store the original credentials (optional)
if [[ -n "$OLD_AWS_ACCESS_KEY_ID" && -n "$OLD_AWS_SECRET_ACCESS_KEY" ]]; then
  echo "Original credentials already stored. Skipping..."
else
  # Capture existing credentials (if not already stored in OLD_ variables)
  OLD_AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID"
  OLD_AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY"
  OLD_AWS_SESSION_TOKEN="$AWS_SESSION_TOKEN"
  export OLD_AWS_ACCESS_KEY_ID OLD_AWS_SECRET_ACCESS_KEY OLD_AWS_SESSION_TOKEN  # Ensure exportability
  echo "Original credentials captured."
fi

# Assume the role and capture temporary credentials
ROLE_CREDS=$(aws sts assume-role --role-arn arn:aws:iam::767397754004:role/om-devops-terraform-role --role-session-name eks-cluster-cred)

# Set temporary credentials as environment variables
export AWS_ACCESS_KEY_ID=$(echo $ROLE_CREDS | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $ROLE_CREDS | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $ROLE_CREDS | jq -r '.Credentials.SessionToken')

# Update kubeconfig with temporary credentials
aws eks update-kubeconfig --name om-eucen1-dev2-cxp-eks-cluster --region eu-central-1

# "Delete the aws-node daemon set to disable AWS VPC networking for pods"
kubectl delete daemonset -n kube-system aws-node

# "Install calico manifest"
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico-vxlan.yaml

# Configure Calico to disable AWS src/dst checks"
kubectl -n kube-system set env daemonset/calico-node FELIX_AWSSRCDSTCHECK=Disable

# Execute the script script to configure original aws credentials to provision infra

# Reset credentials to original values (if captured earlier)
if [[ -n "$OLD_AWS_ACCESS_KEY_ID" && -n "$OLD_AWS_SECRET_ACCESS_KEY" ]]; then
  export AWS_ACCESS_KEY_ID="$OLD_AWS_ACCESS_KEY_ID"
  export AWS_SECRET_ACCESS_KEY="$OLD_AWS_SECRET_ACCESS_KEY"
  export AWS_SESSION_TOKEN="$OLD_AWS_SESSION_TOKEN"
  echo "Original credentials restored."
else
  echo "No original credentials found to restore."
fi
