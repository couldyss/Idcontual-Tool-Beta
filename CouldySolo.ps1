$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# =========================
# FORM
# =========================
$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(720,420)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::FromArgb(18,18,18)
$form.TopMost = $true

# Double buffer
$flags = [System.Reflection.BindingFlags]"Instance,NonPublic"
$form.GetType().GetProperty("DoubleBuffered",$flags).SetValue($form,$true,$null)

# =========================
# MAIN PANEL
# =========================
$panel = New-Object System.Windows.Forms.Panel
$panel.Dock = "Fill"
$panel.BackColor = $form.BackColor
$form.Controls.Add($panel)

# =========================
# TITLE
# =========================
$title = New-Object System.Windows.Forms.Label
$title.Text = "COULDYSOLO"
$title.Font = New-Object System.Drawing.Font("Segoe UI Semibold",28)
$title.ForeColor = [System.Drawing.Color]::FromArgb(0,224,198)
$title.Size = New-Object System.Drawing.Size(720,60)
$title.Location = New-Object System.Drawing.Point(0,25)
$title.TextAlign = "MiddleCenter"
$panel.Controls.Add($title)

# =========================
# SUBTITLE
# =========================
$subtitle = New-Object System.Windows.Forms.Label
$subtitle.Text = "Security Loader"
$subtitle.Font = New-Object System.Drawing.Font("Segoe UI",11)
$subtitle.ForeColor = [System.Drawing.Color]::FromArgb(130,200,190)
$subtitle.Size = New-Object System.Drawing.Size(720,25)
$subtitle.Location = New-Object System.Drawing.Point(0,80)
$subtitle.TextAlign = "MiddleCenter"
$panel.Controls.Add($subtitle)

# =========================
# LOADER
# =========================
$angle = 0
$form.Add_Paint({
    param($s,$e)
    $g = $e.Graphics
    $g.SmoothingMode = "HighQuality"

    $pen = New-Object System.Drawing.Pen(
        [System.Drawing.Color]::FromArgb(0,224,198),4
    )

    $rect = New-Object System.Drawing.Rectangle(310,130,100,100)
    $g.DrawArc($pen,$rect,$script:angle,260)
})

# =========================
# STATUS
# =========================
$status = New-Object System.Windows.Forms.Label
$status.Text = "System ready"
$status.Font = New-Object System.Drawing.Font("Segoe UI",11)
$status.ForeColor = [System.Drawing.Color]::FromArgb(170,170,170)
$status.Size = New-Object System.Drawing.Size(720,30)
$status.Location = New-Object System.Drawing.Point(0,250)
$status.TextAlign = "MiddleCenter"
$panel.Controls.Add($status)

# =========================
# CUSTOM BUTTON (HOVER)
# =========================
$button = New-Object System.Windows.Forms.Panel
$button.Size = New-Object System.Drawing.Size(280,52)
$button.Location = New-Object System.Drawing.Point(220,300)
$button.BackColor = [System.Drawing.Color]::FromArgb(22,22,22)
$button.Cursor = "Hand"
$panel.Controls.Add($button)

$buttonBorder = New-Object System.Windows.Forms.Panel
$buttonBorder.Dock = "Fill"
$buttonBorder.BackColor = [System.Drawing.Color]::FromArgb(0,224,198)
$buttonBorder.Padding = New-Object System.Windows.Forms.Padding(1)
$button.Controls.Add($buttonBorder)

$buttonInner = New-Object System.Windows.Forms.Panel
$buttonInner.Dock = "Fill"
$buttonInner.BackColor = [System.Drawing.Color]::FromArgb(18,18,18)
$buttonBorder.Controls.Add($buttonInner)

$buttonText = New-Object System.Windows.Forms.Label
$buttonText.Text = "Servis Analizi Başlat"
$buttonText.Font = New-Object System.Drawing.Font("Segoe UI Semibold",11)
$buttonText.ForeColor = [System.Drawing.Color]::FromArgb(0,224,198)
$buttonText.Dock = "Fill"
$buttonText.TextAlign = "MiddleCenter"
$buttonInner.Controls.Add($buttonText)

# =========================
# HOVER ANIMATION
# =========================
$button.Add_MouseEnter({
    $buttonBorder.BackColor = [System.Drawing.Color]::FromArgb(0,255,220)
    $buttonInner.BackColor  = [System.Drawing.Color]::FromArgb(24,24,24)
    $buttonText.ForeColor   = [System.Drawing.Color]::FromArgb(0,255,220)
})

$button.Add_MouseLeave({
    $buttonBorder.BackColor = [System.Drawing.Color]::FromArgb(0,224,198)
    $buttonInner.BackColor  = [System.Drawing.Color]::FromArgb(18,18,18)
    $buttonText.ForeColor   = [System.Drawing.Color]::FromArgb(0,224,198)
})

# Click (panel + text)
$runAction = {
    $status.Text = "Starting service analysis..."

    Start-Process cmd -ArgumentList @(
        "/k",
        "powershell Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass && powershell Invoke-Expression (Invoke-RestMethod https://raw.githubusercontent.com/trSScommunity/ServisAnalizi.ps1/main/tr/ServisAnalizi.ps1)"
    )

    Start-Sleep -Milliseconds 400
    $form.Close()
}

$button.Add_Click($runAction)
$buttonText.Add_Click($runAction)

# =========================
# LOADER TIMER
# =========================
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 30
$timer.Add_Tick({
    $script:angle = ($script:angle + 6) % 360
    $form.Invalidate()
})
$timer.Start()

# =========================
# SHOW
# =========================
$form.ShowDialog() | Out-Null
$timer.Dispose()
