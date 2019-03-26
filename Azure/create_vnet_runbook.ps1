param(
    # Resource Group parameters
    $resourceGroupName = "myvmresourcegroup",
    $location = "southcentralus",

    # Network parameters
    $virtualNetworkName,
    $subnetName = "defaultSubnet",
    $virtualNetworkAddressSpace = "10.0.0.0/16",
    $subnetAddressSpace = "10.0.0.0/24"
)
##############################

$ErrorActionPreference = "Stop"

# Run the script using the Run As Account (Service Principal)

$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName        

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

##############################

# Create a resource group
New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

# Create a subnet config
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $subnetName `
                                                      -AddressPrefix $subnetAddressSpace
                                                      
# Create our vnet
$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $resourceGroupName `
                                  -Name $virtualNetworkName `
                                  -Location $location `
                                  -AddressPrefix $virtualNetworkAddressSpace `
                                  -Subnet $subnetConfig