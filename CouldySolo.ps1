# === COULDYSOLO WINFORMS FINAL v3 ===
# NO WPF / NO XAML

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(720,420)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::FromArgb(12,16,15)
$form.TopMost = $true
$form.DoubleBuffered = $true

$title = New-Object System.Windows.Forms.Label
$title.Text = "COULDYSOLO"
$title.Font = New-Object System.Drawing.Font("Segoe UI Semibold",28)
$title.ForeColor = [System.Drawing.Color]::FromArgb(0,255,180)
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(240,40)
$form.Controls.Add($title)

$status = New-Object System.Windows.Forms.Label
$status.Text = "Initializing environment..."
$status.Font = New-Object System.Drawing.Font("Segoe UI",11)
$status.ForeColor = [System.Drawing.Color]::FromArgb(150,200,190)
$status.AutoSize = $true
$status.Location = New-Object System.Drawing.Point(255,90)
$form.Controls.Add($status)

$angle = 0

$form.Add_Paint({
    param($s,$e)
    $g = $e.Graphics
    $g.SmoothingMode = "AntiAlias"
    $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(0,255,180),5)
    $rect = New-Object System.Drawing.Rectangle(310,150,100,100)
    $g.DrawArc($pen, $rect, $script:angle, 260)
})

$step = 0
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 25

$timer.Add_Tick({
    $script:angle = ($script:angle + 7) % 360
    $script:step++

    if ($step -eq 80)  { $status.Text = "Loading core modules..." }
    if ($step -eq 160) { $status.Text = "Checking system services..." }
    if ($step -eq 240) { $status.Text = "Preparing service analysis..." }
    if ($step -eq 300) { $status.Text = "Starting scan..." }

    if ($step -ge 330) {
        $timer.Stop()
        Start-Process cmd.exe -ArgumentList `
        '/k powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression (Invoke-RestMethod https://raw.githubusercontent.com/trSScommunity/ServisAnalizi.ps1/main/tr/ServisAnalizi.ps1)"'
        $form.Close()
    }

    $form.Invalidate()
})

$timer.Start()
$form.ShowDialog() | Out-Null
$timer.Dispose()
