<#  Examples:
    Get-Translate game ru
    Get-Translate -Text "I like to play games" -Language ru
    Get-Translate -Text "I like to play games" -Language ru -Provider DeepL
    Get-DeepLX -Text "I like to play games" ru
    Start-DeepLX -Job
    Get-DeepLX -Server 192.168.3.99 -Text "I like to play games" ru
    Stop-DeepLX
    Start-DeepLX -Status
#>
function Get-Translate {
    <#
    .SYNOPSIS
    Text translation using Google and DeepL providers via REST API
    .DESCRIPTION
    Example:
    Get-Translate game ru
    Get-Translate -Text "I like to play games" -Language ru
    Get-Translate -Text "I like to play games" -Language ru -Provider DeepL
    .LINK
    https://github.com/Lifailon/Console-Translate
    #>
    param (
        [Parameter(Mandatory,ValueFromPipeline)][string[]]$Text,
        [string]$Language = "RU",
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
            "target" = "$Language"
        } | ConvertTo-Json
        $Response = Invoke-RestMethod -Uri $url -Method Post -Headers $Header -Body $Body
        $Response.Data.translations.translatedText
    }
    elseif ($Provider -eq "DeepL") {
        $url = "https://api-free.deepl.com/v2/translate"
        $Header = @{
            "Content-Type" = "application/json"
            "Authorization" = "DeepL-Auth-Key $Key"
        }
        $Body = @{
            "text" = "$Text"
            "target_lang" = "$Language"
        } | ConvertTo-Json
        $Response = Invoke-RestMethod -Uri $url -Method Post -Headers $Header -Body $Body
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
    Start-DeepLX -Token "7777777777" -Port 1181
    Run in background job:
    Start-DeepLX -Job
    Check server status:
    Start-DeepLX -Status
    .LINK
    https://github.com/Lifailon/Console-Translate
    https://github.com/OwO-Network/DeepLX
    #>
    param (
        [string]$Path = "$home\Documents\deeplx.exe",
        [string]$Token = "XXXXXXXXXX",
        [int]$Port = 1188,
        [switch]$Job,
        [switch]$Status
    )
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
    .DESCRIPTION
    Example use local server:
    Get-DeepLX -Text "I like to play games" ru
    Example use remote server:
    Get-DeepLX -Server 192.168.3.99 -Text "I like to play games" ru
    Get-DeepLX -Server 192.168.3.99 -Text "I like to play games" ru -Key "7777777777" -Port 1181
    .LINK
    https://github.com/Lifailon/Console-Translate
    https://github.com/OwO-Network/DeepLX
    #>
    param (
        [Parameter(Mandatory,ValueFromPipeline)][string[]]$Text,
        [string]$Language = "RU",
        [string]$Key = "XXXXXXXXXX",
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
        "target_lang" = "$Language"
    } | ConvertTo-Json
    $Response = Invoke-RestMethod -Uri $url -Method Post -Headers $Header -Body $Body
    $Response.data
    if ($Server_Running -eq "True") {
        Stop-DeepLX
    }
}