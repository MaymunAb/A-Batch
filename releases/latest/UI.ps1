param (
    [string]$LaunchUICode 
)

# Update Check Parameters
$RepoOwner = "MaymunAb"
$RepoName = "A-Batch"
$CurrentVersionFile = "$PSScriptRoot\version.txt"

# Function to get the latest release version from GitHub
function Get-LatestVersionFromGitHub {
    $url = "https://api.github.com/repos/$RepoOwner/$RepoName/releases/latest"
    $response = Invoke-RestMethod -Uri $url -Method Get -Headers @{ "User-Agent" = "PowerShell" }
    return $response.tag_name
}

# Function to compare versions
function Compare-Versions {
    param (
        [string]$currentVersion,
        [string]$latestVersion
    )
    return [version]$currentVersion -lt [version]$latestVersion
}

# Function to show a notification
function Show-UpdateNotification {
    param (
        [string]$message
    )
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show($message, "Update Available", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}

# Check for updates
$localVersion = if (Test-Path $CurrentVersionFile) {
    Get-Content $CurrentVersionFile
} else {
    "0.0.0"  # Default version if file doesn't exist
}

$latestVersion = Get-LatestVersionFromGitHub
if (Compare-Versions -currentVersion $localVersion -latestVersion $latestVersion) {
    Show-UpdateNotification -message "A new version ($latestVersion) is available. Please update your application."
}

Write-Host "[ARDAT-UI][INFO][Download Module]: Downloading Write-Ascii"
Install-Module WriteAscii
Import-Module WriteAscii
cls
Write-Ascii "ArdaT" -ForegroundColor DarkMagenta
Write-Host "==========================================================" -ForegroundColor DarkMagenta
Write-Host "==========================================================" -ForegroundColor DarkMagenta
Write-Host "[ARDAT-UI][INFO][CheckVersion]: Version, 0.0.99.33" -ForegroundColor DarkGreen

Write-Host "[ARDAT-UI][INFO]: Grabbed Parameters" -ForegroundColor DarkGreen
# Check if the correct parameter is provided
if ($LaunchUICode -ne "9Gj9Gjxxx4RFRGI38") {
    Write-Host "[ARDAT-UI][ERROR]: This script cannot be run directly." -ForegroundColor Red
    Write-Host "[ARDAT-UI][ERROR]: Use The Launcher Instead" -ForegroundColor Red
    exit
}

# Define paths
$appDataPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('ApplicationData'), 'ArdaTUI')
$firstBootFilePath = [System.IO.Path]::Combine($appDataPath, 'firstboot.txt')

# Check if the firstboot file exists
if (-not (Test-Path -Path $firstBootFilePath)) {
    # Create directory if it does not exist
    if (-not (Test-Path -Path $appDataPath)) {
        Write-Host "[ARDAT-UI][INFO]: Creating configuration directory..."
        New-Item -Path $appDataPath -ItemType Directory | Out-Null
    }
	
    # Create the firstboot file
    Write-Host "[ARDAT-UI][INFO]: Creating firstboot file..."
    New-Item -Path $firstBootFilePath -ItemType File | Out-Null
    & {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'ArdaT UI', 'Welcome To UI, To Optimize The System, Press (Start)', [System.Windows.Forms.ToolTipIcon]::None)}
} else {
    Write-Host "[ARDAT-UI][INFO]: Firstboot file exists."
}

Write-Host "[ARDAT-UI][INFO]: Launching UI"
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "ArdaT UI"
$form.Size = New-Object System.Drawing.Size(350, 250)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
$form.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)

# Create the label
$label = New-Object System.Windows.Forms.Label
$label.Text = "ArdaT UI"
$label.Font = New-Object System.Drawing.Font("Arial", 20, [System.Drawing.FontStyle]::Bold)
$label.ForeColor = [System.Drawing.Color]::White
$label.AutoSize = $true
$label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$label.Location = New-Object System.Drawing.Point(([math]::Round(($form.ClientSize.Width - $label.PreferredWidth) / 2)), 20)
$form.Controls.Add($label)

# Create the Start button
$startButton = New-Object System.Windows.Forms.Button
$startButton.Text = "Start"
$startButton.Size = New-Object System.Drawing.Size(150, 50)
$startButton.Location = New-Object System.Drawing.Point(([math]::Round(($form.ClientSize.Width - $startButton.Width) / 2)), ([math]::Round(($form.ClientSize.Height - $startButton.Height) / 2)))
$startButton.ForeColor = [System.Drawing.Color]::White
$startButton.BackColor = [System.Drawing.Color]::FromArgb(28, 28, 30)
$startButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$startButton.FlatAppearance.BorderColor = [System.Drawing.Color]::White
$startButton.FlatAppearance.BorderSize = 1
$startButton.Add_Click({
    cmd /c "$PSScriptRoot\stl1.bat optimizeSystem" 2>&1 | ForEach-Object { Write-Host "[ArdaT][INFO]: $_" -ForegroundColor White }
})
$form.Controls.Add($startButton)

# Create the version label
$versionLabel = New-Object System.Windows.Forms.Label
$versionLabel.Text = "Version: 0.1.44.44"
$versionLabel.ForeColor = [System.Drawing.Color]::White
$versionLabel.AutoSize = $true
$versionLabel.Location = New-Object System.Drawing.Point($form.ClientSize.Width - $versionLabel.PreferredWidth - 10, $form.ClientSize.Height - $versionLabel.PreferredHeight - 10)
$form.Controls.Add($versionLabel)

# Update the version label's position on form resize
$form.Add_Resize({
    $formWidth = $form.ClientSize.Width
    $formHeight = $form.ClientSize.Height
    $versionLabel.Location = New-Object System.Drawing.Point($formWidth - $versionLabel.PreferredWidth - 10, $formHeight - $versionLabel.PreferredHeight - 10)
})

Write-Host "[ARDAT-UI][INFO]: Done Launching UI"

# Show the form
$form.ShowDialog()

Write-Host "[ARDAT-UI][INFO]: ==Finished=="
