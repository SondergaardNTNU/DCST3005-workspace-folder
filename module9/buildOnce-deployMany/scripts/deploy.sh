#!/bin/bash
set -e

ENVIRONMENT=$1
ARTIFACT=$2

if [ -z "$ENVIRONMENT" ]; then
	echo "❌ Error: Environment required"
	echo "Usage: ./deploy.sh <environment> <artifact>"
	exit 1
fi

if [ -z "$ARTIFACT" ]; then
	echo "❌ Error: Artifact required"
	exit 1
fi

if [ ! -f "$ARTIFACT" ]; then
	echo "❌ Error: Artifact not found: $ARTIFACT"
	exit 1
fi

echo "🚀 Deploying to $ENVIRONMENT environment..."
echo ""

# Get subscription ID from Azure CLI
echo "🔍 Getting Azure subscription ID..."
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

if [ -z "$SUBSCRIPTION_ID" ]; then
	echo "❌ Error: Could not get subscription ID. Please run 'az login' first."
	exit 1
fi

echo "✅ Using subscription: $SUBSCRIPTION_ID"
echo ""

# Export as environment variable for Terraform
export ARM_SUBSCRIPTION_ID=$SUBSCRIPTION_ID

# Unpack artifact
tar -xzf $ARTIFACT

cd ../terraform

echo "🔧 Initializing Terraform with backend config..."
terraform init -backend-config=../shared/backend.hcl

echo "📝 Applying for environment: $ENVIRONMENT"
terraform apply -var-file=../environments/$ENVIRONMENT.tfvars -auto-approve