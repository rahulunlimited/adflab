################### 01 - Assign Global Variables
#******PLEASE UPDATE THIS****************
SUBSCRIPTIONID="ab908bd9-4099-4869-9111-8e2f703691c0"
RESOURCEGROUP="RG-adflab"
PROJECTPREFIX="rgadflau01dev"
DOMAIN="insight.com"

myusername='Rahul.Agrawal@insight.com'

################### 02 - Assign Resource Variables
#******PLEASE DO NOT UPDATE INFORMATION BELOW THIS SECTION****************
keyVaultName="$PROJECTPREFIX"kv
appName="$PROJECTPREFIX"app
dataLakeName="$PROJECTPREFIX"datalake
fnAppName="$PROJECTPREFIX"fnApp
umiName="$PROJECTPREFIX"umi
adfName="$PROJECTPREFIX"adf
sqlServerName="$PROJECTPREFIX"sql
storageName="$PROJECTPREFIX"storage
scope="/subscriptions/$SUBSCRIPTIONID/resourceGroups/$RESOURCEGROUP/providers/Microsoft.Storage/storageAccounts/$dataLakeName"

uid=$(az ad user list --upn $myusername --query "[].objectId" -o tsv)

#Set Key Access Policyy for User
az keyvault set-policy --name $keyVaultName --upn $myusername --resource-group $RESOURCEGROUP --secret-permissions get list set



################### 05 - Create App
#An App is required to connect to Data Lake Storage account.
#App also requires a Service Principal to be created
#Assign App URL
appURL="http://$DOMAIN/app/$appName"
#Create the App
az ad app create --display-name $appName --identifier-uris $appURL --homepage $appURL 
#Get App ID
appId=$(az ad app list --display-name $appName --query [].appId -o tsv)
echo $appId
#Add AppID to KeyVault
az keyvault secret set --vault-name $keyVaultName --name 'app-adflab-id' --value "$appId"
###Assign Permissions to App
#Assign User Impersonation for Data Lake
az ad app permission add --id $appId --api e9f49c6b-5ce5-44c8-925d-015017e9f7ad --api-permission 9f15d22d-3cdf-430f-ba48-f75401c0408e=Scope
#Assign User Read for Active Directory Graph
az ad app permission add --id $appId --api 00000003-0000-0000-c000-000000000000 --api-permission e1fe6dd8-ba31-4d61-89e7-88639da4683d=Scope
#Create Service Principal for the App
az ad sp create --id $appId
#Get the ObjectId for Service Principal
appObjectId=$(az ad sp list --display-name $appName --query [].objectId -o tsv)
echo $appObjectId
#Get the Service Principal Id from the ObjectId
servicePrincipalAppId=$(az ad sp list --display-name $appName --query "[].appId" -o tsv)
echo $servicePrincipalAppId
#Create a new app secret for 5 years validity
appSecret=$(az ad app credential reset --id $appId --credential-description adflab --years 5 --query password -o tsv)
#Add App Secret to KeyVault
az keyvault secret set --vault-name $keyVaultName --name 'app-adflab-secret' --value "$appSecret"


##################### Assign Role for KeyVault
#App
az keyvault set-policy --name $keyVaultName --spn $appId --secret-permissions get
#Get the User Managed Identity
umiId=$(az ad sp list --display-name $umiName --query [].objectId -o tsv)
#Assign Policy to UMI
az keyvault set-policy --name $keyVaultName --object-id $umiId --secret-permissions get

###Function app
#Set the System Assigned property for Function App
az webapp identity assign --name $fnAppName --resource-group $RESOURCEGROUP

####################### Assing Role for Data Lake
az role assignment create --role "Storage BLOB Data Contributor" --assignee-object-id $appObjectId --scope $scope

#Get the Function ID
fnAppId=$(az ad sp list --display-name $fnAppName --query [].objectId -o tsv)
echo $fnAppId
#Assign Access Policy
az keyvault set-policy --name $keyVaultName --object-id $fnAppId --secret-permissions get

