### Install/Update Module
$path = ($env:PSModulePath.Split(";")[0])+"\Console-Translate\"
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
$Path_DeepLX = "$home\Documents\deeplx.exe"
$Releases_Latest = Invoke-RestMethod "https://api.github.com/repos/OwO-Network/DeepLX/releases/latest"
[uri]$url = ($Releases_Latest.assets | Where-Object Name -Match "amd64.exe").browser_download_url
if (Test-Path $Path_DeepLX) {
    Remove-Item $Path_DeepLX
}
Invoke-RestMethod -Uri $url -OutFile $Path_DeepLX