$subscriptionId = Get-AzSubscription | Out-GridView -PassThru
Select-AzSubscription -Subscription $subscriptionId

$resourceGroupName = 'rg-billing'
$storageAccountName = 'downloadbilling'
$containerName = 'billing'
$fileName = 'latest.csv'

$ctx = (Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName).Context

#Get invoice
$invoiceObject = Get-AzBillingInvoice -Latest
#$webClient = New-Object -TypeName System.Net.WebClient
#[Byte[]] $invoice = $webClient.DownloadData($invoiceObject.DownloadUrl) 

#Download offline
#Invoke-WebRequest -uri $inv.downloadurl -outfile ('c:\billing\' + $inv.name + '.pdf') 

#Upload to Blob
Set-AzStorageBlobContent -File $invoiceObject.DownloadUrl -Container $containerName -Blob $fileName -Context $ctx
