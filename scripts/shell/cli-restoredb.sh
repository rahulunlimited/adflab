################### 01 - Assign Global Variables
#******PLEASE UPDATE THIS****************
SUBSCRIPTIONID="5f454d76-f1a1-4e10-ba09-e6cc9296f7e2"
RESOURCEGROUP="ResG-ADF"
PROJECTPREFIX="vlradf1"

################### 02 - Assign Resource Variables
#******PLEASE DO NOT UPDATE INFORMATION BELOW THIS SECTION****************
keyVaultName="$PROJECTPREFIX"kv
sqlServerName="$PROJECTPREFIX"sql


#########################Restore Database 

#Assign variable for Database
sqlADFLabDB="adflab"
sqlADFUser="veladmin"
#Get password from KeyVault
pwdSQLAdmin=$(az keyvault secret show --name db-adflab-password --vault-name $keyVaultName --query value -o tsv)
echo $pwdSQLAdmin
#Get Storage Key from KeyVault
storageKey=$(az storage account keys list --account-name vlrlearn --query [0].value -o tsv)
echo $storageKey
#Restore the bacpac for adflab. Please note an empty database should be present before importing the bacpac
az sql db import -s $sqlServerName -n $sqlADFLabDB -g $RESOURCEGROUP -p $pwdSQLAdmin -u $sqlADFUser --storage-key $storageKey --storage-key-type StorageAccessKey --storage-uri https://vlrlearn.blob.core.windows.net/bacpac/adflab.bacpac

#Create a new empty database for WideWorldImporters
#az sql db create -g $RESOURCEGROUP -s $sqlServerName -n $dbWideWorldImporters --service-objective S4
#Restore the bacpac from Azure Storage
#az sql db import -s $sqlServerName -n $dbWideWorldImporters -g $RESOURCEGROUP -p $pwdSQLAdmin -u $sqlADFUser --storage-key $storageKey --storage-key-type StorageAccessKey --storage-uri https://vlrlearn.blob.core.windows.net/bacpac/WideWorldImporters-Standard.bacpac

#########################Service Object for Database
#Update the adflab databse to S0
az sql db update -g $RESOURCEGROUP -s $sqlServerName -n $sqlADFLabDB --service-objective S0
#Update the WideWorldImporters database to S0
#az sql db update -g $RESOURCEGROUP -s $sqlServerName -n $dbWideWorldImporters --service-objective S0
