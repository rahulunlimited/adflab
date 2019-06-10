################### 01 - Assign Global Variables
#******PLEASE UPDATE THIS****************
SUBSCRIPTIONID="5f454d76-f1a1-4e10-ba09-e6cc9296f7e2"
RESOURCEGROUP="ResG-ADF"
PROJECTPREFIX="vlradf1"

myusername='Rahul.Agrawal@velrada.com'

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
az keyvault set-policy --name $keyVaultName --upn "Rahul.Agrawal@velrada.com" --resource-group $RESOURCEGROUP --secret-permissions get list set

################### 03 - Import ADF 
#Assign varibales for ADF
keyVaultURL="https://$keyVaultName.vault.azure.net/"
ADLSURL="https://$dataLakeName.dfs.core.windows.net"
fileStorageUserId="AZURE\\$storageName"
###Deploy ADF and pass neccesary parameters
#Select the template from GitHub repo
#Pass parameter for Data Factory
#Other params = KeyVault URL, ADLS URL, File Storage UserID
az group deployment create --resource-group $RESOURCEGROUP --template-uri https://raw.githubusercontent.com/rahulunlimited/adflab/master/adf/arm_template.json --parameters factoryName=$adfName LinkedServiceAzureKeyVault_properties_typeProperties_baseUrl=$keyVaultURL LinkedServiceAzureDLGen2Storage_properties_typeProperties_url=$ADLSURL LinkedServiceAzureFileStorage_properties_typeProperties_userId=$fileStorageUserId

################### 04 - Import Function App
#Import Function App from the Cloudshell storage in Zip format
#Function App is required to archive and check files for File Storage
#*****Check if the functionapp zip file can be copied to GitHub*****
az functionapp deployment source config-zip -g $RESOURCEGROUP -n $fnAppName --src ~/clouddrive/adflab/fnapp/AzFnFileService.zip

################### 05 - Create App
#An App is required to connect to Data Lake Storage account.
#App also requires a Service Principal to be created
#Assign App URL
appURL="http://velrada.com/app/$appName"
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

#########################File Share
#Get the connection-string for Storage Account
storageConnStr=$(az keyvault secret show --name blob-connection-string --vault-name $keyVaultName --query value -o tsv)
echo $storageConnStr
#Create folder for source
az storage directory create --name src -s fshare --connection-string $storageConnStr
#Create folder for destination
az storage directory create --name dest -s fshare --connection-string $storageConnStr
#Copy a sample file to the source folder
az storage file upload -s fshare --source ~/clouddrive/adflab/fileshare/AUS-State.csv --connection-string $storageConnStr -p src


#########################Restore Database 
#Add User as Server AD Admin
az sql server ad-admin create --display-name $myusername --server $sqlServerName -g $RESOURCEGROUP -i $uid
#Assign variable for Database
sqlADFLabDB="adflab"
sqlADFUser="veladmin"
dbWideWorldImporters="WideWorldImporters"
#Get password from KeyVault
pwdSQLAdmin=$(az keyvault secret show --name db-adflab-password --vault-name $keyVaultName --query value -o tsv)
echo $pwdSQLAdmin
#Get Storage Key from KeyVault
storageKey=$(az storage account keys list --account-name vlrlearnstore --query [0].value -o tsv)
echo $storageKey
#Restore the bacpac for adflab. Please note an empty database should be present before importing the bacpac
az sql db import -s $sqlServerName -n $sqlADFLabDB -g $RESOURCEGROUP -p $pwdSQLAdmin -u $sqlADFUser --storage-key $storageKey --storage-key-type StorageAccessKey --storage-uri https://vlrlearnstore.blob.core.windows.net/sqldb/adflab.bacpac
#Create a new empty database for WideWorldImporters
az sql db create -g $RESOURCEGROUP -s $sqlServerName -n $dbWideWorldImporters --service-objective S4
#Restore the bacpac from Azure Storage
az sql db import -s $sqlServerName -n $dbWideWorldImporters -g $RESOURCEGROUP -p $pwdSQLAdmin -u $sqlADFUser --storage-key $storageKey --storage-key-type StorageAccessKey --storage-uri https://vlrlearnstore.blob.core.windows.net/sqldb/WideWorldImporters-Standard.bacpac

#########################Service Object for Database
#Update the adflab databse to S0
az sql db update -g $RESOURCEGROUP -s $sqlServerName -n $sqlADFLabDB --service-objective S0
#Update the WideWorldImporters database to S0
az sql db update -g $RESOURCEGROUP -s $sqlServerName -n $dbWideWorldImporters --service-objective S0
