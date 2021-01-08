#Esentials
dnf install mariadb-server
systemctl start mariadb
systemctl enable mariadb

systemctl status mariadb
echo " "
echo "********************************"
echo "Is Mariadb enabled?"
systemctl is-enabled mariadb

echo "5 sec pause"
sleep 5

#Firewall Stuff, 1.5pts
firewall-cmd --add-port=3306/tcp
firewall-cmd --add-port=1433/tcp
firewall-cmd --add-port=27017/tcp
firewall-cmd --add-service=bitcoin
firewall-cmd --add-service=postgresql

firewall-cmd --list-all

echo "5 sec pause"
sleep 5

Making DB, MySQL 1.5pts
mysql -e "CREATE DATABASE dleal010_node072;"
mysql dleal010_node072 -e "CREATE TABLE dleal010_node072_countries (dleal010_countries_name varchar(50));"
mysql dleal010_node072 -e "CREATE TABLE dleal010_node072_sports (dleal010_sports_name varchar(50));"

curl http://users.cis.fiu.edu/~ggome002/files/dleal010.csv > dleal010.csv

sport=( $(grep paralympic dleal010.csv | cut -d, -f8 | sort -u ) )
country=( $(grep paralympic dleal010.csv | cut -d, -f6 | sort -u ) )

for i in ${sport[@]}
do
   mysql dleal010_node072 -e "INSERT INTO dleal010_node072_sports VALUES ('$i');"
   #echo $i
done

for i in ${country[@]}
do
   mysql dleal010_node072 -e "INSERT INTO dleal010_node072_countries VALUES ('$i');"
   #echo $i
done

