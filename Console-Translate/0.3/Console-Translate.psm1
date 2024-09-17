function Get-Translate {
    <#
    .SYNOPSIS
    PowerShell module (cross-platform cli client) for free text translation using Google, DeepL, MyMemory and Reverso providers via REST API
    .DESCRIPTION
    Example:
        Get-Translate "Module for text translation" -Provider Google
        Get-Translate "Модуль для перевода текста"
        Get-Translate "Hello друг" -LanguageSelected
        Get-Translate "Привет world" -LanguageSelected
        Get-Translate "Module for text translation" -Provider DeepL
        Get-Translate "Module for text translation" -Provider MyMemory
        Get-Translate "Module for text translation" -Provider Reverso
        Get-Translate -Text "Модуль для перевода текста" -LanguageSource ru -LanguageTarget en
    .LINK
    https://github.com/Lifailon/Console-Translate
    https://nuget.org/packages/Console-Translate
    https://github.com/matheuss/google-translate-api
    https://github.com/olavoparno/translate-serverless-vercel
    https://github.com/OwO-Network/DeepLX
    https://github.com/LegendLeo/deeplx-serverless
    https://github.com/bropines/Deeplx-vercel
    https://mymemory.translated.net/doc/spec.php
    https://reverso.net/text-translation
    #>
    param (
        [Parameter(Mandatory,ValueFromPipeline)][string]$Text,
        [Parameter(Mandatory = $false)]
        [ValidateSet(
            "ru",
            "en"
        )][string]$LanguageTarget,
        [Parameter(Mandatory = $false)]
        [ValidateSet(
            "ru",
            "en"
        )][string]$LanguageSource,
        [ValidateSet(
            "Google",
            "DeepL",
            "MyMemory",
            "Reverso"
        )][string]$Provider = "Google",
        [switch]$LanguageSelected
    )
    ### Language definition (only Russian and English are supported)
    if (($LanguageTarget.Length -eq 0) -and ($LanguageSource.Length -eq 0)) {
        if (($Text -match "[А-я]") -and ($Text -notmatch "[A-z]")) {
            $LanguageTarget = "en"
        }
        elseif (($Text -match "[A-z]") -and ($Text -notmatch "[А-я]")) {
            $LanguageTarget = "ru"
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
                $LanguageTarget = "en"
            }
            elseif ($count_en -ge $count_ru) {
                $LanguageTarget = "ru"
            }
        }
        if ($LanguageTarget -eq "ru") {
            $LanguageSource = "en"
        }
        elseif ($LanguageTarget -eq "en") {
            $LanguageSource = "ru"
        }
    }
    elseif (($null -ne $LanguageTarget) -and ($null -eq $LanguageSource)) {
        if ($LanguageTarget -eq "ru") {
            $LanguageSource = "en"
        }
        elseif ($LanguageTarget -eq "en") {
            $LanguageSource = "ru"
        }
    }
    elseif (($null -eq $LanguageTarget) -and ($null -ne $LanguageSource)) {
        if ($LanguageSource -eq "ru") {
            $LanguageTarget = "en"
        }
        elseif ($LanguageSource -eq "en") {
            $LanguageTarget = "ru"
        }
    }
    ### Debug
    if ($LanguageSelected) {
        Write-Host "Language Source: $LanguageSource"
        Write-Host "Language Target: $LanguageTarget"
    }
    ### Google
    if ($Provider -eq "Google") {
        # $url = "https://translation.googleapis.com/language/translate/v2?key=${key}"
        $url = "https://translate-serverless.vercel.app/api/translate"
        $Header = @{
            "Content-Type" = "application/json"
        }
        $Body = @{
            "message" = "$Text"
            "to" = "$LanguageTarget"
            "from" = "$LanguageSource"
        } | ConvertTo-Json
        # $Body = @{
        #     "q" = "$Text"
        #     "target" = "$LanguageTarget"
        #     "source" = "$LanguageSource"
        # } | ConvertTo-Json
        #$WebClient = New-Object System.Net.WebClient
        #foreach ($key in $Header.Keys) {
        #    $WebClient.Headers.Add($key, $Header[$key])
        #}
        try {
            # $Response = $WebClient.UploadString($url, "POST", $Body) | ConvertFrom-Json
            # $Response.data.translations.translatedText
            $Response = Invoke-RestMethod -Uri $url -Method Post -Headers $Header -Body $Body
            return $Response.translation.trans_result.dst
        }
        catch {
            return $_.Exception.Message
        }
    }
    ### DeepL
    elseif ($Provider -eq "DeepL") {
        $url = "https://deeplx-vercel-phi.vercel.app/api/translate"
        $Header = @{
            "Content-Type" = "application/json"
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
        try {
            $Response = $WebClient.UploadString($url, "POST", $Body) | ConvertFrom-Json
            return $Response.data    
        }
        catch {
            return $_.Exception.Message
        }
    }
    ### MyMemory
    elseif ($Provider -eq "MyMemory") {
        try {
            $url = "https://api.mymemory.translated.net/get?q=$($Text)&langpair=$($LanguageSource)|$($LanguageTarget)"
            $Response = Invoke-RestMethod $url
            return $Response.matches.translation
        }
        catch {
            return $_.Exception.Message
        }
    }
    ### Reverso
    elseif ($Provider -eq "Reverso") {
        $url = "https://api.reverso.net/translate/v1/translation"
        $Body = @{
            "format" = "text"
            "input" = $Text
            "to" = $LanguageTarget
            "from" = $LanguageSource
            "options" = @{
                "sentenceSplitter" = $true
                "origin" = "translation.web"
                "contextResults" = $true
                "languageDetection" = $true
            }
        } | ConvertTo-Json -Depth 10
        try {
            $Response = Invoke-RestMethod -UseBasicParsing -Uri $url -Method "POST" -ContentType "application/json" -Body $Body            
            return $Response.translation
        }
        catch {
            return $_.Exception.Message
        }
    }
}

