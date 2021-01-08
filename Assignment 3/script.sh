mysql dleal010_node070 -e "CREATE TABLE dleal010_node070_athletes (dleal010_athletes_name varchar(50), dleal010_athletes_shell varchar(50), dleal010_athletes_medal varchar(50));"

name=( $( grep olympic dleal010.csv | cut -d, -f2,3 ) )
shell=( $( grep olympic dleal010.csv | cut -d, -f10 ) )
medal=( $( grep olympic dleal010.csv | cut -d, -f9 ) )

for i in ${!name[*]}
do
   #echo ${name[$i]} ${shell[$i]} ${medal[$i]}
   mysql dleal010_node070 -e "INSERT INTO dleal010_node070_athletes (dleal010_athletes_name, dleal010_athletes_shell, dleal010_athletes_medal) VALUES ('${name[$i]}', '${shell[$i]}', '${medal[$i]}' );"
done