$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# =========================
# FORM
# =========================
$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(640,400)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::FromArgb(12,18,17)
$form.TopMost = $true

# Double buffer (flicker yok)
$flags = [System.Reflection.BindingFlags]"Instance,NonPublic"
$form.GetType().GetProperty("DoubleBuffered",$flags).SetValue($form,$true,$null)

# =========================
# TITLE
# =========================
$title = New-Object System.Windows.Forms.Label
$title.Text = "COULDYSOLO"
$title.Font = New-Object System.Drawing.Font("Segoe UI Semibold",26)
$title.ForeColor = [System.Drawing.Color]::FromArgb(0,240,190)
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(200,30)
$form.Controls.Add($title)

# =========================
# SUBTITLE
# =========================
$subtitle = New-Object System.Windows.Forms.Label
$subtitle.Text = "Security Loader"
$subtitle.Font = New-Object System.Drawing.Font("Segoe UI",10)
$subtitle.ForeColor = [System.Drawing.Color]::FromArgb(120,190,170)
$subtitle.AutoSize = $true
$subtitle.Location = New-Object System.Drawing.Point(265,70)
$form.Controls.Add($subtitle)

# =========================
# STATUS
# =========================
$status = New-Object System.Windows.Forms.Label
$status.Text = "Initializing system..."
$status.Font = New-Object System.Drawing.Font("Segoe UI",11)
$status.ForeColor = [System.Drawing.Color]::FromArgb(160,160,160)
$status.AutoSize = $true
$status.Location = New-Object System.Drawing.Point(235,260)
$form.Controls.Add($status)

# =========================
# BUTTON
# =========================
$button = New-Object System.Windows.Forms.Button
$button.Text = "Servis Analizi Başlat"
$button.Size = New-Object System.Drawing.Size(280,48)
$button.Location = New-Object System.Drawing.Point(180,300)
$button.Font = New-Object System.Drawing.Font("Segoe UI Semibold",11)
$button.BackColor = [System.Drawing.Color]::FromArgb(15,40,35)
$button.ForeColor = [System.Drawing.Color]::FromArgb(0,240,190)
$button.FlatStyle = "Flat"
$button.FlatAppearance.BorderSize = 1
$button.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(0,240,190)
$button.Visible = $false
$form.Controls.Add($button)

# =========================
# LOADER
# =========================
$angle = 0
$form.Add_Paint({
    param($s,$e)
    $g = $e.Graphics
    $g.SmoothingMode = "HighQuality"

    $pen = New-Object System.Drawing.Pen(
        [System.Drawing.Color]::FromArgb(0,240,190),4
    )

    $rect = New-Object System.Drawing.Rectangle(270,120,100,100)
    $g.DrawArc($pen,$rect,$script:angle,260)
})

# =========================
# TIMER
# =========================
$step = 0
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 30

$timer.Add_Tick({
    $script:angle = ($script:angle + 6) % 360
    $script:step++

    if ($step -eq 80)  { $status.Text = "Loading core services..." }
    if ($step -eq 160) { $status.Text = "Checking environment..." }
    if ($step -eq 220) {
        $status.Text = "Ready"
        $button.Visible = $true
        $timer.Stop()
    }

    $form.Invalidate()
})

# =========================
# BUTTON CLICK
# =========================
$button.Add_Click({
    $status.Text = "Starting analysis..."

    Start-Process cmd -ArgumentList @(
        "/k",
        "powershell Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass && powershell Invoke-Expression (Invoke-RestMethod https://raw.githubusercontent.com/trSScommunity/ServisAnalizi.ps1/main/tr/ServisAnalizi.ps1)"
    )

    Start-Sleep -Milliseconds 400
    $form.Close()
})

# =========================
# START
# =========================
$timer.Start()
$form.ShowDialog() | Out-Null
$timer.Dispose()