function Install-DeepLX {
    <#
    .SYNOPSIS
    Install or update the DeepLX executable for Windows and Linux from the GitHub repository
    .DESCRIPTION
    Example:
        Install-DeepLX
    .LINK
    https://github.com/Lifailon/Console-Translate
    https://nuget.org/packages/Console-Translate
    https://github.com/OwO-Network/DeepLX
    #>
    # if ($IsLinux) {
    #     $path = ($env:PSModulePath.Split(":")[0])+"/Console-Translate"
    # }
    # else {
    #     $path = ($env:PSModulePath.Split(";")[0])+"\Console-Translate"
    # }
    # $Module_Version = $(Get-ChildItem $path).Name
    $Module_Path = Split-Path $(Get-Module Console-Translate).path
    if ($IsLinux) {
        $DeepLX_Path = "$Module_Path/deeplx"
        $DeepLX_Releases_Latest = Invoke-RestMethod "https://api.github.com/repos/OwO-Network/DeepLX/releases/latest"
        [string]$DeepLX_Download_url = $($DeepLX_Releases_Latest.assets | Where-Object Name -Match "linux_amd64").browser_download_url
        chmod +x $DeepLX_Path
    }
    else {
        $DeepLX_Path = "$Module_Path\deeplx.exe"
        $DeepLX_Releases_Latest = Invoke-RestMethod "https://api.github.com/repos/OwO-Network/DeepLX/releases/latest"
        [string]$DeepLX_Download_url = ($DeepLX_Releases_Latest.assets | Where-Object Name -Match "amd64.exe").browser_download_url
    }
    #(New-Object Net.WebClient).DownloadString($DeepLX_Download_url) | Out-File $DeepLX_Path -Encoding default -Force
    Invoke-RestMethod -Uri $DeepLX_Download_url -OutFile $DeepLX_Path
}

function Start-DeepLX {
    <#
    .SYNOPSIS
    Starting local server in console or background job mode
    .DESCRIPTION
    Example:
        Start-DeepLX -Token "7777777777" -Port 1188
        Start-DeepLX -Job
        Start-DeepLX -Status
    .LINK
    https://github.com/Lifailon/Console-Translate
    https://nuget.org/packages/Console-Translate
    https://github.com/OwO-Network/DeepLX
    #>
    param (
        [int]$Port = 1188,
        [string]$Token = "7777777777",
        [switch]$Job,
        [switch]$Status
    )
    if ($IsLinux) {
        [string]$path = "$(Split-Path $(Get-Module Console-Translate).path)/deeplx"
    }
    else {
        [string]$Path = "$(Split-Path $(Get-Module Console-Translate).path)\deeplx.exe"
    }
    if ($(Test-Path $path) -eq $false) {
        Install-DeepLX
    }
    if ($Status) {
        $Job_State = Get-Job | Where-Object Name -Like "DeepLX"
        if ($Job_State) {
            $Job_State.State
        }
        else {
            Write-Host "Not running"
        }
    }
    else {
        if ($Job) {
            $Test = Get-Job -Name DeepLX -ErrorAction Ignore
            if ($Test) {
                Write-Host "The server is already running" -ForegroundColor Green
            }
            else {
                Start-Job -Name DeepLX {
                    Invoke-Expression "$using:path --token $using:Token --port $using:Port"
                } > $null
            }
            }
        else {
            Invoke-Expression "$path --token $Token --port $Port"
        }
    }
}

