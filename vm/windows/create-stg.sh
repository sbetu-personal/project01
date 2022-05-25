LOCATION=westeurope
subscription="xxxxxxxxxxxxxxxxxxxxxxx"
application=sampleapp

az account set --subscription "$subscription"

RESOURCE_GROUP_NAME=$application-terraform-rg

az group create -l $LOCATION -n $RESOURCE_GROUP_NAME \
    --tags ManagedBy="terraform"

STORAGE_ACCOUNT_NAME="${application}tfstg"

az storage account create -n $STORAGE_ACCOUNT_NAME -g $RESOURCE_GROUP_NAME -l $LOCATION --sku Standard_LRS
az storage container create --name state --account-name $STORAGE_ACCOUNT_NAME --auth-mode login