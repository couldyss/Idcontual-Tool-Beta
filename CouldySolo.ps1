Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase

# ================== XAML ==================
$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    Title="COULDYSOLO Security Tool"
    Width="600" Height="420"
    WindowStartupLocation="CenterScreen"
    Background="#0B0F0E"
    ResizeMode="NoResize">

    <Grid>
        <StackPanel VerticalAlignment="Center" HorizontalAlignment="Center">

            <TextBlock Text="COULDYSOLO"
                       Foreground="#00FFC6"
                       FontSize="36"
                       FontWeight="Bold"
                       HorizontalAlignment="Center"/>

            <TextBlock Text="Security Loader"
                       Foreground="#8FFFEA"
                       FontSize="14"
                       Margin="0,0,0,30"
                       HorizontalAlignment="Center"/>

            <!-- BUTTON STYLE -->
            <StackPanel.Resources>
                <Style TargetType="Button">
                    <Setter Property="Width" Value="360"/>
                    <Setter Property="Height" Value="50"/>
                    <Setter Property="Margin" Value="0,10"/>
                    <Setter Property="FontSize" Value="14"/>
                    <Setter Property="Foreground" Value="Black"/>
                    <Setter Property="Background" Value="#00FFC6"/>
                    <Setter Property="BorderThickness" Value="0"/>
                    <Setter Property="Cursor" Value="Hand"/>
                    <Setter Property="Template">
                        <Setter.Value>
                            <ControlTemplate TargetType="Button">
                                <Border Background="{TemplateBinding Background}"
                                        CornerRadius="8">
                                    <ContentPresenter
                                        HorizontalAlignment="Center"
                                        VerticalAlignment="Center"/>
                                </Border>
                                <ControlTemplate.Triggers>
                                    <Trigger Property="IsMouseOver" Value="True">
                                        <Setter Property="Background" Value="#00D6A4"/>
                                    </Trigger>
                                    <Trigger Property="IsPressed" Value="True">
                                        <Setter Property="Background" Value="#00B38A"/>
                                    </Trigger>
                                </ControlTemplate.Triggers>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
            </StackPanel.Resources>

            <Button x:Name="NetBtn" Content="Ağ Bağlantı Analizi"/>
            <Button x:Name="SrvBtn" Content="Gelişmiş Servis Analizi"/>
            <Button x:Name="PreBtn" Content="Prefetch Bypass Tespit / Attribute"/>

        </StackPanel>
    </Grid>
</Window>
"@

# ================== LOAD WINDOW ==================
$reader = New-Object System.Xml.XmlNodeReader ([xml]$xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# ================== FIND BUTTONS ==================
$NetBtn = $window.FindName("NetBtn")
$SrvBtn = $window.FindName("SrvBtn")
$PreBtn = $window.FindName("PreBtn")

# ================== BUTTON ACTIONS ==================

$NetBtn.Add_Click({
    Start-Process powershell -ArgumentList `
    '-NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression (Invoke-RestMethod https://raw.githubusercontent.com/trSScommunity/BaglantiAnalizi/refs/heads/main/BaglantiAnalizi.ps1)"'
})

$SrvBtn.Add_Click({
    Start-Process powershell -ArgumentList `
    '-NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression (Invoke-RestMethod https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Services.ps1)"'
})

$PreBtn.Add_Click({
    Start-Process powershell -ArgumentList `
    '-NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression (Invoke-RestMethod https://raw.githubusercontent.com/bacanoicua/Screenshare/main/RedLotusPrefetchIntegrityAnalyzer.ps1)"'
})

# ================== SHOW ==================
$window.ShowDialog() | Out-Null
