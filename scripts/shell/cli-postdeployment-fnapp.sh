################### 01 - Assign Global Variables
#******PLEASE UPDATE THIS****************
SUBSCRIPTIONID="5f454d76-f1a1-4e10-ba09-e6cc9296f7e2"
RESOURCEGROUP="RG-ADF"
PROJECTPREFIX="vlx1"

################### 02 - Assign Resource Variables
#******PLEASE DO NOT UPDATE INFORMATION BELOW THIS SECTION****************
keyVaultName="$PROJECTPREFIX"kv
fnAppName="$PROJECTPREFIX"fnApp

fnAppId=$(az ad sp list --display-name $fnAppName --query [].objectId -o tsv)
echo $fnAppId
#Assign Access Policy
az keyvault set-policy --name $keyVaultName --object-id $fnAppId --secret-permissions get
