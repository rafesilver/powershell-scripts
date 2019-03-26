$domain = ' '
$password = ' ' | ConvertTo-SecureString -asPlainText -Force
$username = '$domain\username'
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential