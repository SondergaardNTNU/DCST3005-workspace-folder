# ...existing code...
#!/bin/bash
set -e

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
	echo "❌ Error: Environment required"
	echo "Usage: ./cleanup.sh <environment>"
	exit 1
fi

echo "🧹 Cleaning up $ENVIRONMENT environment..."

# Get subscription ID from Azure CLI
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
if [ -z "$SUBSCRIPTION_ID" ]; then
	echo "❌ Error: Not logged in to Azure. Please run: az login"
	exit 1
fi
export ARM_SUBSCRIPTION_ID=$SUBSCRIPTION_ID


cd terraform

echo "🔧 Initializing Terraform with backend config..."
terraform init -backend-config=../shared/backend.hcl -backend-config=../backend-configs/backend-$ENVIRONMENT.tfvars

echo "🗑️ Destroying resources for environment: $ENVIRONMENT"
read -p "Are you sure you want to destroy resources for '$ENVIRONMENT'? Type 'yes' to continue: " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
	echo "Aborted. No resources destroyed."
	exit 0
fi
terraform destroy -var-file=../environments/$ENVIRONMENT.tfvars -auto-approve