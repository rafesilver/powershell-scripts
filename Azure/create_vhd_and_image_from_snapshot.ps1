#Provide the subscription Id of the subscription where snapshot will be created
Login-AzAccount
$subscriptionId = Get-AzSubscription | Out-GridView -PassThru
Select-AzSubscription -Subscription $subscriptionId

#Provide the name of your resource group where snapshot is created
$resourceGroupName =" "

#Provide the snapshot name 
$snapshotName = " "

#Provide Shared Access Signature (SAS) expiry duration in seconds e.g. 3600.
#Know more about SAS here: https://docs.microsoft.com/en-us/Az.Storage/storage-dotnet-shared-access-signature-part-1
$sasExpiryDuration = "3600"

#Provide storage account name where you want to copy the snapshot. 
$storageAccountName = " "

#Name of the storage container where the downloaded snapshot will be stored
$storageContainerName = " "

#Provide the key of the storage account where you want to copy snapshot. 
$storageAccountKey = ' '

#Provide the name of the VHD file to which snapshot will be copied.
$destinationVHDFileName = "ubuntu-image.vhd"

#Generate the SAS for the snapshot 
$sas = Grant-AzSnapshotAccess `
        -ResourceGroupName $ResourceGroupName `
        -SnapshotName $SnapshotName  `
        -DurationInSecond $sasExpiryDuration `
        -Access Read 
 
#Create the context for the storage account which will be used to copy snapshot to the storage account 
$destinationContext = New-AzStorageContext `
        –StorageAccountName $storageAccountName `
        -StorageAccountKey $storageAccountKey  

#Copy the snapshot to the storage account 
Start-AzStorageBlobCopy `
        -AbsoluteUri $sas.AccessSAS `
        -DestContainer $storageContainerName `
        -DestContext $destinationContext `
        -DestBlob $destinationVHDFileName


# Create Image from Snapshot
$urlOfUploadedImageVhd = "https://" + $storageAccountName + ".blob.core.windows.net/" + $storageContainerName + "/" + $destinationVHDFileName

$location = "East US"
$imageName = "myUbuntu"

$imageConfig = New-AzImageConfig `
        -Location $location
$imageConfig = Set-AzImageOsDisk `
        -Image $imageConfig `
        -OsType Linux `
        -OsState Generalized `
        -BlobUri $urlOfUploadedImageVhd `
        -DiskSizeGB 30
New-AzImage `
        -ImageName $imageName `
        -ResourceGroupName $resourceGroupName `
        -Image $imageConfig

<# Or use Azure CLI
az login
az account set --subscription $subscriptionId
az image create -g $resourceGroupName -n $imageName --os-type Linux --source $urlOfUploadedImageVhd
#>