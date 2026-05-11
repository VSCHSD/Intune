#Variables to define the Windows OS / Edition etc to be applied during OSDCloud
$OSName = 'Windows 11 25H2 x64'
$OSEdition = 'Pro'
$OSActivation = 'Retail'
$OSLanguage = 'en-us'

#Set OSDCloudCLI Variables
$Global:MyOSDCloud = [ordered]@{
        MSCatalogFirmware = [bool]$true
        MSCatalogDiskDrivers = [bool]$true
        MSCatalogNetDrivers = [bool]$true
        MSCatalogScsiDrivers = [bool]$true
        Restart = [bool]$true
        ZTI = [bool]$true
}

#Set OSDCloudGUI Variables
$OSDModuleResource.StartOSDCloudGUI = @{
    BrandName   = 'Valley Stream Central High School District'

    OSEdition = $OSEdition
    OSActivation = $OSActivation
    OSLanguage = $OSLanguage

    ClearDiskConfirm       = $false
    restartComputer        = $true
    captureScreenshots     = $false

    updateDiskDrivers      = $true
    updateFirmware         = $true
    updateNetworkDrivers   = $true
    updateSCSIDrivers      = $true
    SyncMSUpCatDriverUSB   = $true

    OEMActivation          = $true
    WindowsUpdate          = $true
    WindowsUpdateDrivers   = $true
    WindowsDefenderUpdate  = $true
}

#Set BIOS Settings
$Manufacturer = (Get-MyComputerManufacturer -Brief)
if ($Manufacturer -match 'Dell|Alienware') {
    Write-Host "Manufacturer is $Manufacturer, setting BIOS settings" -ForegroundColor Green
    Invoke-WebPSScript 'https://raw.githubusercontent.com/VSCHSD/Intune/refs/heads/main/OSDCloud/Manage-DellBiosSettings.ps1'
}
if ($Manufacturer -match 'HP|Hewlett') {
    Write-Host "Manufacturer is $Manufacturer, setting BIOS settings" -ForegroundColor Green
    Invoke-WebPSScript 'https://raw.githubusercontent.com/VSCHSD/Intune/refs/heads/main/OSDCloud/Manage-HPBiosSettings.ps1'
}


do {

    Write-Host ""
    Write-Host "===== OSDCloudCLI Configuration =====" -ForegroundColor Cyan
    Write-Host "OS Name       : $OSName"
    Write-Host "OS Edition    : $OSEdition"
    Write-Host "Activation    : $OSActivation"
    Write-Host "Language      : $OSLanguage"
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Select OSDCloud startup mode:" -ForegroundColor Cyan
    Write-Host "1. Start OSDCloudCLI Unattended (With the options above)"
    Write-Host "2. Start OSDCloudGUI (To pick others)"
    Write-Host ""


    $Choice = Read-Host "Enter selection (1 or 2)"

    if ($Choice -notin '1','2') {
        Write-Host "Invalid selection. Please enter 1 or 2." -ForegroundColor Yellow
    }

} until ($Choice -in '1','2')

switch ($Choice) {
    '1' {
        #Launch OSDCloud
        Write-Host "Starting OSDCloudCLI -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage" -ForegroundColor Green
        Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage
    }
    '2' {
        Write-Host "Starting OSDCloudGUI..." -ForegroundColor Green
        Start-OSDCloudGUI
    }
}