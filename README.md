# EyesOfNetwork-vuln-checker
Unauthentified CVEs checker for EyesOfNetwork server

Usage :
```
./script.sh https://192.168.0.5
```
All payloads (SQLi) are proudly neutralised.

You must have curl installed (and that's all).

# Tested on eon 5.3.x / 5.2.x / 5.1.x / 5.0.x

```

                 ,*-.
                 |  |
             ,.  |  |
             | |_|  | ,.
             `---.  |_| |
                 |  .--`
                 |  |
                 |  |

          Don't be a looser

Check your EyesOfNetwork with this identifier

      Unauthentified CVEs Checker

    Entry points checker from hell

           By ArianeBlow

[i] EyesOfNetwork version Identified as eonweb-5.3
[-] More check points needed ... wait ...
[+] Cookie parameter is vulnerable to SQLi ! CVE-2020-9465
[i] EonApi Version Identified as eonapi-2.4.2
[+] Oops ... https://192.168.0.30 is vulnerable to SQL Injection in eonapi (CVE-2020-8657 - CVE-2020-8656) & CVE-2021-27514 & CVE-2021-33525 & CVE-2020-8654
[+] sessid COOKIE is vulnerable to brut-force attack ! CVE-2021-27514

```

