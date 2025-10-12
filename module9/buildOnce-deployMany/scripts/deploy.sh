#!/bin/bash
set -e

# Usage: ./deploy.sh <env>
ENV=${1:-dev}
TFVARS_FILE="../environments/${ENV}.tfvars"

cd ../terraform

echo "Applying for environment: $ENV"
terraform apply -var-file=$TFVARS_FILE -auto-approve