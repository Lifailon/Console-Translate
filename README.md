# Console-Translate

PowerShell module for translating text directly in the console using Google/DeepL api and DeepLX.

The work of the **module is automated and free of charge**, no additional intervention in the work of the module is required from you.

## 🚀 Install module

For fast install or update module and dependences (DeepLX) from GutHub repository, use the Deploy script with a single cmdlet in your PowerShell console:

```
Invoke-Expression(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/Lifailon/Console-Translate/rsa/Deploy-Console-Translate.ps1")
```

Import module for detailed information:

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
    Get-Translate [-Text] <String[]> [[-Language] <String>] [[-Provider] <String>] [[-Key] <String>] [<CommonParameters>]

DESCRIPTION
    Example:
    Get-Translate game ru
    Get-Translate -Text "I like to play games" -Language ru
    Get-Translate -Text "I like to play games" -Language ru -Provider DeepL

RELATED LINKS
    https://github.com/Lifailon/Console-Translate```
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

## Example use API

To translate using Google Translate, a **public API key** has been added to the module (default for the **parameter: -Key**). To use your DeepL key, you must register on the **[provider website](https://www.deepl.com/ru/pro-api?cta=header-pro-api)**, create free token and specify it in the **parameter: -Key**.

```PowerShell
> Get-Translate game ru
игра
> Get-Translate -Text "I like to play games" -Language ru
Я люблю играть в игры
> $Token = "YOUR_TOKEN"
> Get-Translate -Text "I like to play games" -Language ru -Provider DeepL -Key $Token
Я люблю играть в игры
```

## DeepLX

Source: **[DeepLX](https://github.com/OwO-Network/DeepLX)**

The following cmdlets are used to start and access the **DeepLX server**:

```PowerShell
Start-DeepLX
Stop-DeepLX
Get-DeepLX
```

### Local server

When calling the module, if the remote server address is not specified (**parameter: -Server**), the **local server is started for the time of sending a request and receiving a response**, after which the server stops, it allows not to keep resources and socket open.

```PowerShell
> Get-DeepLX -Text "When calling the module, if the remote server address is not specified (parameter: -Server), the local server is started for the time of sending a request and receiving a response, after which the server stops, it allows not to keep resources and socket open." ru
При вызове модуля, если не указан адрес удаленного сервера (параметр: -Server), запускается локальный сервер на время отправки запроса и получения ответа, после чего сервер останавливается, это позволяет не держать ресурсы и сокет открытым.

> Get-DeepLX -Text "When calling the module, if the remote server address is not specified (parameter: -Server), the local server is started for the time of sending a request and receiving a response, after which the server stops, it allows not to keep resources and socket open." de
Wenn beim Aufruf des Moduls die Adresse des entfernten Servers nicht angegeben wird (Parameter: -Server), wird der lokale Server für die Zeit des Sendens einer Anfrage und des Empfangs einer Antwort gestartet, danach stoppt der Server, er erlaubt es nicht, Ressourcen und Socket offen zu halten.
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
> Get-DeepLX -Server 192.168.3.99 -Text "I like to play games" ru
Я люблю играть в игры
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
