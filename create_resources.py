# Import the needed management objects from the libraries. The azure.common library
# is installed automatically with the other libraries.
from azure.common.client_factory import get_client_from_cli_profile
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.storage import StorageManagementClient
from azure.mgmt.storage.models import StorageAccountCreateParameters


# Obtain the management object for resources, using the credentials from the CLI login.
resource_client = get_client_from_cli_profile(ResourceManagementClient)
storage_client = get_client_from_cli_profile(StorageManagementClient)

# Provision the resource group.
rg_name = 'rg-databricks'
rg_location = 'uksouth'

def create_resource_group(rg_name, rg_location):
    rg_create = resource_client.resource_groups.create_or_update(
        rg_name,
        {
            "location": "uksouth"
        }
    )
    print("Resource group created - {} - in the location {}".format(rg_name, rg_location))

    return rg_create

def list_resource_groups():
    for rg in resource_client.resource_groups.list():
        rg_name = rg.name
        rg_location = rg.location
        rg_props = rg.properties.provisioning_state
        print(rg_name)
        print(rg_location)
        print(rg_props)

def delete_resource_group(group):
    resource_client.resource_groups.delete(group)
    print("Resource group {} deleted".format(group))

# this isn't working 
def check_storage_name_availability():
    acc_name = 'badname'
    print("Checking name...")
    availability = storage_client.storage_accounts.check_name_availability()
    print('The account {} is available: {}'.format(acc_name, availability.name_available))
    print('Reason: {}'.format(availability.reason))
    print('Detailed message: {}'.format(availability.message))
    return availability

def create_storage_account(rg, sa_name):
    storage_account = storage_client.storage_accounts.begin_create(
    rg,
    sa_name,
    StorageAccountCreateParameters(
        sku = 'Standard_RAGRS',
        kind = 'StorageV2',
        location = 'uksouth'
    )
    )
    print("Storage account created - {}".format(sa_name))
    result = storage_account.result()
    return result

# Within the ResourceManagementClient is an object named resource_groups,
# which is of class ResourceGroupsOperations, which contains methods like
# create_or_update.
#
# The second parameter to create_or_update here is technically a ResourceGroup
# object. You can create the object directly using ResourceGroup(location=LOCATION)
# or you can express the object as inline JSON as shown here. For details,
# see Inline JSON pattern for object arguments at
# https://docs.microsoft.com/azure/developer/python/azure-sdk-overview#inline-json-pattern-for-object-arguments.

#print(f"Provisioned resource group {rg_result.name} in the {rg_result.location} region")

# The return value is another ResourceGroup object with all the details of the
# new group. In this case the call is synchronous: the resource group has been
# provisioned by the time the call returns.

# Optional line to delete the resource group
#resource_client.resource_groups.delete("PythonAzureExample-ResourceGroup-rg")
#print("Resource group deleted")