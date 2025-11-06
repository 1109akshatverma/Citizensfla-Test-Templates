Param (
    [Parameter(Mandatory = $true)]
    [string]
    $AzureUserName,

    [string]
    $AzurePassword,

    [string]
    $AzureTenantID,

    [string]
    $AzureSubscriptionID,

    [string]
    $ODLID,

    [string]
    $DeploymentID,

    [string]
    $vmAdminUsername,

    [string]
    $adminPassword,

    [string]
    $trainerUserName,

    [string]
    $trainerUserPassword

)

Start-Transcript -Path C:\WindowsAzure\Logs\CloudLabsCustomScriptExtension.txt -Append
[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls" 

#Import Common Functions
$path = pwd
$path=$path.Path
$commonscriptpath = "$path" + "\cloudlabs-common\cloudlabs-windows-functions.ps1"
. $commonscriptpath
 
# Run Imported functions from cloudlabs-windows-functions.ps1
WindowsServerCommon
InstallVSCode

# Installing Modern VM Validator
InstallModernVmValidator

CreateCredFile $AzureUserName $AzurePassword $AzureTenantID $AzureSubscriptionID $DeploymentID

Enable-CloudLabsEmbeddedShadow $vmAdminUsername $trainerUserName $trainerUserPassword

sleep 10

# Install git
choco install git.install -y -force

#Install Azure-cli
choco install azure-cli -y -force

#Install .NET SDK
choco install dotnet-8.0-sdk -y --force

#Install Python 3.12
choco install python --version=3.12.1 -y -force

# Install nodejs
choco install nodejs.install

Stop-Transcript
Restart-Computer -Force 