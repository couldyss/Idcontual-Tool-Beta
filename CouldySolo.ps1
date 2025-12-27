$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# =========================
# FORM
# =========================
$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(760,460)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::FromArgb(18,18,18)
$form.TopMost = $true

# DoubleBuffer (reflection)
$flags = [System.Reflection.BindingFlags]"Instance,NonPublic"
$form.GetType().GetProperty("DoubleBuffered",$flags).SetValue($form,$true,$null)

# =========================
# PANEL
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
$title.Size = New-Object System.Drawing.Size(760,60)
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
$subtitle.Size = New-Object System.Drawing.Size(760,25)
$subtitle.Location = New-Object System.Drawing.Point(0,80)
$subtitle.TextAlign = "MiddleCenter"
$panel.Controls.Add($subtitle)

# =========================
# LOADER (SPIN)
# =========================
$angle = 0
$form.Add_Paint({
    param($s,$e)
    $g = $e.Graphics
    $g.SmoothingMode = "HighQuality"
    $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(0,224,198),4)
    $rect = New-Object System.Drawing.Rectangle(330,120,100,100)
    $g.DrawArc($pen,$rect,$script:angle,260)
})

# =========================
# STATUS
# =========================
$status = New-Object System.Windows.Forms.Label
$status.Text = "Select an analysis module"
$status.Font = New-Object System.Drawing.Font("Segoe UI",11)
$status.ForeColor = [System.Drawing.Color]::FromArgb(170,170,170)
$status.Size = New-Object System.Drawing.Size(760,30)
$status.Location = New-Object System.Drawing.Point(0,240)
$status.TextAlign = "MiddleCenter"
$panel.Controls.Add($status)

# =========================
# BUTTON CREATOR
# =========================
function New-ActionButton($text,$x,$y,$action) {
    $btn = New-Object System.Windows.Forms.Panel
    $btn.Size = New-Object System.Drawing.Size(300,48)
    $btn.Location = New-Object System.Drawing.Point($x,$y)
    $btn.BackColor = [System.Drawing.Color]::FromArgb(22,22,22)
    $btn.Cursor = "Hand"

    $border = New-Object System.Windows.Forms.Panel
    $border.Dock = "Fill"
    $border.BackColor = [System.Drawing.Color]::FromArgb(0,224,198)
    $border.Padding = New-Object System.Windows.Forms.Padding(1)
    $btn.Controls.Add($border)

    $inner = New-Object System.Windows.Forms.Panel
    $inner.Dock = "Fill"
    $inner.BackColor = [System.Drawing.Color]::FromArgb(18,18,18)
    $border.Controls.Add($inner)

    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $text
    $lbl.Font = New-Object System.Drawing.Font("Segoe UI Semibold",11)
    $lbl.ForeColor = [System.Drawing.Color]::FromArgb(0,224,198)
    $lbl.Dock = "Fill"
    $lbl.TextAlign = "MiddleCenter"
    $inner.Controls.Add($lbl)

    $btn.Add_MouseEnter({
        $border.BackColor = [System.Drawing.Color]::FromArgb(0,255,220)
        $lbl.ForeColor    = [System.Drawing.Color]::FromArgb(0,255,220)
    })
    $btn.Add_MouseLeave({
        $border.BackColor = [System.Drawing.Color]::FromArgb(0,224,198)
        $lbl.ForeColor    = [System.Drawing.Color]::FromArgb(0,224,198)
    })

    $btn.Add_Click($action)
    $lbl.Add_Click($action)

    $panel.Controls.Add($btn)
}

# =========================
# ACTIONS (KESİN ÇALIŞAN)
# =========================
$runService = {
    $status.Text = "Starting Service Analysis..."
    Start-Process cmd -ArgumentList @(
        "/k",
        "powershell -NoProfile -ExecutionPolicy Bypass -Command `"IEX (IRM 'https://raw.githubusercontent.com/trSScommunity/ServisAnalizi.ps1/main/tr/ServisAnalizi.ps1')`""
    )
}

$runNetwork = {
    $status.Text = "Starting Network Analysis..."
    Start-Process cmd -ArgumentList @(
        "/k",
        "powershell -NoProfile -ExecutionPolicy Bypass -Command `"IEX (IRM 'https://raw.githubusercontent.com/trSScommunity/BaglantiAnalizi/refs/heads/main/BaglantiAnalizi.ps1')`""
    )
}

$runAdvancedService = {
    $status.Text = "Starting Advanced Service Analysis..."
    Start-Process cmd -ArgumentList @(
        "/k",
        "powershell -NoProfile -ExecutionPolicy Bypass -Command `"IEX (IRM 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Services.ps1')`""
    )
}

$runPrefetch = {
    $status.Text = "Starting Prefetch Integrity Scan..."
    Start-Process cmd -ArgumentList @(
        "/k",
        "powershell -NoProfile -ExecutionPolicy Bypass -Command `"IEX (IRM 'https://raw.githubusercontent.com/bacanoicua/Screenshare/main/RedLotusPrefetchIntegrityAnalyzer.ps1')`""
    )
}

# =========================
# BUTTONS
# =========================
New-ActionButton "Servis Analizi"            80  290 $runService
New-ActionButton "Ağ Bağlantı Analizi"       380 290 $runNetwork
New-ActionButton "Gelişmiş Servis Analizi"   80  350 $runAdvancedService
New-ActionButton "Prefetch Bypass Tespit"    380 350 $runPrefetch

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
>Glab:start [} dispand:0
renew /release Outro\*keyboard clus:_
