$appgwname = "appgateway-eulex"
$appgwrg = "appgateway-eulex-rg"
$subscriptionid = "d231d663-ff2f-4e35-87a4-8d51a0b77560"
$userAssignedIdentity = "/subscriptions/d231d663-ff2f-4e35-87a4-8d51a0b77560/resourcegroups/appgateway-eulex-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/appgateway-eulex-mi"
$keyvault = "keyvault-eulex"
$keyvaultSubId = $subscriptionid
$certname = "cert1"


Set-AzContext -SubscriptionId $keyvaultSubId
$secret = Get-AzKeyVaultSecret -VaultName $keyvault -Name $certname 
$secretId = $secret.Id.Replace($secret.Version, "") # Remove the secret version so AppGW will use the latest version in future syncs

Set-AzContext -SubscriptionId $subscriptionid
$appgw = Get-AzApplicationGateway -Name $appgwname -ResourceGroupName $appgwrg
Set-AzApplicationGatewayIdentity -ApplicationGateway $appgw -UserAssignedIdentityId $userAssignedIdentity
Add-AzApplicationGatewaySslCertificate -KeyVaultSecretId $secretId -ApplicationGateway $appgw -Name $secret.Name
Set-AzApplicationGateway -ApplicationGateway $appgw
