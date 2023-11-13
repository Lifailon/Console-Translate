# Console-Translate

PowerShell module for translating text directly in the console using api and DeepLX

To translate using Google Translate, a **public API key** has been added to the module (default for the **-Key parameter**). To use your DeepL key, you must register on the **provider website** and create a token.

## 🚀 Install module and dependences (DeepLX)

Invoke-Expression(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/Lifailon/Console-Translate/rsa/Deploy-Console-Translate.ps1")

## Example

Get-Translate game ru
Get-Translate -Text "I like to play games" -Language ru
Get-Translate -Text "I like to play games" -Language ru -Provider DeepL

## psDeepLX

The following cmdlets are used to start and access the **DeepLX server**:

```PowerShell
Start-DeepLX
Stop-DeepLX
Get-DeepLX
```

### Local server

Get-DeepLX -Text "I like to play games" ru


### Remote server

Start-DeepLX -Job
Get-DeepLX -Server 192.168.3.99 -Text "I like to play games" ru
Stop-DeepLX
Start-DeepLX -Status
