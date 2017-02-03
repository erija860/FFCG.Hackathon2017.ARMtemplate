<#

Login-AzureRmAccount
Get-AzureRmSubscription
Get-AzureRmContext
Add-AzureRmAccount
Get-AzureRmResourceGroup

#See available locations of resource
$resources = Get-AzureRmResourceProvider -ProviderNamespace Microsoft.DataLakeStore
$resources.ResourceTypes.Where{($_.ResourceTypeName -eq 'accounts')}.Locations

#Choose subscription to use
Set-AzureRmContext -SubscriptionName "Visual Studio Enterprise"

#Create new Resource Group
New-AzureRmResourceGroup -Name test-analytics-dev-rg -Location "North Europe"

#Delete Resource Group
Remove-AzureRmResourceGroup -Name test-analytics-dev-rg

#Get Resource Group
Get-AzureRmResourceGroup -ResourceGroupName test-analytics-dev-rg

#Test delpoyment beforehand
Test-AzureRmResourceGroupDeployment -ResourceGroupName test-analytics-dev-rg `
-TemplateFile C:\dev\NCG.Customer\NCG.Customer.Analytics\scripts\ARM\template.json `
-TemplateParameterFile C:\dev\NCG.Customer\NCG.Customer.Analytics\scripts\ARM\parameters.json

#Deploy new resources into resource group
New-AzureRmResourceGroupDeployment -Mode Incremental `
-Name TestDeployment `
-ResourceGroupName test-analytics-dev-rg `
-TemplateFile C:\dev\NCG.Customer\NCG.Customer.Analytics\scripts\ARM\template.json `
-TemplateParameterFile C:\dev\NCG.Customer\NCG.Customer.Analytics\scripts\ARM\parameters.json


#>




$subscriptionName = "Visual Studio Enterprise"
$resourceGroupName = "ffcg-hackathon2017-rg"
$resourceGroupLocation ="North Europe"
$templateFilePath = "template.json"
$parametersFilePath = "parameters.json"

# sign in
Write-Host "Logging in...";
Login-AzureRmAccount;

# select subscription
Write-Host "Selecting subscription '$subscriptionName'";
Set-AzureRmContext -SubscriptionName "Visual Studio Enterprise"


#Create or check for existing resource group
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
    Write-Host "Creating resource group '$resourceGroupName' in location '$resourceGroupLocation'";
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
}
else{
    Write-Host "Using existing resource group '$resourceGroupName'";
}


#Test delpoyment beforehand
Test-AzureRmResourceGroupDeployment `
-ResourceGroupName $resourceGroupName `
-TemplateFile $templateFilePath `
-TemplateParameterFile $parametersFilePath;


# Start the deployment
Write-Host "Starting deployment...";
 New-AzureRmResourceGroupDeployment `
-ResourceGroupName $resourceGroupName `
-TemplateFile $templateFilePath `
-TemplateParameterFile $parametersFilePath

# Start the deployment
Write-Host "Starting deployment...";
 New-AzureRmResourceGroupDeployment `
-ResourceGroupName $resourceGroupName `
-TemplateFile "dbtemplate.json"