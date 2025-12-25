$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# =========================
# FORM
# =========================
$form = New-Object System.Windows.Forms.Form
$form.Text = "COULDYSOLO SS TOOL"
$form.Size = New-Object System.Drawing.Size(620,420)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(18,18,18)

# =========================
# TITLE
# =========================
$title = New-Object System.Windows.Forms.Label
$title.Text = "COULDYSOLO"
$title.Font = New-Object System.Drawing.Font("Segoe UI",24,[System.Drawing.FontStyle]::Bold)
$title.ForeColor = [System.Drawing.Color]::FromArgb(0,255,180)
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(190,20)
$form.Controls.Add($title)

# =========================
# SUBTEXT
# =========================
$sub = New-Object System.Windows.Forms.Label
$sub.Text = "Screenshare Analysis Tool"
$sub.Font = New-Object System.Drawing.Font("Segoe UI",10)
$sub.ForeColor = [System.Drawing.Color]::Gray
$sub.AutoSize = $true
$sub.Location = New-Object System.Drawing.Point(215,65)
$form.Controls.Add($sub)

# =========================
# BUTTON STYLE FUNC
# =========================
function New-Button($text,$y) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object System.Drawing.Size(420,45)
    $btn.Location = New-Object System.Drawing.Point(95,$y)
    $btn.FlatStyle = "Flat"
    $btn.FlatAppearance.BorderSize = 0
    $btn.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)
    $btn.ForeColor = [System.Drawing.Color]::FromArgb(220,220,220)
    $btn.Font = New-Object System.Drawing.Font("Segoe UI",11,[System.Drawing.FontStyle]::Bold)

    $btn.Add_MouseEnter({
        $this.BackColor = [System.Drawing.Color]::FromArgb(0,255,180)
        $this.ForeColor = [System.Drawing.Color]::Black
    })
    $btn.Add_MouseLeave({
        $this.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)
        $this.ForeColor = [System.Drawing.Color]::FromArgb(220,220,220)
    })

    return $btn
}

# =========================
# BUTTONS
# =========================
$btnService = New-Button "Servis Analizi" 120
$btnNetwork = New-Button "Ağ Bağlantı Analizi" 175
$btnAdvanced = New-Button "Gelişmiş Servis Analizi" 230
$btnPrefetch = New-Button "Prefetch Bypass Tespit - Attribute" 285

$form.Controls.AddRange(@(
    $btnService,
    $btnNetwork,
    $btnAdvanced,
    $btnPrefetch
))

# =========================
# BUTTON ACTIONS
# =========================
$btnService.Add_Click({
    Start-Process powershell -ArgumentList `
    'Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; Invoke-Expression (Invoke-RestMethod https://raw.githubusercontent.com/trSScommunity/ServisAnalizi.ps1/main/tr/ServisAnalizi.ps1)'
})

$btnNetwork.Add_Click({
    Start-Process powershell -ArgumentList `
    'Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; Invoke-Expression (Invoke-RestMethod https://raw.githubusercontent.com/trSScommunity/BaglantiAnalizi/refs/heads/main/BaglantiAnalizi.ps1)'
})

$btnAdvanced.Add_Click({
    Start-Process powershell -ArgumentList `
    'Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; Invoke-Expression (Invoke-RestMethod https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Services.ps1)'
})

$btnPrefetch.Add_Click({
    Start-Process powershell -ArgumentList `
    'Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; Invoke-Expression (Invoke-RestMethod https://raw.githubusercontent.com/bacanoicua/Screenshare/main/RedLotusPrefetchIntegrityAnalyzer.ps1)'
})

# =========================
# START
# =========================
$form.ShowDialog() | Out-Null
