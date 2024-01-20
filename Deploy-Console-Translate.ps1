### Install/Update Module
if ($IsLinux) {
    $path = ($env:PSModulePath.Split(":")[0])+"/Console-Translate"
} else {
    $path = ($env:PSModulePath.Split(";")[0])+"\Console-Translate"
}
if (Test-Path $path) {
    Remove-Item "$path\" -Recurse
}
$GitHub_Tag = (Invoke-RestMethod "https://api.github.com/repos/Lifailon/Console-Translate/releases/latest").tag_name
$Module_Version = $GitHub_Tag -replace ".+-"
$Module_Path = "$path\$Module_Version"
New-Item -Path $Module_Path  -Force -ItemType Directory
$url = "https://api.github.com/repos/Lifailon/Console-Translate/contents/Console-Translate/$Module_Version"
$Files_GitHub = Invoke-RestMethod -Uri $url
foreach ($File_GitHub in $Files_GitHub) {
    $File_Name = $File_GitHub.name
    $Url_Download = $File_GitHub.download_url
    (New-Object Net.WebClient).DownloadString($Url_Download) | Out-File "$Module_Path\$File_Name" -Encoding default -Force

}
### Install/Update DeepLX
if ($IsLinux) {
    $DeepLX_Path = "$path/$Module_Version/deeplx"
    $DeepLX_Releases_Latest = Invoke-RestMethod "https://api.github.com/repos/OwO-Network/DeepLX/releases/latest"
    [string]$DeepLX_Download_url = $($DeepLX_Releases_Latest.assets | Where-Object Name -Match "linux_amd64").browser_download_url
} else {
    $DeepLX_Path = "$path\$Module_Version\deeplx.exe"
    $DeepLX_Releases_Latest = Invoke-RestMethod "https://api.github.com/repos/OwO-Network/DeepLX/releases/latest"
    [string]$DeepLX_Download_url = ($DeepLX_Releases_Latest.assets | Where-Object Name -Match "amd64.exe").browser_download_url
}
(New-Object Net.WebClient).DownloadString($DeepLX_Download_url) | Out-File $DeepLX_Path -Encoding default -Force
Invoke-RestMethod -Uri $url -OutFile $DeepLX_Path
if ($IsLinux) {
    chmod +x $DeepLX_Path
} else {
    "`nNew-Alias -Name gt -Value Get-Translate -Force" >> $PROFILE
    "`nNew-Alias -Name gd -Value Get-DeepLX -Force" >> $PROFILE
}