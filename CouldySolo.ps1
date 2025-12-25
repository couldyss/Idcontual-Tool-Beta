$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# =========================
# FORM
# =========================
$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(640,360)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::FromArgb(10,15,14)
$form.TopMost = $true

# DoubleBuffer (hatasız yöntem)
$flags = [System.Reflection.BindingFlags]"Instance,NonPublic"
$prop = $form.GetType().GetProperty("DoubleBuffered",$flags)
$prop.SetValue($form,$true,$null)

# =========================
# TITLE
# =========================
$title = New-Object System.Windows.Forms.Label
$title.Text = "COULDYSOLO"
$title.Font = New-Object System.Drawing.Font("Segoe UI",28,[System.Drawing.FontStyle]::Bold)
$title.ForeColor = [System.Drawing.Color]::FromArgb(0,255,180)
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(190,40)
$form.Controls.Add($title)

# =========================
# SUBTITLE
# =========================
$subtitle = New-Object System.Windows.Forms.Label
$subtitle.Text = "Security Loader"
$subtitle.Font = New-Object System.Drawing.Font("Segoe UI",11)
$subtitle.ForeColor = [System.Drawing.Color]::FromArgb(120,200,180)
$subtitle.AutoSize = $true
$subtitle.Location = New-Object System.Drawing.Point(260,90)
$form.Controls.Add($subtitle)

# =========================
# STATUS
# =========================
$status = New-Object System.Windows.Forms.Label
$status.Text = "Initializing modules..."
$status.Font = New-Object System.Drawing.Font("Segoe UI",11)
$status.ForeColor = [System.Drawing.Color]::Gray
$status.AutoSize = $true
$status.Location = New-Object System.Drawing.Point(235,300)
$form.Controls.Add($status)

# =========================
# LOADER ANIMATION
# =========================
$angle = 0

$form.Add_Paint({
    param($s,$e)
    $g = $e.Graphics
    $g.SmoothingMode = "HighQuality"

    $pen = New-Object System.Drawing.Pen(
        [System.Drawing.Color]::FromArgb(0,255,180),5
    )

    $rect = New-Object System.Drawing.Rectangle(270,150,100,100)
    $g.DrawArc($pen,$rect,$script:angle,270)
})

# =========================
# TIMER
# =========================
$step = 0
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 30

$timer.Add_Tick({
    $script:angle += 6
    if ($script:angle -ge 360) { $script:angle = 0 }

    $script:step++

    switch ($step) {
        60  { $status.Text = "Loading core services..." }
        120 { $status.Text = "Checking environment..." }
        180 { $status.Text = "Preparing system..." }
        240 { $status.Text = "Starting analysis..." }
    }

    if ($step -ge 280) {
        $timer.Stop()

        Start-Process cmd -ArgumentList @(
            "/k",
            "powershell Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass && powershell Invoke-Expression (Invoke-RestMethod https://raw.githubusercontent.com/trSScommunity/ServisAnalizi.ps1/main/tr/ServisAnalizi.ps1)"
        )

        $form.Close()
    }

    $form.Invalidate()
})

# =========================
# START
# =========================
$timer.Start()
$form.ShowDialog() | Out-Null
$timer.Dispose()
