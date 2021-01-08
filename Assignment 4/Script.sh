   # Assignment 4 Scrip.sh

#1 remove old firewall ports
firewall-cmd --remove-port=3136/tcp
firewall-cmd --remove-port=3236/tcp
firewall-cmd --remove-port=3336/tcp

#2 add new firewall ports
firewall-cmd --add-port=3163/tcp
firewall-cmd --add-port=3263/tcp
firewall-cmd --add-port=3363/tcp

#3 change the ports that the web servers use
sed -i 's/8136/8163/g' /etc/lighttpd/lighttpd.conf
sed -i 's/8236/8263/g' /etc/httpd/conf/httpd.conf
sed -i 's/8336/8363/g' /etc/nginx/nginx.conf

#4 restart services
systemctl restart lighttpd
systemctl restart httpd
systemctl restart nginx

#5 Remove all the old Dir
medals=( $(cut -d, -f9 /root/dleal010.csv | sort -u) )
sports=( $(cut -d, -f8 /root/dleal010.csv | sort -u) )
permis=( $(cut -d, -f11 /root/dleal010.csv | sort -u) )

for m in ${medals[@]}
do

        yes | rm -rId /var/www/lighttpd/$m

done

for s in ${sports[@]}
do

        yes | rm -rId /var/www/html/$s
        
done

for p in ${permis[@]}
do

        yes | rm -rId /usr/share/nginx/html/$p
        
done

#6 & 7 make new Dir and fill them

for p in ${permis[@]}
do

        mkdir /var/www/lighttpd/$p
        touch /var/www/lighttpd/$p/index.html
        grep $p /root/dleal010.csv >> /var/www/lighttpd/$p/index.html

done

for m in ${medals[@]}
do

        mkdir /var/www/html/$m
        touch /var/www/html/$m/index.html
        grep $m /root/dleal010.csv >> /var/www/html/$m/index.html

done

for s in ${sports[@]}
do

        mkdir /usr/share/nginx/html/$s
        touch /usr/share/nginx/html/$s/index.html
        grep $s /root/dleal010.csv >> /usr/share/nginx/html/$s/index.html

done

