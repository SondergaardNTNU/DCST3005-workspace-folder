#!/bin/bash
set -e

# Usage: ./build.sh <env>
ENV=${1:-dev}
TFVARS_FILE="../environments/${ENV}.tfvars"

cd ../terraform

echo "Validating Terraform..."
terraform validate

echo "Planning for environment: $ENV"
terraform plan -var-file=$TFVARS_FILE -out=plan-$ENV.tfplan

echo "Plan saved to plan-$ENV.tfplan"
terraform fmt -recursive
terraform validate