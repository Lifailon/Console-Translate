# Console-Translate

PowerShell module for translating text directly in the console using Google/DeepL api and DeepLX.

The work of the **module is automated and free of charge**, no additional intervention in the work of the module is required from you.

Tested on Windows 10, Ubuntu Server 20.04 and 22.04 using PowerShell Core version 7.3.9.

![Image alt](https://github.com/Lifailon/Console-Translate/blob/rsa/Example.gif)

## 🚀 Install module

For fast install or update module and dependences (binary file DeepLX) latest version from GutHub repository, use the Deploy script with a single cmdlet in your PowerShell console:

```
Invoke-Expression(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/Lifailon/Console-Translate/rsa/Deploy-Console-Translate.ps1")
```

Import module for detailed information (syntax):

```PowerShell
> Import-Module Console-Translate
> Get-Command -Module Console-Translate

CommandType     Name                 Version    Source
-----------     ----                 -------    ------
Function        Get-DeepLX           0.1        Console-Translate
Function        Get-Translate        0.1        Console-Translate
Function        Start-DeepLX         0.1        Console-Translate
Function        Stop-DeepLX          0.1        Console-Translate

> Get-Help Get-Translate

NAME
    Get-Translate

SYNOPSIS
    Text translation using Google and DeepL providers via REST API

SYNTAX
    Get-Translate [-Text] <String[]> [[-LanguageTarget] <String>] [[-LanguageSource] <String>] [[-Provider] <String>] [[-Key] <String>] [<CommonParameters>]

DESCRIPTION
    Example:
    Get-Translate -Text "Module for text translation" ru
    Get-Translate -Text "Модуль для перевода текста" en
    Get-Translate -Text "Модуль для перевода текста" -LanguageTarget en -LanguageSource ru
    $Token = "YOUR_TOKEN"
    Get-Translate -Text "Module for text translation" -LanguageTarget ru -Provider DeepL -Key $Token

RELATED LINKS
    https://github.com/Lifailon/Console-Translate
```

### 🐧 Use to Linux

Dependence: **[PowerShell Core](https://github.com/PowerShell/PowerShell)**

Example install to Ubuntu: **apt install pwsh**

Install module:

```
pwsh -c 'Invoke-Expression(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/Lifailon/Console-Translate/rsa/Deploy-Console-Translate.ps1")'
```

Enter in to the PowerShell Core interpreter (**pwsh**) and import the module:

```PowerShell
lifailon@netbox-01:~$ pwsh
PowerShell 7.3.9
PS /home/lifailon> Import-Module Console-Translate
```

All commands for Windows are identical for execution in Linux on PowerShell Core (pwsh).

## Example use API

To translate using Google Translate, a **public API key** has been added to the module (default for the **parameter: -Key**). To use your DeepL key, you must register on the **[provider website](https://www.deepl.com/ru/pro-api?cta=header-pro-api)**, create free token and specify it in the **parameter: -Key**.

```PowerShell
> Get-Translate -Text "Module for text translation" ru
Модуль для перевода текста
> Get-Translate -Text "Модуль для перевода текста" en
Text translation module
> Get-Translate -Text "Модуль для перевода текста" -LanguageTarget en -LanguageSource ru
Text translation module
> $Token = "YOUR_TOKEN"
> Get-Translate -Text "Module for text translation" -LanguageTarget ru -Provider DeepL -Key $Token
Модуль для перевода текста
```

## DeepLX

Project source: **[DeepLX](https://github.com/OwO-Network/DeepLX)**

The following cmdlets are used to start and access the **DeepLX server**:

```PowerShell
Start-DeepLX
Stop-DeepLX
Get-DeepLX
```

### Local server

When calling the module, if the remote server address is not specified (**parameter: -Server**), the **local server is started for the time of sending a request and receiving a response**, after which the server stops, it allows not to keep resources and socket open.

```PowerShell
> Get-DeepLX "Get select" de
Auswahl treffen

> Get-DeepLX "Get select" ru
Получить выбор

> Get-DeepLX "Получить выбор" en
Get Choice

> Get-DeepLX "Получить выбор" en -Alternatives
Get a choice
Get the choice
Get your choice
```

### Remote server

If you need to use a single server to handle all requests from multiple clients on the network, you can use this construct:

**📭 Start the server:**

```PowerShell
> Start-DeepLX -Job
> Start-DeepLX -Status
Running
```

**✉️ Execute a requests to the remote server:**

```PowerShell
> Get-DeepLX -Server 192.168.3.99 -Text "Module for text translation" ru
Модуль для перевода текста
```

**Server stop:**

```PowerShell
> Stop-DeepLX
> Start-DeepLX -Status
Not running
```

## Module not using API

You can use a module that dont use an API, instead **using Selenium** to compose requests directly to the application:

Repository: **[Selenium-Modules](https://github.com/Lifailon/Selenium-Modules)**

Module: **[Get-Translate](https://github.com/Lifailon/Selenium-Modules/blob/rsa/Modules/Get-Translate.psm1)**
