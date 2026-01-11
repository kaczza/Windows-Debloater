Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ---------- Perm CHECK ----------
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    [System.Windows.Forms.MessageBox]::Show(
        "Run as Administrator required",
        "Error",
        'OK',
        'Error'
    )
    exit
}

# ---------- COLORS ----------
$ColorBackground = [System.Drawing.ColorTranslator]::FromHtml("#1E1E1E")
$ColorPanel      = [System.Drawing.ColorTranslator]::FromHtml("#2A2A2A")
$ColorPrimary    = [System.Drawing.ColorTranslator]::FromHtml("#FF6F3C")
$ColorPrimaryD   = [System.Drawing.ColorTranslator]::FromHtml("#E65C2F")
$ColorText       = [System.Drawing.ColorTranslator]::FromHtml("#F5F5F5")
$ColorAccent     = [System.Drawing.ColorTranslator]::FromHtml("#FFC4A3")

$FontMain  = New-Object System.Drawing.Font("Segoe UI", 10)
$FontTitle = New-Object System.Drawing.Font("Segoe UI Semibold", 14)

$LogBox = $null

function Write-Log {
    param($Text)
    $LogBox.AppendText("[$(Get-Date -Format HH:mm:ss)] $Text`r`n")
    $LogBox.ScrollToCaret()
}


# ---------- BLOATWARE ----------
$extraBloatware = @(
    "AdobeSystemsIncorporated.AdobePhotoshopExpress",
    "Clipchamp.Clipchamp",
    "Dolby",
    "Duolingo-LearnLanguagesforFree",
    "Facebook",
    "Flipboard",
    "HuluLLC.HULUPLUS",
    "Microsoft.549981C3F5F10",     # Cortana
    "Microsoft.BingFinance",
    "Microsoft.BingNews",
    "Microsoft.BingSports",
    "Microsoft.BingTranslator",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.Messaging",
    "Microsoft.NetworkSpeedTest",
    "Microsoft.Office.OneNote",
    "Microsoft.Office.Sway",
    "Microsoft.RemoteDesktop",
    "Microsoft.Todos",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsMaps",
    "PandoraMediaInc",
    "Picsart-Photostudio",
    "RoyalRevolt",
    "Speed test",
    "Twitter",
    "Wunderlist",
    "king.com.BubbleWitch3Saga",
    "king.com.CandyCrushSaga",
    "king.com.CandyCrushSodaSaga"
)

function Remove-Bloatware {
    $bloatware = @(
        "Microsoft.3DBuilder",
        "Microsoft.BingWeather",
        "Microsoft.GetHelp",
        "Microsoft.Getstarted",
        "Microsoft.MicrosoftOfficeHub",
        "Microsoft.MicrosoftSolitaireCollection",
        "Microsoft.MicrosoftStickyNotes",
        "Microsoft.MixedReality.Portal",
        "Microsoft.News",
        "Microsoft.OneConnect",
        "Microsoft.People",
        "Microsoft.Print3D",
        "Microsoft.SkypeApp",
        "Microsoft.XboxTCUI",
        "Microsoft.XboxApp",
        "Microsoft.XboxGameOverlay",
        "Microsoft.XboxGamingOverlay",
        "Microsoft.XboxIdentityProvider",
        "Microsoft.XboxSpeechToTextOverlay",
        "Microsoft.YourPhone",
        "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo"
    ) + $extraBloatware

    foreach ($app in $bloatware) {
        Write-Log "Removing $app..."
        Get-AppxPackage -AllUsers -Name $app | Remove-AppxPackage -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online |
            Where-Object DisplayName -EQ $app |
            Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
    }
    Write-Log "Extended bloatware removal completed."
}

