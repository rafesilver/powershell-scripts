param(
    $resourceGroupName = "myvmresourcegroup",
    $location = "southcentralus",

    # Network Parameters
    $virtualNetworkName = "myvnet",
    $subnetName = "defaultSubnet",

    $virtualNetworkAddressSpace = "10.0.0.0/16",
    $subnetAddressSpace = "10.0.0.0/24",

    # Public IP address parameters
    $pipName = "mypip",

    # Network Interface Parameters
    $nicName = "myvmnic",

    # VM Parameters
    $vmName = "myvm",
    $osType = "Windows",
    $vmSize = "Standard_D1_v2",
    $storageAccountType = "Standard_LRS",
    $vmUsername = " ",
    $cleartextVmPassword = " ",

    # Automatic parameters
    $vmPrefixName = "mytestvm",
    $nicPrefixName = "mynic",
    $pipPrefixName = "mypip",

    $numVmsToDeploy = 2
)


$ErrorActionPreference = "stop"



# Get VNet object from Azure
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $resourceGroupName `
                                  -Name $virtualNetworkName


# Get subnet object from Azure
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet `
                                                -Name $subnetName

$myCredentialObject = New-Object System.Management.Automation.PSCredential($vmUsername, $secureVmPassword)

# Create credential object
$secureVmPassword = ConvertTo-SecureString -String $cleartextVmPassword `
                                           -AsPlainText `
                                           -Force


for($i=1; $i -le $numVmsToDeploy; $i++)
{
    $vmName = $vmPrefixName + $($i.ToString("00"))
    $nicName = $nicPrefixName + $($i.ToString("00"))
    $pipName = $pipPrefixName + $($i.ToString("00"))
    # Create public IP address
    $pip = New-AzureRmPublicIpAddress -ResourceGroupName $resourceGroupName `
                                      -Name $pipName `
                                      -Location $location `
                                      -AllocationMethod Dynamic

    # Create a Network Interface Card (NIC)
    $nic = New-AzureRmNetworkInterface -ResourceGroupName $resourceGroupName `
                                       -Name $nicName `
                                       -Location $location `
                                       -PublicIpAddress $pip `
                                       -Subnet $subnet

    # Create VM config object (local)
    $vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize
    Set-AzureRmVMOperatingSystem -VM $vmConfig -Windows -ComputerName $vmName -Credential $myCredentialObject

    Set-AzureRmVMSourceImage -VM $vmConfig `
                             -PublisherName MicrosoftWindowsServer `
                             -Offer WindowsServer `
                             -Skus 2016-Datacenter `
                             -Version "latest"

    Add-AzureRmVMNetworkInterface -VM $vmConfig `
                                  -NetworkInterface $nic

    Set-AzureRmVMOSDisk -VM $vmConfig -Name "$($vmName)-osdisk" `
                        -CreateOption FromImage `
                        -StorageAccountType $storageAccountType

    Set-AzureRmVMBootDiagnostics -VM $vmConfig -Disable

    New-AzureRmVM -ResourceGroupName $resourceGroupName `
              -VM $vmConfig `
              -Location $location
}