################### 01 - Assign Global Variables
SUBSCRIPTIONID="5f454d76-f1a1-4e10-ba09-e6cc9296f7e2"
RESOURCEGROUP="RG-Linx"
PROJECTPREFIX="vladf01"

sqlADFLabDB="adflab"
sqlADFUser="veladmin"

################### 02 - Assign Resource Variables
keyVaultName="$PROJECTPREFIX"kv
appName="$PROJECTPREFIX"app
dataLakeName="$PROJECTPREFIX"datalake
fnAppName="$PROJECTPREFIX"fnApp
umiName="$PROJECTPREFIX"umi
adfName="$PROJECTPREFIX"adf
sqlServerName="$PROJECTPREFIX"sql

scope="/subscriptions/$SUBSCRIPTIONID/resourceGroups/$RESOURCEGROUP/providers/Microsoft.Storage/storageAccounts/$dataLakeName"

################### 03 - Import ADF 
az group deployment create --resource-group $RESOURCEGROUP --template-uri https://raw.githubusercontent.com/rahulunlimited/adflab/master/adf/azuredeploy.json --parameters factoryName=$adfName

################### 04 - Import Function App
az functionapp deployment source config-zip -g $RESOURCEGROUP -n $fnAppName --src ~/clouddrive/adflab/fnapp/AzFnFileService.zip

################### 05 - Create App
appURL="http://velrada.com/app/$appName"
az ad app create --display-name $appName --identifier-uris $appURL --homepage $appURL 

#Get App ID
appId=$(az ad app list --display-name $appName --query [].appId -o tsv)
echo $appId

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

#Get the Service Principal Id
servicePrincipalAppId=$(az ad sp list --display-name $appName --query "[].appId" -o tsv)
echo $servicePrincipalAppId

#########################Assign Role for KeyVault##################################
#User
az keyvault set-policy --name $keyVaultName --upn "Rahul.Agrawal@velrada.com" --secret-permissions get list set
#App
az keyvault set-policy --name $keyVaultName --spn $appId --secret-permissions get
#User Managed Identity
umiId=$(az ad sp list --display-name $umiName --query [].objectId -o tsv)
az keyvault set-policy --name $keyVaultName --object-id $umiId --secret-permissions get

###Function app
#Set the System Assigned property for Function App
az webapp identity assign --name $fnAppName --resource-group $RESOURCEGROUP
#Get the Function ID
fnAppId=$(az ad sp list --display-name $fnAppName --query [].objectId -o tsv)
echo $fnAppId
#Assign Access Policy
az keyvault set-policy --name $keyVaultName --object-id $fnAppId --secret-permissions get

#########################Assing Role for Data Lake#################################
az role assignment create --role "Storage BLOB Data Contributor" --assignee-object-id $appObjectId --scope $scope


#########################Restore Database#########################################
dbWideWorldImporters="WideWorldImporters"
az sql db create -g $RESOURCEGROUP -s $sqlServerName -n $dbWideWorldImporters --service-objective S4

pwdSQLAdmin=$(az keyvault secret show --name db-adflab-password --vault-name $keyVaultName --query value -o tsv)
echo $pwdSQLAdmin

storageKey=$(az storage account keys list --account-name vlrlearnstore --query [0].value -o tsv)
echo $storageKey

az sql db import -s $sqlServerName -n $dbWideWorldImporters -g $RESOURCEGROUP -p $pwdSQLAdmin -u $sqlADFUser --storage-key $storageKey --storage-key-type StorageAccessKey --storage-uri https://vlrlearnstore.blob.core.windows.net/sqldb/WideWorldImporters-Standard.bacpac

az sql db update -g $RESOURCEGROUP -s $sqlServerName -n $dbWideWorldImporters --service-objective S0

az sql db update -g $RESOURCEGROUP -s $sqlServerName -n $sqlADFLabDB --service-objective S4

az sql db import -s $sqlServerName -n $sqlADFLabDB -g $RESOURCEGROUP -p $pwdSQLAdmin -u $sqlADFUser --storage-key $storageKey --storage-key-type StorageAccessKey --storage-uri https://vlrlearnstore.blob.core.windows.net/sqldb/adflab.bacpac

az sql db update -g $RESOURCEGROUP -s $sqlServerName -n $sqlADFLabDB --service-objective S0

#########################File Share#####################################################
storageConnStr=$(az keyvault secret show --name blob-connection-string --vault-name $keyVaultName --query value -o tsv)
echo $storageConnStr

az storage directory create --name src -s fshare --connection-string $storageConnStr
az storage directory create --name dest -s fshare --connection-string $storageConnStr

az storage file upload -s fshare --source ~/clouddrive/adflab/fileshare/AUS-State.csv --connection-string $storageConnStr -p src

