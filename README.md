# Console-Translate

PowerShell module for translating text directly in the console PowerShell. 

Used providers:

- **[Google](https://cloud.google.com/translate/docs/reference/api-overview)** (public API key added to the default parameter);
- **[DeepL](https://www.deepl.com/ru/docs-api)**  (required [API token](https://www.deepl.com/ru/pro-api?cta=header-pro-api)) and **[DeepLX](https://github.com/OwO-Network/DeepLX)** (free API, no token required);
- **[MyMemory](https://mymemory.translated.net/doc/spec.php)** (API key not required).

> 💡 The work of the **module is automated and free of charge**, no additional intervention in the work of the module is required from you.

Tested on Windows 10, Ubuntu Server 20.04 and 22.04 using PowerShell Core version 7.2 +.

![Image alt](https://github.com/Lifailon/Console-Translate/blob/rsa/Example.gif)

You can see in the right corner how long each translation request takes (this does not depend on the amount of text being transferred).

- [🚀 Install module to Windows](#-install-module-to-windows)
- [🐧 Install module to Linux](#-install-module-to-linux)
- [🎉 Examples](#-examples)
- [📑 Getting language codes](#-getting-language-codes)
- [📢 Module not using API](#-module-not-using-api)

## 🚀 Install module to Windows

For fast install or update module and dependences (binary file DeepLX) latest version from GutHub repository, use the Deploy script with a single cmdlet in your PowerShell console:

```
Invoke-Expression(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/Lifailon/Console-Translate/rsa/Deploy-Console-Translate.ps1")
```

Import module for detailed information (syntax):

```PowerShell
> Import-Module Console-Translate
> Get-Command -Module Console-Translate

CommandType     Name                  Version    Source
-----------     ----                  -------    ------
Function        Get-DeepLX            0.2        Console-Translate
Function        Get-LanguageCode      0.2        Console-Translate
Function        Get-Translate         0.2        Console-Translate
Function        Start-DeepLX          0.2        Console-Translate
Function        Stop-DeepLX           0.2        Console-Translate
```

## 🐧 Install module to Linux

Dependence: **[PowerShell Core](https://github.com/PowerShell/PowerShell)**

Example install to Ubuntu:

```Bash
sudo apt-get install -y wget apt-transport-https software-properties-common
curl -s https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -o packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell
```

Install module:

```
pwsh -c 'Invoke-Expression(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/Lifailon/Console-Translate/rsa/Deploy-Console-Translate.ps1")'
```

Enter in to the PowerShell Core interpreter (**pwsh**) and import the module:

```PowerShell
root@hv-devops-01:/home/lifailon# pwsh
PowerShell 7.4.1
PS /home/lifailon> Import-Module Console-Translate
```

All commands for Windows are identical for execution in Linux on PowerShell Core (pwsh).

## 🎉 Examples

To translate using Google Translate, a **public API key** has been added to the module (default for the **parameter: -Key**). To use your DeepL key, you must register on the **[provider website](https://www.deepl.com/ru/pro-api?cta=header-pro-api)**, create free token and specify it in the **parameter: -Key**.

```PowerShell
> Get-Translate "Module for text translation"
Модуль для перевода текста

> Get-Translate "Модуль для перевода текста"
Text translation module

> Get-Translate "Привет world" -LanguageSelected
Language Source: RU
Language Target: EN
Hello world

> Get-Translate "Hello друг" -LanguageSelected
Language Source: EN
Language Target: RU
Привет друг

> Get-Translate -Text "Модуль для перевода текста" -LanguageSource ru -LanguageTarget tr # Russian -> Turkish
Metin çeviri modülü

> Get-Translate -Provider MyMemory -Text "MyMemory is the world's largest Translation Memory. It has been created collecting TMs from the European Union and United Nations, and aligning the best domain-specific multilingual websites."
MyMemory - крупнейшая в мире память переводов. Он был создан для сбора ТМ из Европейского Союза и Организации Объединенных Наций и согласования лучших многоязычных веб-сайтов, ориентированных на конкретные области.
```

### DeepLX

Project source: **[DeepLX](https://github.com/OwO-Network/DeepLX)**

The following cmdlets are used to start and access the **DeepLX server**:

```PowerShell
Start-DeepLX
Stop-DeepLX
Get-DeepLX
```

### Local server

When calling the module, if the remote server address is not specified (**parameter: Server**), the **local server is started for the time of sending a request and receiving a response**, after which the server stops, it allows not to keep resources and socket open.

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

# 📑 Getting language codes

Getting language codes standart [ISO-639-1](https://ru.wikipedia.org/wiki/ISO_639-1):

```PowerShell
Country                                             Code
-------                                             ----
Abkhaz                                              ab
Afar                                                aa
Afrikaans                                           af
Akan                                                ak
Albanian                                            sq
Amharic                                             am
Arabic                                              ar
Aragonese                                           an
Armenian                                            hy
Assamese                                            as
Avaric                                              av
Avestan                                             ae
Aymara                                              ay
Azerbaijani                                         az
Bambara                                             bm
Bashkir                                             ba
Basque                                              eu
Belarusian                                          be
Bengali, Bangla                                     bn
Bihari                                              bh
Bislama                                             bi
Bosnian                                             bs
Breton                                              br
Bulgarian                                           bg
Burmese                                             my
Catalan                                             ca
Chamorro                                            ch
Chechen                                             ce
Chichewa, Chewa, Nyanja                             ny
Chinese                                             zh
Chuvash                                             cv
Cornish                                             kw
Corsican                                            co
Cree                                                cr
Croatian                                            hr
Czech                                               cs
Danish                                              da
Divehi, Dhivehi, Maldivian                          dv
Dutch                                               nl
Dzongkha                                            dz
Eastern Punjabi, Eastern Panjabi                    pa
English                                             en
Esperanto                                           eo
Estonian                                            et
Ewe                                                 ee
Faroese                                             fo
Fijian                                              fj
Finnish                                             fi
French                                              fr
Fula, Fulah, Pulaar, Pular                          ff
Galician                                            gl
Ganda                                               lg
Georgian                                            ka
German                                              de
Greek                                               el
Guarani                                             gn
Gujarati                                            gu
Haitian, Haitian Creole                             ht
Hausa                                               ha
Hebrew                                              he
Herero                                              hz
Hindi                                               hi
Hiri Motu                                           ho
Hungarian                                           hu
Icelandic                                           is
Ido                                                 io
Igbo                                                ig
Indonesian                                          id
Interlingua                                         ia
Interlingue                                         ie
Inuktitut                                           iu
Inupiaq                                             ik
Irish                                               ga
Italian                                             it
Japanese                                            ja
Javanese                                            jv
Kalaallisut, Greenlandic                            kl
Kannada                                             kn
Kanuri                                              kr
Kashmiri                                            ks
Kazakh                                              kk
Khmer                                               km
Kikuyu, Gikuyu                                      ki
Kinyarwanda                                         rw
Kirundi                                             rn
Komi                                                kv
Kongo                                               kg
Korean                                              ko
Kurdish                                             ku
Kwanyama, Kuanyama                                  kj
Kyrgyz                                              ky
Lao                                                 lo
Latin                                               la
Latvian                                             lv
Limburgish, Limburgan, Limburger                    li
Lingala                                             ln
Lithuanian                                          lt
Luba-Katanga                                        lu
Luxembourgish, Letzeburgesch                        lb
Macedonian                                          mk
Malagasy                                            mg
Malay                                               ms
Malayalam                                           ml
Maltese                                             mt
Manx                                                gv
Marathi                                             mr
Marshallese                                         mh
Mongolian                                           mn
Maori                                               mi
Nauruan                                             na
Navajo, Navaho                                      nv
Ndonga                                              ng
Nepali                                              ne
Northern Ndebele                                    nd
Northern Sami                                       se
Norwegian                                           no
Norwegian Bokmal                                    nb
Norwegian Nynorsk                                   nn
Nuosu                                               ii
Occitan                                             oc
Ojibwe, Ojibwa                                      oj
Old Church Slavonic, Church Slavonic, Old Bulgarian cu
Oriya                                               or
Oromo                                               om
Ossetian, Ossetic                                   os
Pashto, Pushto                                      ps
Persian                                             fa
Polish                                              pl
Portuguese                                          pt
Pali                                                pi
Quechua                                             qu
Romanian                                            ro
Romansh                                             rm
Russian                                             ru
Samoan                                              sm
Sango                                               sg
Sanskrit                                            sa
Sardinian                                           sc
Scottish Gaelic, Gaelic                             gd
Serbian                                             sr
Shona                                               sn
Sindhi                                              sd
Sinhalese, Sinhala                                  si
Slovak                                              sk
Slovene                                             sl
Somali                                              so
Southern Ndebele                                    nr
Southern Sotho                                      st
Spanish                                             es
Sundanese                                           su
Swahili                                             sw
Swati                                               ss
Swedish                                             sv
Tagalog                                             tl
Tahitian                                            ty
Tajik                                               tg
Tamil                                               ta
Tatar                                               tt
Telugu                                              te
Thai                                                th
Tibetan Standard, Tibetan, Central                  bo
Tigrinya                                            ti
Tonga                                               to
Tsonga                                              ts
Tswana                                              tn
Turkish                                             tr
Turkmen                                             tk
Twi                                                 tw
Ukrainian                                           uk
Urdu                                                ur
Uyghur                                              ug
Uzbek                                               uz
Venda                                               ve
Vietnamese                                          vi
Volapuk                                             vo
Walloon                                             wa
Welsh                                               cy
Western Frisian                                     fy
Western Frisian                                     wo
Xhosa                                               xh
Yiddish                                             yi
Yoruba                                              yo
Zhuang, Chuang                                      za
Zulu                                                zu
```

## 📢 Module not using API

You can use a module that dont use an API, instead **using Selenium** to compose requests directly to the application:

Repository: **[Selenium-Modules](https://github.com/Lifailon/Selenium-Modules)**

Module: **[Get-Translate](https://github.com/Lifailon/Selenium-Modules/blob/rsa/Modules/Get-Translation/Get-Translation.psm1)**
