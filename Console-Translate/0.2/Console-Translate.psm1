function Get-LanguageCode {
    Get-Content "$PSScriptRoot\lang-iso-639-1.csv" | ConvertFrom-Csv -Delimiter ";"
}

function Get-Translate {
    <#
    .SYNOPSIS
    Text translation using Google (public API key added to the default parameter), DeepL and MyMemory (API key not required) providers via REST API
    .DESCRIPTION
    Example:
    Get-Translate "Module for text translation"
    Get-Translate "Модуль для перевода текста"
    Get-Translate "Привет world" -LanguageSelected
    Get-Translate "Hello друг" -LanguageSelected
    Get-Translate -Text "Модуль для перевода текста" -LanguageSource ru -LanguageTarget tr # Russian -> Turkish
    Get-Translate -Provider MyMemory -Text "MyMemory is the world's largest Translation Memory. It has been created collecting TMs from the European Union and United Nations, and aligning the best domain-specific multilingual websites."
    Get-Translate -Provider MyMemory -Text "Hello World" -Alternatives
    Get-Translate -Provider DeepL -Key "<API_TOKEN>" -Text "Module for text translation"
    .LINK
    https://github.com/Lifailon/Console-Translate
    https://translate.google.com
    https://www.deepl.com
    https://mymemory.translated.net
    #>
    param (
        [Parameter(Mandatory,ValueFromPipeline)][string]$Text,
        $LanguageTarget,
        $LanguageSource,
        [ValidateSet("Google","DeepL","MyMemory")][string]$Provider = "Google",
        [switch]$Alternatives,
        [string]$Key = "AIzaSyBOti4mM-6x9WDnZIjIeyEU21OpBXqWBgw",
        [switch]$LanguageSelected 
    )
    ### Language definition
    if (($null -eq $LanguageTarget) -and ($null -eq $LanguageSource)) {
        if (($Text -match "[А-я]") -and ($Text -notmatch "[A-z]")) {
            $LanguageTarget = "EN"
        }
        elseif (($Text -match "[A-z]") -and ($Text -notmatch "[А-я]")) {
            $LanguageTarget = "RU"
        }
        else {
            $Text_Char_Array = $Text.ToCharArray()
            $count_ru = 0
            $count_en = 0
            foreach ($char in $Text_Char_Array) {
                if ($char -match "[А-я]") {
                    $count_ru += 1
                }
                elseif ($char -match "[A-z]") {
                    $count_en += 1
                }
            }
            if ($count_ru -ge $count_en) {
                $LanguageTarget = "EN"
            }
            elseif ($count_en -ge $count_ru) {
                $LanguageTarget = "RU"
            }
        }
        if ($LanguageTarget -eq "RU") {
            $LanguageSource = "EN"
        }
        elseif ($LanguageTarget -eq "EN") {
            $LanguageSource = "RU"
        }
    }
    elseif (($null -ne $LanguageTarget) -and ($null -eq $LanguageSource)) {
        if ($LanguageTarget -eq "RU") {
            $LanguageSource = "EN"
        }
        elseif ($LanguageTarget -eq "EN") {
            $LanguageSource = "RU"
        }
    }
    elseif (($null -eq $LanguageTarget) -and ($null -ne $LanguageSource)) {
        if ($LanguageSource -eq "RU") {
            $LanguageTarget = "EN"
        }
        elseif ($LanguageSource -eq "EN") {
            $LanguageTarget = "RU"
        }
    }
    ### Debug
    if ($LanguageSelected) {
        Write-Host "Language Source: $LanguageSource"
        Write-Host "Language Target: $LanguageTarget"
    }
    ### Google
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
    ### DeepL
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
    ### MyMemory
    elseif ($Provider -eq "MyMemory") {
        $url = "https://api.mymemory.translated.net/get?q=$($Text)&langpair=$($LanguageSource)|$($LanguageTarget)"
        $Response = Invoke-RestMethod $url
        if ($Alternatives) {
            $Response.matches.translation
        } else {
            $Response.responseData.translatedText
        }
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