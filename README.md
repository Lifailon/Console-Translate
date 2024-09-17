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

---

PowerShell module for **free text translation** using [Google](https://github.com/matheuss/google-translate-api) (public [serverless](https://github.com/olavoparno/translate-serverless-vercel) on Vercel), [DeepLX](https://github.com/OwO-Network/DeepLX) (public [serverless](https://github.com/LegendLeo/deeplx-serverless) on [Vercel](https://github.com/bropines/Deeplx-vercel)), [MyMemory](https://mymemory.translated.net/doc/spec.php) and [Reverso](https://www.reverso.net/text-translation) providers via `REST API` (no token required).

This module also automates the process of installing, updating, managing and working with the DeepLX server.

- 💡 [About](#-about)
- 🚀 [Install module to Windows](#-install-module-to-windows)
- 🐧 [Install module to Linux](#-install-module-to-linux)
- 🎉 [Examples](#-examples)
- 🔨 [DeepLX](#-deeplx)
- 📢 [Module not using API](#-module-not-using-api)

## 💡 About

The module can be very useful if you spend a lot of time in the console or do not want to use a browser or third-party applications to translate text.

The work of the **module is automated and free of charge**, no additional intervention in the work of the module is required from you.

The process of determining the language for the `LanguageSource` and `LanguageTarget` parameters is automated between **Russian and English**. This process can be automated for any language.

This module also automates the process of launching the DeepLX server for local or remote use on other machines (e.g. those without Internet access).

Tested on Windows 10/11 and Ubuntu Server 20.04+ using PowerShell Core version 7.2 +.

---

## 🚀 Install module to Windows

### [NuGet](https://www.nuget.org/packages/Console-Translate)

- Pre-register the NuGet package manager if you have not done so previously:

```PowerShell
Register-PSRepository -Name "NuGet" -SourceLocation "https://www.nuget.org/api/v2" -InstallationPolicy Trusted
```

- Install the module:

```PowerShell
Install-Module Console-Translate -Repository NuGet
```

### [MyGet](https://www.myget.org/feed/lifailon/package/nuget/Console-Translate)

```PowerShell
Register-PSRepository -Name "lifailon" -SourceLocation "https://www.myget.org/F/lifailon/api/v2" -InstallationPolicy Trusted
Install-Module Console-Translate -Repository lifailon
```

<!--
- Use the [Chocolatey](https://community.chocolatey.org/packages/Console-Translate) package manager:

```PowerShell
choco install console-translate
```
-->

### [Scoop](https://scoop.sh)

- Install the package manager:

```PowerShell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser && irm https://get.scoop.sh | Invoke-Expression
```

- Install the module:

```PowerShell
scoop bucket add Console-Translate https://github.com/Lifailon/Console-Translate.git
scoop install Console-Translate
```

- To remove module:

```PowerShell
scoop uninstall Console-Translate && scoop bucket rm Console-Translate
```

### Deploy from GitHub

Deployment a module from the GitHub repository with a single command in the console:

```PowerShell
Invoke-Expression(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/Lifailon/Console-Translate/rsa/deploy-module.ps1")
```

- Import the module:

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
pwsh -c 'Invoke-Expression(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/Lifailon/Console-Translate/rsa/deploy-module.ps1")'
```

Run the PowerShell interpreter using the `pwsh` command. All commands for Windows are identical for execution in Linux by PowerShell Core.

---

## 🎉 Examples

The parameters limit the use of this cmdlet to two languages: **English** (`en`) and **Russian** (`ru`), for which there is **automatic detection of the source language at the PowerShell code level**.

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

Supported languages from the drop-down list (encoded in the parameter) with support for **automatic language detection at the api level**.

| Abbr | EN (RU)                        |
| -    | -                              |
| `EN` | English (Английский)           |
| `RU` | Russian (Русский)              |
| `JA` | Japanese (Японский)            |
| `ZH` | Chinese (Китайский)            |
| `KO` | Korean (Корейский)             |
| `TR` | Turkish (Турецкий)             |
| `UK` | Ukrainian (Украинский)         |
| `SK` | Slovak (Словацкий)             |
| `SL` | Slovenian (Словенский)         |
| `LT` | Lithuanian (Литовский)         |
| `PL` | Polish (Польский)              |
| `CS` | Czech (Чешский)                |
| `FI` | Finnish (Финский)              |
| `ET` | Estonian (Эстонский)           |
| `BG` | Bulgarian (Болгарский)         |
| `DA` | Danish (Датский)               |
| `LV` | Latvian (Латышский)            |
| `IT` | Italian (Итальянский)          |
| `ES` | Spanish (Испанский)            |
| `FR` | French (Французский)           |
| `PT` | Portuguese (Португальский)     |
| `RO` | Romanian (Румынский)           |
| `SV` | Swedish (Шведский)             |
| `HU` | Hungarian (Венгерский)         |
| `EL` | Greek (Греческий)              |
| `NB` | Norwegian Bokmal (Норвежский)  |
| `NL` | Dutch (Нидерландский)          |
| `DE` | German (Немецкий)              |
| `ID` | Indonesian (Индонезийский)     |
| `AR` | Arabic (Арабский)              |

### Local server

Install or update the [DeepLX](https://github.com/OwO-Network/DeepLX) server executable for local or remote use with a single command (for Windows and Linux):

```PowerShell
Install-DeepLX
```

When calling the module, if the remote server address is not specified (**parameter: Server**), the **local server is started for the time of sending a request and receiving a response**, after which the server stops, it allows not to keep network socket open.

```PowerShell
# Russian to English
Get-DeepLX "Помоги перевести текст"
Help translate a text
Help translate the text
Help me translate a text

# English to Russian
Get-DeepLX "Help translate text" ru
Помочь перевести текст
Помощь в переводе текста

# English to Japanese
Get-DeepLX "Help translate text" ja
テキストの翻訳を手伝う
テキストを翻訳する
テキストの翻訳を支援

# Japanese to Russian
Get-DeepLX "テキストの翻訳を手伝う" ru
Помогите перевести тексты.
Помогите переводить тексты.
Помогите перевести текст.

# English to Chinese
Get-DeepLX "Help translate text" zh
帮助翻译文字
协助翻译文本

# English to Turkish
Get-DeepLX "Help translate text" tr
Metni çevirmeye yardımcı olun
Metin çevirisine yardım edin
Metni çevirmeye yardım et
```

### Remote server

If you need to use a single server to handle all requests from multiple clients on the network, you can use this construct:

📭 **Start the server:**

```PowerShell
Start-DeepLX -Job

Start-DeepLX -Status
Running
```

This will allow you to run the server in the backgroundю. The default port is `1188` and the api token (this key is used for authorization on the server) is `7777777777`.

✉️ **Execute a requests to the remote server:**

```PowerShell
Get-DeepLX -Text "Перевод текста на удаленном сервере" -Server 192.168.3.100
Translation of text on a remote server
Translate a text on a remote server
Translating text on a remote server

Get-DeepLX -Text "Перевод текста на удаленном сервере" -Server 192.168.3.100 -Port 1188 -Token "7777777777"
Translation of text on a remote server
Translate a text on a remote server
Translating text on a remote server
```

✋ **Server stop:**

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

> Similarly, you can assign the translation call for DeepL/DeepLX, MyMemory and Reverso to other key combinations.

---

## 📢 Module not using API

You can use a module that dont use an API, instead **using Selenium via .NET to PowerShell** for compose requests directly to the application:

Automated deployment and updating of all dependencies: Deploy Selenium: [Deploy-Selenium](https://github.com/Lifailon/Deploy-Selenium)

Repository: **[Selenium-Modules](https://github.com/Lifailon/Selenium-Modules)**

Module: **[Get-Translate](https://github.com/Lifailon/Selenium-Modules/blob/rsa/Modules/Get-Translation/Get-Translation.psm1)**