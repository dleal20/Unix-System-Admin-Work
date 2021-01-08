#Assignment 4 conf.sh

# httpd old line 119: DocumentRoot "/var/www/html"
# httpd old line 131: <Directory "/var/www/html">
#
# nginx old line  42:        root         /usr/share/nginx/html;
# nginx old line  65:        root         /usr/share/nginx/html;

#Changing conf files
sed -i "s|/var/www/html|/usr/share/nginx/html|g" /etc/httpd/conf/httpd.conf
sed -i "s|/usr/share/nginx/html|/var/www/html|g" /etc/nginx/nginx.conf

#Restarting servers
systemctl restart httpd
systemctl restart nginx
