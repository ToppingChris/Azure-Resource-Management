powershell `
# define template path variable
$template_file = "C:\Users\dasfl\Git\Azure-Resource-Management\arm_template.json" `

# set account context
az account set --subscription {id or name}

# deploy the blank template to start with
az deployment group create `
    --name blanktemplate `
    --resource-group rg_arm `
    --template-file $template_file

# add storage to the template
az deployment group create `
    --name addstorage `
    --resource-group rg_arm `
    --template-file $template_file

# add name parameter to the template
az deployment group create `
    --name addnameparameter `
    --resource-group rg_arm `
    --template-file $template_file `
    --parameters storageName=armsact20201022

# add sku parameter
az deployment group create `
    --name addskuparameter `
    --resource-group rg_arm `
    --template-file $template_file `
    --parameters storageName=armsact20201022

# set sku parameter to Standard_GRS (non-default value) and new storage account name
# this creates a new storage account with the new name and new sku
az deployment group create `
    --name usenondefaultsku `
    --resource-group rg_arm `
    --template-file $template_file `
    --parameters storageSKU=Standard_GRS storageName=armsact20201022v2

# test inserting sku value that is not allowed, i.e. basic
az deployment group create `
    --name testskuparameter `
    --resource-group rg_arm `
    --template-file $template_file `
    --parameters storageSKU=basic storageName=armsact20201022v2

    # The following error is returned

    # Azure Error: InvalidTemplate
    # Message: Deployment template validation failed: 'The provided value 'Azure.ResourceManager.Deployments.Core.Entities.TemplateGenericProperty`1[Newtonsoft.Json.Linq.JToken]' for the template parameter 'storageSKU' at line '13' and column '24' is not valid. The parameter value is not part of the allowed value(s): 'Standard_LRS,Standard_GRS,Standard_RAGRS,Standard_ZRS,Premium_LRS,Premium_ZRS,Standard_GZRS,Standard_RAGZRS'.'.
    # Additional Information:
    #         Type: TemplateViolation
    #         Info: {
    #             "lineNumber": 13,
    #             "linePosition": 24,
    #             "path": "properties.template.parameters.storageSKU.allowedValues"
    #         }


# add location parameter and function to set to the same location as the resource group
# and new storage account name
az deployment group create `
    --name addlocationparameter `
    --resource-group rg_arm `
    --template-file $template_file `
    --parameters storageName=armsact20201022v3

# add variable to create unique storage account name. Creates a 13 character hash
# value of the resource group id and adds to the the prefix defined in the deployment
az deployment group create `
    --name addnamevariable `
    --resource-group rg_arm `
    --template-file $template_file `
    --parameters storagePrefix=store storageSKU=Standard_LRS

# add output to capture the primary endpoints of the storage account
az deployment group create `
    --name addoutputs `
    --resource-group rg_arm `
    --template-file $template_file `
    --parameters storagePrefix=store storageSKU=Standard_LRS

# output of deployment command
# "outputs": {
#     "storageEndpoint": {
#       "type": "Object",
#       "value": {
#         "blob": "https://storewkpbhq2r72ui6.blob.core.windows.net/",
#         "dfs": "https://storewkpbhq2r72ui6.dfs.core.windows.net/",
#         "file": "https://storewkpbhq2r72ui6.file.core.windows.net/",
#         "queue": "https://storewkpbhq2r72ui6.queue.core.windows.net/",
#         "table": "https://storewkpbhq2r72ui6.table.core.windows.net/",
#         "web": "https://storewkpbhq2r72ui6.z33.web.core.windows.net/"
#       }
#     }
#   }

# add app service plan from exported template to existing template
az deployment group create `
    --name addappserviceplan `
    --resource-group rg_arm `
    --template-file $template_file `
    --parameters storagePrefix=store storageSKU=Standard_LRS

# add web app from quickstart template on Github
az deployment group create `
  --name addwebapp `
  --resource-group rg_arm `
  --template-file $template_file `
  --parameters storagePrefix=store storageSKU=Standard_LRS webAppName=demoapp

# add resource tags
az deployment group create `
    --name addtags `
    --resource-group rg_arm `
    --template-file $template_file `
    --parameters storagePrefix=store storageSKU=Standard_LRS webAppName=demoapp

# use parameter files to deploy to dev and prod

# create new dev resource group and reference dev params file
$template_file="C:\Users\dasfl\Git\Azure-Resource-Management\arm_template.json" 
$devParameterFile="C:\Users\dasfl\Git\Azure-Resource-Management\arm_parameters_dev.json" 
az group create `
    --name rg_arm_dev `
    --location "uksouth" 
az deployment group create `
    --name devenvironment `
    --resource-group rg_arm_dev `
    --template-file $template_file `
    --parameters $devParameterFile

# create a new Prod resource group amd reference Prod params file
$prodParameterFile="C:\Users\dasfl\Git\Azure-Resource-Management\arm_parameters_prod.json"
az group create `
    --name rg_arm_prod `
    --location "uksouth"
az deployment group create `
    --name prodenvironment `
    --resource-group rg_arm_prod `
    --template-file $template_file `
    --parameters $prodParameterFile