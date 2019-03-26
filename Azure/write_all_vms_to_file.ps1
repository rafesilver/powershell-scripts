$file="Azure-ARM-VMs.csv"


Login-AzAccount 
$subs = Get-AzSubscription 

$vmobjs = @()

foreach ($sub in $subs)
{
    
    Write-Host Processing subscription $sub.SubscriptionName

    try
    {

        Select-AzSubscription -SubscriptionId $sub.SubscriptionId -ErrorAction Continue

        $vms = Get-AzVm

        foreach ($vm in $vms)
        {
            $vmInfo = [pscustomobject]@{
                'Subscription'=$sub.Name
                'ResourceGroupName' = $vm.ResourceGroupName
                'Name'=$vm.Name
                'Ambiente' = $null
                'Status' = $null
                'Location' = $vm.Location
                'VMSize' = $vm.HardwareProfile.VMSize
                'AvailabilitySet' = $vm.AvailabilitySetReference.Id
                }

        
            $vmStatus = $vm | Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Status
            $vmInfo.Status = $vmStatus.Statuses[1].DisplayStatus

            $vmInfo.Ambiente = $vm.Tags['Ambiente']

            $vmobjs += $vmInfo

        }  
    }
    catch
    {
        Write-Host $error[0]
    }
}

$vmobjs | Export-Csv -NoTypeInformation -Path $file
Write-Host "VM list written to $file"