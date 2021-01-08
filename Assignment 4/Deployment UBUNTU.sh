#UBUNTU Assginment 4 Deployment Script 5439236

curl http://users.cis.fiu.edu/~ggome002/files/dleal010.csv >> /root/dleal010.csv
  
#Install things you're gonna need and disable anything that's gonna stop you

apt-get install epel-release -y
apt-get install lighttpd -y
apt-get install apache2 -y
apt-get install nginx -y
apt-get install net-tools -y

systemctl stop apparmor
systemctl disable apparmor

#sudo apt-get install selinux-basics selinux-policy-default auditd -y
#sudo selinux-activate
 
#setenforce 0
#vi /etc/selinux/config

#set selinux to permisive
#setenforce 0
#vi /etc/selinux/config

#changing the ports that the web servers run on
#lighttpd: 8136 apache2: 8236 nginx: 8336
<<OldWay
vi /etc/lighttpd/lighttpd.conf 
vi /etc/apache2/conf/apache2.conf
vi /etc/nginx/nginx.conf
OldWay

sed -i 's/80/8163/g' /etc/lighttpd/lighttpd.conf
sed -i 's/80/8263/g' /etc/apache2/ports.conf
sed -i 's/80/8363/g' /etc/nginx/sites-enabled/default

#Firewall stuff
<<MoreOld
firewall-cmd --add-service=http
firewall-cmd --add-port=8136/tcp
firewall-cmd --add-port=8236/tcp
firewall-cmd --add-port=8336/tcp
MoreOld

ufw enable
ufw allow 8136/tcp
ufw allow 8236/tcp
ufw allow 8336/tcp

#Start Servers
systemctl restart lighttpd
systemctl restart apache2
systemctl restart nginx

systemctl enable lighttpd
systemctl enable apache2
systemctl enable nginx

#is there anything else I should be doing? This is the only thing I'm not too sure about

#Making and filling all directories and web pages
medals=( $(cut -d, -f9 /root/dleal010.csv | sort -u) )
sports=( $(cut -d, -f8 /root/dleal010.csv | sort -u) )
permis=( $(cut -d, -f11 /root/dleal010.csv | sort -u) )

for m in ${medals[@]}
do

        mkdir /var/www/lighttpd/$m
        touch /var/www/lighttpd/$m/index.html
        grep $m /root/dleal010.csv >> /var/www/lighttpd/$m/index.html

done

for s in ${sports[@]}
do

        mkdir /var/www/html/$s
        touch  /var/www/html/$s/index.html
        grep $s /root/dleal010.csv >> /var/www/html/$s/index.html

done

for p in ${permis[@]}
do

        mkdir /usr/share/nginx/html/$p
        touch /usr/share/nginx/html/$p/index.html
        grep $p /root/dleal010.csv >> /usr/share/nginx/html/$p/index.html

done

