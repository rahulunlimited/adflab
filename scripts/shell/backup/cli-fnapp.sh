#There are issues upload the .zip file to GitHub and then downloading.
#Thus, in this step, I manually uploaded the zip file to Cloudshell and then executed it. 
#TO BE FIXED

################### 01 - Assign Global Variables
#******PLEASE UPDATE THIS****************
SUBSCRIPTIONID="ab908bd9-4099-4869-9111-8e2f703691c0"
RESOURCEGROUP="RG-adflab"
PROJECTPREFIX="rgadfl01"
DOMAIN="insight.com"

myusername='Rahul.Agrawal@insight.com'

################### 02 - Assign Resource Variables
#******PLEASE DO NOT UPDATE INFORMATION BELOW THIS SECTION****************
keyVaultName="$PROJECTPREFIX"kv
fnAppName="$PROJECTPREFIX"fnApp

################### 04 - Import Function App
#Import Function App from the Cloudshell storage in Zip format
#Function App is required to archive and check files for File Storage
#Copy the file from GitHub to a local folder on Cloudshell
#Switch -P for directory
#Switch --nc --no-clobber for overwriting the file else the files are downloaded with the name .1 .2
#wget --no-clobber -P ~/clouddrive/adflab/fnapp/ "https://github.com/rahulunlimited/adflab/blob/master/functionapp/AzFnFileService.zip"
#Execute the Zip Deployment
az functionapp deployment source config-zip -g $RESOURCEGROUP -n $fnAppName --src ~/clouddrive/adflab/fnapp/AzFnFileService.zip

###Function app
#Set the System Assigned property for Function App
az webapp identity assign --name $fnAppName --resource-group $RESOURCEGROUP

