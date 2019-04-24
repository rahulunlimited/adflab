#PLEASE UPDATE THE BELOW SECTION
$RESOURCEGROUP="RG-ADF"
$PROJECTPREFIX="vlx1"

#Variables. 
#PLEASE DO NOT UPDATE THIS
$keyVaultName=$PROJECTPREFIX + "kv"
$dataFactoryName=$PROJECTPREFIX + "adf"

#Update the Key Vault Access Policy for Data Factory
#***Currently there is no Azure CLI for Data Factory. Once the CLI is available the script can be converted from PowerShell
Set-AzKeyVaultAccessPolicy -VaultName $keyVaultName -ObjectId (Get-AzDataFactoryV2 -ResourceGroupName $RESOURCEGROUP -Name $dataFactoryName).Identity.PrincipalId -PermissionsToSecrets get
