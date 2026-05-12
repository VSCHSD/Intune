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
    $ScriptPath = "X:\OSDCloud\Manage-DellBiosSettings.ps1"

    Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/VSCHSD/Intune/refs/heads/main/OSDCloud/Manage-DellBiosSettings.ps1" `
    -OutFile $ScriptPath `
    -UseBasicParsing

    Start-Process `
    -FilePath "powershell.exe" `
    -ArgumentList "-ExecutionPolicy Bypass -File `"$ScriptPath`"" `
    -NoNewWindow `
    -Wait
}
if ($Manufacturer -match 'HP|Hewlett') {
    Write-Host "Manufacturer is $Manufacturer, setting BIOS settings" -ForegroundColor Green
    $ScriptPath = "X:\OSDCloud\Manage-HPBiosSettings.ps1"

    Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/VSCHSD/Intune/refs/heads/main/OSDCloud/Manage-HPBiosSettings.ps1" `
    -OutFile $ScriptPath `
    -UseBasicParsing

    Start-Process `
    -FilePath "powershell.exe" `
    -ArgumentList "-ExecutionPolicy Bypass -File `"$ScriptPath`"" `
    -NoNewWindow `
    -Wait
}


$TimeoutSeconds = 10
$Choice = $null

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

for ($i = $TimeoutSeconds; $i -ge 1; $i--) {
    Write-Host -NoNewline "`rDefaulting to option 1 in $i seconds... Press 1, 2, or Enter " -ForegroundColor Yellow

    if ([Console]::KeyAvailable) {
        $key = [Console]::ReadKey($true)

        switch ($key.Key) {
            'D1' { $Choice = '1'; break }
            'NumPad1' { $Choice = '1'; break }
            'D2' { $Choice = '2'; break }
            'NumPad2' { $Choice = '2'; break }
            'Enter' { $Choice = '1'; break }
        }
    }

    if ($Choice) { break }
    Start-Sleep -Seconds 1
}

Write-Host ""

if (-not $Choice) {
    $Choice = '1'
    Write-Host "No selection made. Defaulting to option 1." -ForegroundColor Yellow
}

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