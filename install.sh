apt  install hostapd dnsmasq
apt install aircrack-ng
rm -r /opt/WifiMaster/program_files/dnsmasq.conf
mkdir /opt/WifiMaster
mkdir /opt/WifiMaster/Password_Hash
mkdir /opt/WifiMaster/program_files
touch /opt/WifiMaster/program_files/dnsmasq.conf
echo "  Default interface: wlan0 " 
echo "interface=wlan0" >> /opt/WifiMaster/program_files/dnsmasq.conf
echo "dhcp-range=10.0.0.10,10.0.0.100,8h" >> /opt/WifiMaster/program_files/dnsmasq.conf
echo "dhcp-option=3,10.0.0.1" >> /opt/WifiMaster/program_files/dnsmasq.conf
echo "dhcp-option=6,10.0.0.1" >> /opt/WifiMaster/program_files/dnsmasq.conf
echo "cname=*.com, 10.0.0.1" >> /opt/WifiMaster/program_files/dnsmasq.conf
echo "cname=*.co.il, 10.0.0.1" >> /opt/WifiMaster/program_files/dnsmasq.conf
echo "address=/#/10.0.0.1" >> /opt/WifiMaster/program_files/dnsmasq.conf
touch /opt/WifiMaster/program_files/hostapd.conf
echo "make sure reg.py is in this directory!"
mv reg.py /opt/WifiMaster/program_files/
mkdir /opt/WifiMaster/program_files/server/
mkdir /opt/WifiMaster/program_files/Password_Hash/
mkdir /opt/WifiMaster/program_files/server
echo "make sure index.html is in this directory!"
mv index.html /opt/WifiMaster/program_files/server/
