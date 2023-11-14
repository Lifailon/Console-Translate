### Install/Update Module
if ($IsLinux) {
    $path = ($env:PSModulePath.Split(":")[0])+"/Console-Translate"
} else {
    $path = ($env:PSModulePath.Split(";")[0])+"\Console-Translate"
}
$psd = "$path\Console-Translate.psd1"
$psm = "$path\Console-Translate.psm1"
if (Test-Path $path) {
Remove-Item "$path\" -Recurse
}
New-Item $psm -ItemType "File" -Force | Out-Null
New-Item $psd -ItemType "File" -Force | Out-Null
$psd_url = "https://raw.githubusercontent.com/Lifailon/Console-Translate/rsa/Console-Translate/Console-Translate.psd1"
$psm_url = "https://raw.githubusercontent.com/Lifailon/Console-Translate/rsa/Console-Translate/Console-Translate.psm1"
(New-Object Net.WebClient).DownloadString($psd_url) | Out-File $psd -Encoding default -Force
(New-Object Net.WebClient).DownloadString($psm_url) | Out-File $psm -Encoding default -Force
### Install/Update DeepLX
if ($IsLinux) {
    $Path_DeepLX = "$path/deeplx"
    $Releases_Latest = Invoke-RestMethod "https://api.github.com/repos/OwO-Network/DeepLX/releases/latest"
    [string]$url = $($Releases_Latest.assets | Where-Object Name -Match "linux_amd64").browser_download_url
} else {
    $Path_DeepLX = "$path\deeplx.exe"
    $Releases_Latest = Invoke-RestMethod "https://api.github.com/repos/OwO-Network/DeepLX/releases/latest"
    [string]$url = ($Releases_Latest.assets | Where-Object Name -Match "amd64.exe").browser_download_url
}
    if (Test-Path $Path_DeepLX) {
    Remove-Item $Path_DeepLX
}
Invoke-RestMethod -Uri $url -OutFile $Path_DeepLX
if ($IsLinux) {
    chmod +x $Path_DeepLX
} else {
"`nNew-Alias -Name gt -Value Get-Translate -Force" >> $PROFILE
"`nNew-Alias -Name gd -Value Get-DeepLX -Force" >> $PROFILE
}