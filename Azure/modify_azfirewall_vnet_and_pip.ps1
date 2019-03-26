$azFw=Get-AzFirewall -Name "my-firewall" -ResourceGroupName "rg-silveira"
$azFw.Deallocate()
Set-AzFirewall -AzureFirewall $azfw

# Change Firewall vnet and pip
$vnet=Get-AzVirtualNetwork -Name "vnet-test" -ResourceGroupName "study-rg"
$publicIp=Get-AzPublicIpAddress -Name "azureFirewall-ip" -ResourceGroupName "study-rg"
$azFw=Get-AzFirewall -Name "my-firewall" -ResourceGroupName "rg-silveira"
$azFw.Allocate($vnet, $publicIp)
Set-AzFirewall -AzureFirewall $azfw