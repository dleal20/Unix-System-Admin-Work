#Assginment 4 Deployment Script

curl http://users.cis.fiu.edu/~ggome002/files/dleal010.csv >> /root/dleal010.csv

#Install things you're gonna need
yum install epel-release -y
yum install lighttpd -y
yum install httpd -y
yum install nginx -y
yum install net-tools -y

#set selinux to permisive
setenforce 0
vi /etc/selinux/config

#changing the ports that the web servers run on
#lighttpd: 8136 httpd: 8236 nginx: 8336
<<OldWay
vi /etc/lighttpd/lighttpd.conf 
vi /etc/httpd/conf/httpd.conf
vi /etc/nginx/nginx.conf
OldWay

sed -i 's/80/8163/g' /etc/lighttpd/lighttpd.conf
sed -i 's/80/8263/g' /etc/httpd/conf/httpd.conf
sed -i 's/80/8363/g' /etc/nginx/nginx.conf

#Start Servers
systemctl start lighttpd
systemctl start httpd
systemctl start nginx

systemctl enable lighttpd
systemctl enable httpd
systemctl enable nginx

#Firewall stuff
firewall-cmd --add-service=http
firewall-cmd --add-port=8136/tcp
firewall-cmd --add-port=8236/tcp
firewall-cmd --add-port=8336/tcp
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

