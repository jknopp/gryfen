#Path to terraform config
TERRAFORM_CONFIG=variables.tf.json

# Load variables from the terraform config
APP_NAME=$(cat $TERRAFORM_CONFIG | jq -r .variable[].name[]?.default)
ENVIRONMENT=$(cat $TERRAFORM_CONFIG | jq -r .variable[].environment[]?.default)
LOCATION=$(cat $TERRAFORM_CONFIG | jq -r .variable[].location[]?.default)
PLAN_TIER=$(cat $TERRAFORM_CONFIG | jq -r .variable[].plan_tier[]?.default)
REPLICATION_TYPE=$(cat $TERRAFORM_CONFIG | jq -r .variable[].storage_replication[]?.default)
DNS_PREFIX=$(cat $TERRAFORM_CONFIG | jq -r .variable[].dns_prefix[]?.default)
TERRAFORM_BACKEND_STATE_CONTAINER_NAME=$(cat $TERRAFORM_CONFIG | jq -r .variable[].terraform_backend_state_container_name[]?.default)
TERRAFORM_STATE_FILENAME=$ENVIRONMENT.terraform.tfstate

# Setup azure parameters
RESOURCE_GROUP_NAME=$APP_NAME-$ENVIRONMENT-rg
STORAGE_ACCOUNT_NAME=$DNS_PREFIX$ENVIRONMENT
STORAGE_ACCOUNT_SKU=${PLAN_TIER}_${REPLICATION_TYPE}
STORAGE_CONTAINER_URL=https://$STORAGE_ACCOUNT_NAME.blob.core.windows.net/$TERRAFORM_BACKEND_STATE_CONTAINER_NAME

# Create resource group
echo "Creating resource group ......"
RESOURCE_GROUP_ID=$(az group create --name $RESOURCE_GROUP_NAME --location $LOCATION --query 'id' -o tsv)

# Create storage account
echo "Creating storage account ......"
STORAGE_ACCOUNT_ID=$(az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku $STORAGE_ACCOUNT_SKU --encryption-services blob --query 'id' -o tsv)

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

# Create blob container
echo "Creating blob container ......"
CONTAINER_SUCCESS=$(az storage container create --name $TERRAFORM_BACKEND_STATE_CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY)

# Initialize terraform to use our storage account for remote storage
terraform init \
    -backend-config="resource_group_name=$RESOURCE_GROUP_NAME" -backend-config="storage_account_name=$STORAGE_ACCOUNT_NAME" -backend-config="container_name=$TERRAFORM_BACKEND_STATE_CONTAINER_NAME" -backend-config="key=$TERRAFORM_STATE_FILENAME"

# Import the resource group to the terraform state
terraform import azurerm_resource_group.default $RESOURCE_GROUP_ID

# Import the storage account to the terraform state
terraform import azurerm_storage_account.default $STORAGE_ACCOUNT_ID

# Import the storage container to the terraform state
terraform import azurerm_storage_container.terraform $STORAGE_CONTAINER_URL