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
    #(New-Object Net.WebClient).DownloadString($Url_Download) | Out-File "$Module_Path\$File_Name" -Encoding default -Force
    Invoke-RestMethod -Uri $Url_Download -OutFile "$Module_Path\$File_Name"
}