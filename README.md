<h1 align="center">
    <img src="image/x256.png" width="35" /> Console-Translate
<h2>

<p align="center">
    <a href="https://nuget.org/packages/Console-Translate"><img title="NuGet Version"src="https://img.shields.io/nuget/v/Console-Translate?logo=NuGet&label=NuGet&color=blue&logoColor=blue"></a>
    <a href="https://www.myget.org/feed/lifailon/package/nuget/Console-Translate"><img title="MyGet Version"src="https://img.shields.io/myget/lifailon/v/Console-Translate?logo=MyGet&label=MyGet&color=white&logoColor=white"></a>
</p>

<h3 align="center">
    ⚠ This module is not planned to be supported.
    <br>
    Try it cross-platform <a href="https://github.com/Lifailon/multranslate" target="_blank">TUI for translating text</a> using multiple providers simultaneously. 
</h3>

PowerShell module (cross-platform cli client) for **free text translation** using [Google](https://github.com/matheuss/google-translate-api) (public [serverless](https://github.com/olavoparno/translate-serverless-vercel) on Vercel), [DeepLX](https://github.com/OwO-Network/DeepLX) (public [serverless](https://github.com/LegendLeo/deeplx-serverless) on [Vercel](https://github.com/bropines/Deeplx-vercel)), [MyMemory](https://mymemory.translated.net/doc/spec.php) and [Reverso](https://www.reverso.net/text-translation) providers via `REST API` (no token required).

- [💡 About](#-about)
- [🚀 Install module to Windows](#-install-module-to-windows)
- [🐧 Install module to Linux](#-install-module-to-linux)
- [🎉 Examples](#-examples)
- [🔨 DeepLX](#-deeplx)
- [📢 Module not using API](#-module-not-using-api)

## 💡 About

The module can be very useful if you spend a lot of time in the console or do not want to use a browser or third-party applications to translate text.

The work of the **module is automated and free of charge**, no additional intervention in the work of the module is required from you.

The process of determining the language for the `LanguageSource` and `LanguageTarget` parameters is automated between **Russian and English**. This process can be automated for any language.

This module also automates the process of launching the DeepLX server for local or remote use on other machines (e.g. those without Internet access).

Tested on Windows 10/11 and Ubuntu Server 20.04+ using PowerShell Core version 7.2 +.

---

## 🚀 Install module to Windows

- Use the [NuGet](https://www.nuget.org/packages/Console-Translate) package manager (pre-register the repository if you haven't already):

```PowerShell
Register-PSRepository -Name "NuGet" -SourceLocation "https://www.nuget.org/api/v2" -InstallationPolicy Trusted
Install-Module Console-Translate -Repository NuGet
```

- Use the [MyGet](https://www.myget.org/feed/lifailon/package/nuget/Console-Translate) package manager:

```PowerShell
Register-PSRepository -Name "lifailon" -SourceLocation "https://www.myget.org/F/lifailon/api/v2" -InstallationPolicy Trusted
Install-Module Console-Translate -Repository lifailon
```

- Use the [Chocolatey](https://community.chocolatey.org/packages/Console-Translate) package manager:

```PowerShell
choco install console-translate
```

- Install a module from the GitHub repository with a single command in the console:

```PowerShell
Invoke-Expression(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/Lifailon/Console-Translate/rsa/Deploy-Console-Translate.ps1")
```

Import the module:

```PowerShell
Import-Module Console-Translate
Get-Command -Module Console-Translate

CommandType     Name                 Version    Source
-----------     ----                 -------    ------
Function        Get-Translate        0.3        Console-Translate
Function        Install-DeepLX       0.3        Console-Translate
Function        Start-DeepLX         0.3        Console-Translate
Function        Stop-DeepLX          0.3        Console-Translate
Function        Get-DeepLX           0.3        Console-Translate
```

## 🐧 Install module to Linux

💡 Dependence: [PowerShell Core](https://github.com/PowerShell/PowerShell)

- Example install PowerShell to Ubuntu:

```Bash
sudo apt-get install -y wget apt-transport-https software-properties-common
curl -s https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -o packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell
```

- Install module:

```shell
pwsh -c 'Invoke-Expression(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/Lifailon/Console-Translate/rsa/Deploy-Console-Translate.ps1")'
```

Run the PowerShell interpreter using the `pwsh` command. All commands for Windows are identical for execution in Linux on PowerShell Core (pwsh).

---

## 🎉 Examples

![Example](image/Example.gif)

> The example uses the first release (version 0.1) of the module.

You can see in the right corner how long each translation request takes (this does not depend on the amount of text being transferred).

```PowerShell
Get-Translate "Module for text translation" -Provider Google
Модуль для перевода текста

Get-Translate "Модуль для перевода текста"
Text translation module

Get-Translate "Hello друг" -LanguageSelected
Language Source: EN
Language Target: RU
Привет друг

Get-Translate "Привет world" -LanguageSelected
Language Source: RU
Language Target: EN
Hello world

Get-Translate "Module for text translation" -Provider DeepL
Модуль для перевода текста

Get-Translate "Module for text translation" -Provider MyMemory
Модуль для перевода текста
Текстовый перевод.
Перевод текста БД

Get-Translate "Module for text translation" -Provider Reverso
Модуль перевода текстов
```

## 🔨 DeepLX

Install or update the [DeepLX](https://github.com/OwO-Network/DeepLX) server executable for local or remote use with a single command (for Windows and Linux):

```PowerShell
Install-DeepLX
```

The following cmdlets are used to start and access the **DeepLX server**:

```PowerShell
Start-DeepLX
Stop-DeepLX
Get-DeepLX
```

### Local server

When calling the module, if the remote server address is not specified (**parameter: Server**), the **local server is started for the time of sending a request and receiving a response**, after which the server stops, it allows not to keep resources and socket open.

```PowerShell
Get-DeepLX "Получить выбор"
Get a choice
Get the choice
Get your choice

Get-DeepLX "Get select" ru
Выбрать
Выберите
Получите выбор

Get-DeepLX "Get select" ja # from English to Japanese
セレクトする
セレクト
選択

Get-DeepLX "Get select" tr # from English to Turkish
Seçim yapın
Seçiniz
Seçin
```

### Remote server

If you need to use a single server to handle all requests from multiple clients on the network, you can use this construct:

**📭 Start the server:**

```PowerShell
Start-DeepLX -Job
Start-DeepLX -Status
Running
```

The default port is `1188` and the api key is `7777777777`.

**✉️ Execute a requests to the remote server:**

```PowerShell
Get-DeepLX -Text "Получить выбор" -Server 192.168.3.100
Получить выбор

Get-DeepLX -Text "Get select" -Server 192.168.3.100 -Port 1188 -Key "7777777777"
Получить выбор
```

**Server stop:**

```PowerShell
Stop-DeepLX
Start-DeepLX -Status
Not running
```

---

## Windows Terminal

To speed up the process of interacting with the module, program hotkeys in [Windows Terminal](https://github.com/microsoft/terminal):

Open the `JSON configuration file` in Application Settings and add or edit the `Actions` block:

```json
"actions": 
    [
        {
            "command": 
            {
                "action": "copy",
                "singleLine": false
            },
            "keys": "ctrl+c" // default: ctrl+shift+c
        },
        {
            "command": "paste",
            // We save the classic interpreter insertion via ctrl+v, without forcing you to execute the code line by line
            "keys": "ctrl+shift+v" // default: ctrl+v
        },
        {
            "command": 
            {
                "action": "sendInput",
                "input": "\u0001\u001b[3~Get-Translate -Provider Google ''\u001b[D"
            },
            "keys": "ctrl+g"
        },
        {
            "command": 
            {
                "action": "sendInput",
                "input": "\u0001\u001b[3~Get-Translate -Provider Google -Text $(Get-Clipboard)\u001b[D\r"
            },
            "keys": "ctrl+shift+g"
        }
    ]
```

The first two command blocks are responsible for redefining the copy and paste keys from the clipboard (use `Ctrl+C` and `Ctrl+V` as in the classic PowerShell terminal, getting rid of intrusive warnings about pasting text and line-by-line execution of commands).

The third parameter is responsible for processing the `Ctrl+G` key press, which preliminarily clears the input line, after which it causes the text to be inserted: `Get-Translate -Provider Google ''` and moves the cursor to the center of the quotation marks, which allows you to enter text and call translation immediately after pressing . The last command does the same thing, but pastes text from the clipboard (using the built-in `Get-Clipboard` command) and calls execution to instantly translate the text when you press `Ctrl+Shift+G`.

> Similarly, you can assign the translation call for DeepL, MyMemory and Reverso to other key combinations.

---

## 📢 Module not using API

You can use a module that dont use an API, instead **using Selenium via .NET to PowerShell** for compose requests directly to the application:

Automated deployment and updating of all dependencies: Deploy Selenium: [Deploy-Selenium](https://github.com/Lifailon/Deploy-Selenium)

Repository: **[Selenium-Modules](https://github.com/Lifailon/Selenium-Modules)**

Module: **[Get-Translate](https://github.com/Lifailon/Selenium-Modules/blob/rsa/Modules/Get-Translation/Get-Translation.psm1)**