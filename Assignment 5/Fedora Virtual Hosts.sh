########Assignment 5 Fedora Virtual Hosts

#YOU NEED TO COPY AN EXAMPLE CONFIG FILE INTO FEDORA FOR THIS TO WORK, AND TO MAKE SURE THE THAT IT AND THE SED LINES ARE USING THE SAME REPLACEABLE VARIABLE

#get the csv and other preliminary work
wget http://users.cis.fiu.edu/~ggome002/files/dleal010.csv
dnf install httpd -y
dnf intall bind-utils
mkdir /etc/httpd/cts4348.d/
echo IncludeOptional cts4348.d/*.conf >> /etc/httpd/conf/httpd.conf

#config files have to be in /etc/httpd/cts4348.d/
#web pages are in /var/www/cts4348/
mkdir /etc/httpd/cts4348.d/
mkdir /var/www/cts4348/
echo 'IncludeOptional cts4348.d/*.conf' >> /etc/httpd/conf/httpd.conf

country=( $(cut -d, -f6 /root/dleal010.csv | sort -u) )

for c in ${country[@]}
do

	#make configs
	cp /root/example.conf /etc/httpd/cts4348.d/$c.conf
	sed -i "s/COUNT/$c/g" /etc/httpd/cts4348.d/$c.conf
	
	#make pages
	mkdir /var/www/cts4348/$c
	grep $c /root/dleal010.csv | cut -d, -f3,2,5,11 >> /var/www/cts4348/$c/index.html
	
	#adding virtual hosts to hosts so it just works
	echo 127.0.0.1   $c.cts4348.fiu.edu >> /etc/hosts
	
done