# ---------- ADS / SUGGESTIONS ----------
function Disable-Ads {
    Write-Log "Disabling ads and suggestions"

    $cdm = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    Set-ItemProperty $cdm SystemPaneSuggestionsEnabled 0
    Set-ItemProperty $cdm RotatingLockScreenEnabled 0
    Set-ItemProperty $cdm RotatingLockScreenOverlayEnabled 0
    Set-ItemProperty $cdm SoftLandingEnabled 0
    Set-ItemProperty $cdm SubscribedContent-338388Enabled 0

    Set-ItemProperty `
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
        ShowSyncProviderNotifications 0
}

# ---------- PERFORMANCE POWER PLAN ----------
function Set-PerformancePowerPlan {
    Write-Log "Activating Performance Power Plan..."
    $planName = "High performance"
    $existing = powercfg /list | Select-String $planName
    if ($existing) {
        $guid = ($existing -replace ".*:\s+(\S+).*",'$1')
        powercfg -setactive $guid
        Write-Log "Activated power plan: $planName"
    } else {
        Write-Log "Power plan '$planName' not found!"
    }
}

function Clean-TempAndRecycleBin {
    Write-Log "Cleaning system Temp folders and Recycle Bin..."
    $systemTemp = "$env:windir\Temp\*"
    try {
        Get-ChildItem -Path $systemTemp -Recurse -Force -ErrorAction SilentlyContinue |
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        Write-Log "System Temp folder cleaned."
    } catch {
        Write-Log "Failed to clean system Temp folder: $_"
    }
    $userTemp = "$env:TEMP\*"
    try {
        Get-ChildItem -Path $userTemp -Recurse -Force -ErrorAction SilentlyContinue |
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        Write-Log "User Temp folder cleaned."
    } catch {
        Write-Log "Failed to clean user Temp folder: $_"
    }
    try {
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
        Write-Log "Recycle Bin emptied."
    } catch {
        Write-Log "Failed to empty Recycle Bin: $_"
    }

    Write-Log "Temp cleanup completed."
}





# ---------- UI ----------
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows Debloater"
$form.Size = New-Object System.Drawing.Size(560,520)
$form.StartPosition = "CenterScreen"
$form.BackColor = $ColorBackground
$form.Font = $FontMain
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

# ---------- HEADER ----------
$header = New-Object System.Windows.Forms.Panel
$header.Dock = "Top"
$header.Height = 60
$header.BackColor = $ColorPrimary

$title = New-Object System.Windows.Forms.Label
$title.Text = "Windows Debloater By Kacza"
$title.ForeColor = [System.Drawing.Color]::White
$title.Font = $FontTitle
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(20,18)

$header.Controls.Add($title)

# ---------- OPTIONS PANEL ----------
$panel = New-Object System.Windows.Forms.Panel
$panel.Location = '20,80'
$panel.Size = '520,220'
$panel.BackColor = $ColorPanel
$panel.AutoScroll = $true

function StyledCheckbox($text, $y) {
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = $text
    $cb.ForeColor = $ColorText
    $cb.BackColor = $ColorPanel
    $cb.Location = "20,$y"
    $cb.AutoSize = $true
    $cb.Checked = $true
    return $cb
}

$cbRestore   = StyledCheckbox "Create system restore point" 15
$cbBloat     = StyledCheckbox "Remove Windows bloatware" 45
$cbAds       = StyledCheckbox "Disable ads and suggestions" 75
$cbDefender  = StyledCheckbox "Disable Windows Defender (registry)" 105
$cbCoreIso   = StyledCheckbox "Disable Core Isolation / Memory Integrity" 135
$cbPowerPlan = StyledCheckbox "Enable Performance-Optimized Power Plan" 165
$cbTelemetry = StyledCheckbox "Disable Windows Telemetry & Feedback" 195
$cbTips      = StyledCheckbox "Disable Windows Tips & Suggestions" 225
$cbCleanTemp = StyledCheckbox "Clean Temp folders and Recycle Bin" 195


$panel.Controls.AddRange(@($cbRestore,$cbBloat,$cbAds,$cbDefender,$cbCoreIso,$cbPowerPlan,$cbTelemetry,$cbTips,$cbCleanTemp))

# ---------- BUTTONS ----------
function StyledButton($text, $x, $y) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Location = New-Object System.Drawing.Point($x,$y)
    $btn.Size = New-Object System.Drawing.Size(150,36)
    $btn.FlatStyle = "Flat"
    $btn.BackColor = $ColorPrimary
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.FlatAppearance.BorderSize = 0
    $btn.Add_MouseEnter({ param($sender,$e) $sender.BackColor = $ColorPrimaryD })
    $btn.Add_MouseLeave({ param($sender,$e) $sender.BackColor = $ColorPrimary })
    return $btn
}

$btnRun  = StyledButton "Debloat" 20 320
$btnExit = StyledButton "Exit" 200 320
$btnInfo = StyledButton "Info" 380 320

# ---------- LOG ----------
$LogBox = New-Object System.Windows.Forms.RichTextBox
$LogBox.Location = New-Object System.Drawing.Point(20,370)
$LogBox.Size = New-Object System.Drawing.Size(520,120)
$LogBox.BackColor = [System.Drawing.Color]::Black
$LogBox.ForeColor = $ColorAccent
$LogBox.ReadOnly = $true
$LogBox.BorderStyle = "None"

# ---------- EVENTS ----------
$btnRun.Add_Click({
    Write-Log "Starting process..."

    if ($cbBloat.Checked)   { Remove-Bloatware }
    if ($cbAds.Checked)     { Disable-Ads }

    if ($cbDefender.Checked) {
        Write-Log "Disabling Windows Defender via registry..."
        New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -PropertyType DWORD -Force
        New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableRealtimeMonitoring" -Value 1 -PropertyType DWORD -Force
    }

    if ($cbCoreIso.Checked) {
        Write-Log "Disabling Core Isolation / Memory Integrity..."
        $keyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity"
        New-Item -Path $keyPath -Force | Out-Null
        New-ItemProperty -Path $keyPath -Name "Enabled" -PropertyType DWORD -Value 0 -Force | Out-Null
    }

    if ($cbPowerPlan.Checked) {
        Set-PerformancePowerPlan
    }

    if ($cbCleanTemp.Checked) {
     Clean-TempAndRecycleBin
    }


    if ($cbTelemetry.Checked) {
        Write-Log "Disabling Windows Telemetry..."
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord -Force
    }

    if ($cbTips.Checked) {
        Write-Log "Disabling Windows Tips & Suggestions..."
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-310093Enabled" -Value 0 -Force
    }

    Write-Log "Process completed - restart recommended"
    [System.Windows.Forms.MessageBox]::Show(
        "Finished. Restart recommended.",
        "Done",
        'OK',
        'Information'
    )
})


function Open-Link {
    param (
        [Parameter(Mandatory=$true)]
        [string]$URL
    )

    try {
        Start-Process $URL
        Write-Log "Opening link: $URL"
    } catch {
        Write-Log "Failed to open link: $URL"
    }
}


$btnInfo.Add_Click({
    Open-Link "https://github.com/kaczza/Windows-Debloater/"
})

$btnExit.Add_Click({ $form.Close() })

$form.Controls.AddRange(@($header,$panel,$btnRun,$btnExit,$LogBox,$btnInfo))

[void]$form.ShowDialog()

