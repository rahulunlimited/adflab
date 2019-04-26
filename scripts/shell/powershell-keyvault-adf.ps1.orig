#PLEASE UPDATE THE BELOW SECTION
<<<<<<< HEAD
$RESOURCEGROUP="ADFLab"
$PROJECTPREFIX="vladf01"

#Variables. 
#PLEASE DO NOT UPDATE THIS
=======
$RESOURCEGROUP="RG-ADF"
$PROJECTPREFIX="vlr1"
#Variables. PLEASE DO NOT UPDATE THIS
>>>>>>> 48ee06ef655f695bfb84515b703cbd8e25cfb587
$keyVaultName=$PROJECTPREFIX + "kv"
$dataFactoryName=$PROJECTPREFIX + "adf"
#Update the Key Vault Access Policy for Data Factory
#***Currently there is no Azure CLI for Data Factory. Once the CLI is available the script can be converted from PowerShell
Set-AzKeyVaultAccessPolicy -VaultName $keyVaultName -ObjectId (Get-AzDataFactoryV2 -ResourceGroupName $RESOURCEGROUP -Name $dataFactoryName).Identity.PrincipalId -PermissionsToSecrets get
