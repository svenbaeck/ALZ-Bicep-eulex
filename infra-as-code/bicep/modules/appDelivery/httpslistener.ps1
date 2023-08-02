$appgwname = "elxaz-AppGateway"
$appgwrg = "elxaz-AppGateway-rg"
$subscriptionid = "bbabfd14-534f-4586-9a49-b13698b065c7"
$userAssignedIdentity = "/subscriptions/bbabfd14-534f-4586-9a49-b13698b065c7/resourcegroups/elxaz-AppGateway-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/elxaz-Managed-Identity-Keyvault"
$keyvault = "elxaz-keyvault"
$keyvaultSubId = "14572463-1a64-4daa-8790-57a395900deb"
$certname = "EULEXWebApps2023-2"


Set-AzContext -SubscriptionId $keyvaultSubId
$secret = Get-AzKeyVaultSecret -VaultName $keyvault -Name $certname 
$secretId = $secret.Id.Replace($secret.Version, "") # Remove the secret version so AppGW will use the latest version in future syncs

Set-AzContext -SubscriptionId $subscriptionid
$appgw = Get-AzApplicationGateway -Name $appgwname -ResourceGroupName $appgwrg
Set-AzApplicationGatewayIdentity -ApplicationGateway $appgw -UserAssignedIdentityId $userAssignedIdentity
Add-AzApplicationGatewaySslCertificate -KeyVaultSecretId $secretId -ApplicationGateway $appgw -Name $secret.Name
Set-AzApplicationGateway -ApplicationGateway $appgw
