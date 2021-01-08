######Assignment 5 Bind Server CentOS

#Prep and other things
yum install bind bind-utils net-tools
wget http://users.cis.fiu.edu/~ggome002/files/dleal010.csv
sport=( $(cut -d, -f8 /root/dleal010.csv | sort -u) )

#ACL
#There is some instructions you have to follow on this link: https://www.digitalocean.com/community/tutorials/how-to-configure-bind-as-a-private-network-dns-server-on-centos-7

#Making the Zones? In file /etc/named/dleal010.conf
touch /etc/named/dleal010.conf
#you need to add the following to the file:
<<tso
zone "168.192.in-addr.arp" {
	type master;
	file "/etc/named/zones/db.168.192.in-addr.arpa";
};
tso

for s in ${sport[@]}
do
	cat zoneexample.txt >> /etc/named/dleal010.conf
    sed -i "s/SPORT/$s/g" /etc/named/dleal010.conf
done

#Making the Domain Names