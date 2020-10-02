# to create resources for Databricks ETL training module

# create resource group to hold resources
powershell `
az group create `
    --name rg_databricks `
    --location uksouth 

# create blob storage account
az storage account create `
    --name sadatabricksblobct `
    --resource-group rg_databricks `
    --access-tier Hot `
    --kind Blobstorage `
    --location uksouth `
    --sku Standard_RAGRS `
    --default-action Allow

# create blob storage container - doesn't work due to network rules not being set - add a rule here
az storage container create `
    --account-name sadatabricksblobct `
    --name sadatabricksblobcontainerct `
    --auth-mode login

# create Data Lake Gen 2 storage account
az storage account create `
    --name sadatabricksgen2ct `
    --resource-group rg_databricks `
    --access-tier Hot `
    --kind StorageV2 `
    --location uksouth `
    --sku Standard_RAGRS

# create a Databricks workspace
az databricks workspace create `
    --name ctdatabricksws `
    --location uksouth `
    --resource-group rg_databricks `
    --sku standard



    