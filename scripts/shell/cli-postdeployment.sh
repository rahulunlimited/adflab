################### 01 - Assign Global Variables
#******PLEASE UPDATE THIS****************
SUBSCRIPTIONID="1dd9e274-7c3d-4adc-bd5e-0d10e526efde"
RESOURCEGROUP="ResG-Test"
PROJECTPREFIX="radf"

myusername='Rahul.Agrawal@readify.net'

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

################### 03 - Import ADF 
#Assign varibales for ADF
keyVaultURL="https://$keyVaultName.vault.azure.net/"
ADLSURL="https://$dataLakeName.dfs.core.windows.net"
fileStorageUserId="AZURE\\$storageName"
###Deploy ADF and pass neccesary parameters
#Select the template from GitHub repo
#Pass parameter for Data Factory
#Other params = KeyVault URL, ADLS URL, File Storage UserID

#Get OnPrem Connection String
dbSourceOnPremConnStr=$(az keyvault secret show --name db-source-onprem-connstr --vault-name $keyVaultName --query value -o tsv)
echo $dbSourceOnPremConnStr
#Get Azure Connection String
dbSourceAzureConnStr=$(az keyvault secret show --name db-source-azure-connstr --vault-name $keyVaultName --query value -o tsv)
echo $dbSourceAzureConnStr

az group deployment create --resource-group $RESOURCEGROUP --template-uri https://raw.githubusercontent.com/rahulunlimited/adflab/master/adf/arm_template.json --parameters factoryName=$adfName LinkedServiceAzureKeyVault_properties_typeProperties_baseUrl=$keyVaultURL LinkedServiceAzureDLGen2Storage_properties_typeProperties_url=$ADLSURL LinkedServiceAzureFileStorage_properties_typeProperties_userId=$fileStorageUserId LinkedServiceSourceOnPremDatabase_connectionString="$dbSourceOnPremConnStr" LinkedServiceSourceAzureDatabase_connectionString="$dbSourceAzureConnStr" 

################### 04 - Import Function App
#Import Function App from the Cloudshell storage in Zip format
#Function App is required to archive and check files for File Storage
#Copy the file from GitHub to a local folder on Cloudshell
wget -P ~/clouddrive/adflab/fnapp/ "https://github.com/rahulunlimited/adflab/blob/master/functionapp/AzFnFileService.zip"
#Execute the Zip Deployment
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

#########################DB Admin
#Add User as Server AD Admin
az sql server ad-admin create --display-name $myusername --server $sqlServerName -g $RESOURCEGROUP -i $uid


#########################File Share
#Get the connection-string for Storage Account
storageConnStr=$(az keyvault secret show --name blob-connection-string --vault-name $keyVaultName --query value -o tsv)
echo $storageConnStr
#Create folder for source
az storage directory create --name src -s fshare --connection-string $storageConnStr
#Create folder for destination
az storage directory create --name dest -s fshare --connection-string $storageConnStr
#Download the file from GitHub to a local folder
wget -P ~/clouddrive/adflab/fileshare "https://github.com/rahulunlimited/adflab/blob/master/fileshare/AUS-State.csv"
#Copy a sample file to the source folder
az storage file upload -s fshare --source ~/clouddrive/adflab/fileshare/AUS-State.csv --connection-string $storageConnStr -p src


