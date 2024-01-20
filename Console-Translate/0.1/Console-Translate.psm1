function Get-Translate {
    <#
    .SYNOPSIS
    Text translation using Google and DeepL providers via REST API
    .DESCRIPTION
    Example:
    Get-Translate -Text "Module for text translation" ru
    Get-Translate -Text "Модуль для перевода текста" en
    Get-Translate -Text "Модуль для перевода текста" -LanguageTarget en -LanguageSource ru
    $Token = "YOUR_TOKEN"
    Get-Translate -Text "Module for text translation" -LanguageTarget ru -Provider DeepL -Key $Token
    .LINK
    https://github.com/Lifailon/Console-Translate
    #>
    param (
        [Parameter(Mandatory,ValueFromPipeline)][string[]]$Text,
        [string]$LanguageTarget = "RU",
        [string]$LanguageSource,
        [ValidateSet("Google","DeepL")][string]$Provider = "Google",
        [string]$Key = "AIzaSyBOti4mM-6x9WDnZIjIeyEU21OpBXqWBgw" # Public API Key for Google Translate
    )
    if ($Provider -eq "Google") {
        $url = "https://translation.googleapis.com/language/translate/v2?key=${key}"
        $Header = @{
            "Content-Type" = "application/json"
        }
        $Body = @{
            "q" = "$Text"
            "target" = "$LanguageTarget"
            "source" = "$LanguageSource"
        } | ConvertTo-Json
        $WebClient = New-Object System.Net.WebClient
        #$WebClient.Headers.Add("Content-Type", "application/json")
        foreach ($key in $Header.Keys) {
            $WebClient.Headers.Add($key, $Header[$key])
        }
        #$Response = Invoke-RestMethod -Uri $url -Method Post -Headers $Header -Body $Body
        $Response = $WebClient.UploadString($url, "POST", $Body) | ConvertFrom-Json
        $Response.data.translations.translatedText
    }
    elseif ($Provider -eq "DeepL") {
        $url = "https://api-free.deepl.com/v2/translate"
        $Header = @{
            "Content-Type" = "application/json"
            "Authorization" = "DeepL-Auth-Key $Key"
        }
        $Body = @{
            "text" = "$Text"
            "target_lang" = "$LanguageTarget"
            "source_lang" = "$LanguageSource"
        } | ConvertTo-Json
        $WebClient = New-Object System.Net.WebClient
        foreach ($key in $Header.Keys) {
            $WebClient.Headers.Add($key, $Header[$key])
        }
        $Response = $WebClient.UploadString($url, "POST", $Body) | ConvertFrom-Json
        $Response.translations.text
    }
}
function Start-DeepLX {
    <#
    .SYNOPSIS
    Starting local server
    .DESCRIPTION
    Example:
    Start-DeepLX
    Start-DeepLX -Token "1111111111" -Port 1181
    Run in background job:
    Start-DeepLX -Job
    Check server status:
    Start-DeepLX -Status
    .LINK
    https://github.com/Lifailon/Console-Translate
    https://github.com/OwO-Network/DeepLX
    #>
    param (
        [string]$Token = "7777777777",
        [int]$Port = 1188,
        [switch]$Job,
        [switch]$Status
    )
    if ($IsLinux) {
        [string]$path = ($env:PSModulePath.Split(":")[0])+"/Console-Translate/deeplx"
    } else {
        [string]$Path = ($env:PSModulePath.Split(";")[0])+"\Console-Translate\deeplx.exe"
    }
    if ($Status) {
        $Job_State = Get-Job | Where-Object Name -Like "DeepLX"
        if ($Job_State) {
            $Job_State.State
        } else {
            Write-Host "Not running"
        }
    } else {
        if ($Job) {
            $Test = Get-Job -Name DeepLX -ErrorAction Ignore
            if ($Test) {
                Write-Host "Server is running" -ForegroundColor Green
            } else {
                Start-Job -Name DeepLX {
                    Invoke-Expression "$using:path --token $using:Token --port $using:Port"
                } > $null
            }
            } else {
            Invoke-Expression "$path --token $Token --port $Port"
        }
    }
}
function Stop-DeepLX {
    $Job = Get-Job -Name DeepLX -ErrorAction Ignore
    if ($Job) {
        $job | Remove-Job -Force
    }
}
function Get-DeepLX {
    <#
    .SYNOPSIS
    Text translation using DeepLX server Free API (no token required)
    For a local request, the server is started for the duration of the get response
    .DESCRIPTION
    Example use local server:
    Get-DeepLX "Get select" de
    Get-DeepLX "Get select" ru
    Get-DeepLX "Получить выбор" en
    Get-DeepLX "Получить выбор" en -Alternatives
    Example use remote server:
    Get-DeepLX -Server 192.168.3.99 -Text "Module for text translation" ru
    Get-DeepLX -Server 192.168.3.99 -Text "Module for text translation" -LanguageTarget ru -Key "1111111111" -Port 1181
    .LINK
    https://github.com/Lifailon/Console-Translate
    https://github.com/OwO-Network/DeepLX
    #>
    param (
        [Parameter(Mandatory,ValueFromPipeline)][string[]]$Text,
        [string]$LanguageTarget = "RU",
        [string]$LanguageSource,
        [switch]$Alternatives,
        [string]$Key = "7777777777",
        [string]$Server,
        [int]$Port = 1188
    )
    if ($Server) {
        $Server_Running = "False"
    }
    else {
        $Server_Running = "True"
        $Server = "localhost"
        Stop-DeepLX
        Start-DeepLX -Token $Key -Port $Port -Job
    }
    $srv = $Server+":"+$Port
    $url = "http://$srv/translate"
    $Header = @{
        "Content-Type" = "application/json"
        "Authorization" = "Bearer $Key"
    }
    $Body = @{
        "text" = "$Text"
        "target_lang" = "$LanguageTarget"
        "source_lang" = "$LanguageSource"
    } | ConvertTo-Json
    $WebClient = New-Object System.Net.WebClient
    foreach ($key in $Header.Keys) {
        $WebClient.Headers.Add($key, $Header[$key])
    }
    $Response = $WebClient.UploadString($url, "POST", $Body) | ConvertFrom-Json
    if ($Alternatives) {
        $Response.alternatives
    } else {
        $Response.data
    }
    if ($Server_Running -eq "True") {
        Stop-DeepLX
    }
}