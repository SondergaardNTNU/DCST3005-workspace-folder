# ...existing code...
#!/bin/bash
set -e

# Usage: ./cleanup.sh <env>
ENV=${1:-dev}
TFVARS_FILE="../environments/${ENV}.tfvars"

cd ../terraform

echo "Destroying resources for environment: $ENV"
terraform destroy -var-file=$TFVARS_FILE -auto-approve