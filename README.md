# Console-Translate

PowerShell module for translating text directly in the console using Google/DeepL api and DeepLX

To translate using Google Translate, a **public API key** has been added to the module (default for the **-Key parameter**). To use your DeepL key, you must register on the **provider website** and create a token.

## 🚀 Install module and dependences (DeepLX)

Invoke-Expression(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/Lifailon/Console-Translate/rsa/Deploy-Console-Translate.ps1")

## Example

```PowerShell
Get-Translate game ru
Get-Translate -Text "I like to play games" -Language ru
Get-Translate -Text "I like to play games" -Language ru -Provider DeepL
```

## psDeepLX

The following cmdlets are used to start and access the **DeepLX server**:

```PowerShell
Start-DeepLX
Stop-DeepLX
Get-DeepLX
```

### Local server

When calling the module, if the remote server address parameter is not specified, the **local server is started for the time of sending a request and receiving a response**, after which the server stops, it allows not to keep resources and socket open.

```PowerShell
> Get-DeepLX -Text "I like to play games" ru
Я люблю играть в игры
```

### Remote server

```PowerShell
Start-DeepLX -Job
Get-DeepLX -Server 192.168.3.99 -Text "I like to play games" ru
Stop-DeepLX
Start-DeepLX -Status
```