function Stop-DeepLX {
    <#
    .SYNOPSIS
    Stoping local server
    .DESCRIPTION
    Example:
        Stop-DeepLX
    .LINK
    https://github.com/Lifailon/Console-Translate
    https://nuget.org/packages/Console-Translate
    https://github.com/OwO-Network/DeepLX
    #>
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
        Get-DeepLX "Помоги перевести текст"
        Get-DeepLX "Помоги перевести текст" en
        Get-DeepLX "Help translate text" ru
        Get-DeepLX "Help translate text" ja # English to Japanese
        Get-DeepLX "テキストの翻訳を手伝う" ru # Japanese to Russian
        Get-DeepLX "Help translate text" zh # English to Chinese
        Get-DeepLX "Help translate text" tr # English to Turkish
    Example use remote server:
        Get-DeepLX -Text "Перевод текста на удаленном сервере" -Server 192.168.3.100
        Get-DeepLX -Text "Перевод текста на удаленном сервере" -Server 192.168.3.100 -Port 1188 -Token "7777777777"
    .LINK
    https://github.com/Lifailon/Console-Translate
    https://nuget.org/packages/Console-Translate
    https://github.com/OwO-Network/DeepLX
    #>
    param (
        [Parameter(Mandatory,ValueFromPipeline)][string[]]$Text,
        [Parameter(Mandatory = $false)]
        [ValidateSet(
            "AR",
            "BG",
            "CS",
            "DA",
            "DE",
            "EL",
            "EN",
            "ES",
            "ET",
            "FI",
            "FR",
            "HU",
            "ID",
            "IT",
            "JA",
            "KO",
            "LT",
            "LV",
            "NB",
            "NL",
            "PL",
            "PT",
            "RO",
            "RU",
            "SK",
            "SL",
            "SV",
            "TR",
            "UK",
            "ZH"
        )][string]$LanguageTarget,
        [Parameter(Mandatory = $false)]
        [ValidateSet(
            "AR",
            "BG",
            "CS",
            "DA",
            "DE",
            "EL",
            "EN",
            "ES",
            "ET",
            "FI",
            "FR",
            "HU",
            "ID",
            "IT",
            "JA",
            "KO",
            "LT",
            "LV",
            "NB",
            "NL",
            "PL",
            "PT",
            "RO",
            "RU",
            "SK",
            "SL",
            "SV",
            "TR",
            "UK",
            "ZH"
        )][string]$LanguageSource,
        [string]$Server,
        [int]$Port = 1188,
        [string]$Token = "7777777777"
    )
    if ($Server) {
        $Server_Running = "False"
    }
    else {
        $Server_Running = "True"
        $Server = "localhost"
        Stop-DeepLX
        Start-DeepLX -Token $Token -Port $Port -Job
    }
    $srv = $Server+":"+$Port
    $url = "http://$srv/translate"
    $Header = @{
        "Content-Type" = "application/json"
        "Authorization" = "Bearer $Token"
    }
    $Body = @{
        "text" = "$Text"
        "target_lang" = "$LanguageTarget"
        "source_lang" = "$LanguageSource"
    } | ConvertTo-Json
    $WebClient = New-Object System.Net.WebClient
    foreach ($Token in $Header.Keys) {
        $WebClient.Headers.Add($Token, $Header[$Token])
    }
    $Response = $WebClient.UploadString($url, "POST", $Body) | ConvertFrom-Json
        # $Response.data
        return $Response.alternatives
    if ($Server_Running -eq "True") {
        Stop-DeepLX
    }
}