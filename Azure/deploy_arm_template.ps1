$armTemplateFilePath = "file.json"
$armTemplateParameterFile = "file.parameters.json"

$rgName = "rg-test"
$location = "southcentralus"

New-AzResourceGroup -Name $rgName -Location $location 

New-AzResourceGroupDeployment -Name "test-deployment" `
                            -ResourceGroupName $rgName `
                            -Mode Incremental `
                            -TemplateFile $armTemplateFilePath `
                            -TemplateParameterFile $armTemplateParameterFile