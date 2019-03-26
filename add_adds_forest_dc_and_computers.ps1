$domain = 'corp.contoso.com'
$username = '$domain\username'
$password = ' ' | ConvertTo-SecureString -asPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username,$password)

#Install ADDS
Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools

#Install Forest
Install-ADDSForest -DomainName 'corp.contoso.com' -DomainNetbiosName 'CONTOSO' -InstallDns:$true -CreateDnsDelegation:$false -DomainMode '7' -ForestMode '7' -DatabasePath 'C:\Windows\NTDS' -LogPath 'C:\Windows\NTDS' -SysvolPath 'C:\Windows\SYSVOL' -NoRebootOnCompletion:$false -Force:$true

#Install DC
Install-ADDSDomainController -DomainName 'corp.contoso.com' -InstallDns:$true -CreateDnsDelegation:$false -NoGlobalCatalog:$false -SiteName 'Default-First-Site-Name' -DatabasePath 'C:\Windows\NTDS' -LogPath 'C:\Windows\NTDS' -SysvolPath 'C:\Windows\SYSVOL' -NoRebootOnCompletion:$false -Force:$true

#Add Computer to domain
Add-Computer -DomainName $domain -Credential $credential