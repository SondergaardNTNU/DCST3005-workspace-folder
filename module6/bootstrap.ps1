###############################################################
# Bootstrap script for Terraform AzureRM backend state storage #
# Run this before terraform init/apply in dev/test environments #
###############################################################

# Set variables (edit to match backend.hcl and your Azure setup)
$RG_NAME = "rg-tfstate-sondre"           # Resource Group name
$LOCATION = "norwayeast"                 # Azure region
$STORAGE_ACCOUNT_NAME = "sttfsondre"     # Storage Account name
$CONTAINER_NAME = "tfstate"              # Blob Container name
$SUBSCRIPTION_ID = "a3adf20e-4966-4afb-b717-4de1baae6db1"   # Your Azure subscription ID
$ASSIGNEE = "sondre.h.sondergaard@ntnu.no" # Your Azure user or SPN object ID

# Create Resource Group
az group create --name $RG_NAME --location $LOCATION

# Create Storage Account
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RG_NAME --location $LOCATION --sku Standard_LRS

# Create Blob Container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

# Assign Storage Blob Data Contributor role to yourself
az role assignment create --assignee $ASSIGNEE --role "Storage Blob Data Contributor" --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG_NAME/providers/Microsoft.Storage/storageAccounts/$STORAGE_ACCOUNT_NAME"