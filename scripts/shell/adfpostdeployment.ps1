$RESOURCEGROUP="RG-ADF"
$PROJECTPREFIX="vladflab1"

$keyVaultName=$PROJECTPREFIX + "kv"
$dataFactoryName=$PROJECTPREFIX + "adf"


Set-AzKeyVaultAccessPolicy -VaultName $keyVaultName -ObjectId (Get-AzDataFactoryV2 -ResourceGroupName $RESOURCEGROUP -Name $dataFactoryName).Identity.PrincipalId -PermissionsToSecrets get
