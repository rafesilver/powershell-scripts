# Resource Group parameters
$resourceGroupName = "myvmresourcegroup"
$location = "southcentralus"

# Network parameters
$virtualNetworkName = "myvnet"
$subnetName = "defaultSubnet"

$virtualNetworkAddressSpace = "10.0.0.0/16"
$subnetAddressSpace = "10.0.0.0/24"

##############################

$ErrorActionPreference = "Stop"

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


####### OR
<#

# Create our vnet
$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $resourceGroupName `
                                  -Name $virtualNetworkName `
                                  -Location $location `
                                  -AddressPrefix $virtualNetworkAddressSpace `

# Add subnet config to local vnet object
Add-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet `
                                      -Name $subnetName `
                                      -AddressPrefix $subnetAddressSpace

# Set new vnet config in Azure
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet

#>