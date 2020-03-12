
# Define the variables for this application
variable "name" {}
variable "environment" {}
variable "location" {}
variable "dns_prefix" {}
variable "plan_tier" {}
variable "plan_sku" {}
variable "storage_replication" {}

 # This variable is not used but is needed in order to allow .tfvars.json to contain the value which is required by the Azure CLI setup
 # Adding it here to prevent warning/error
variable "terraform_backend_state_container_name" {}