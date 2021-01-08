################Fedora Ass 6 Deploy

#instalation and other things
dnf install openldap openldap-clients openldap-servers  -y
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
wget http://users.cis.fiu.edu/~ggome002/files/dleal010.csv

#Configuring Firewall
firewall-cmd --add-service=ssh
firewall-cmd --zone="public" --add-forward-port=port=139:proto=tcp:toport=389

#Configuring LDAP
sleep 5
systemctl start slapd
systemctl enable slapd

firewall-cmd --add-service=slapd

#Some schemas that you need to import, they are basically talbes, there is another one you need to add here. He pointed out
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f /etc/openldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f /etc/openldap/schema/nis.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f /etc/openldap/schema/inetorgperson.ldif

cat << EOF >> /root/new.ldif
dn: olcDatabase={2}mdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: dc=cts4348,dc=fiu,dc=edu

dn: olcDatabase={2}mdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: cn=admin,dc=cts4348,dc=fiu,dc=edu

dn: olcDatabase={2}mdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: {SSHA}qftvPkJ2OFB6yd5oezZQIsIwU3B7SpRn

dn: cn=config
changetype: modify
replace: olcLogLevel
olcLogLevel: -1

dn: olcDatabase={1}monitor,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" read by dn.base="cn=admin,dc=cts4348,dc=fiu,dc=edu" read by * none

EOF

ldapmodify -Y EXTERNAL  -H ldapi:/// -f /root/new.ldif

#adding domains and groups
ldapadd -x -w 5439236 -D cn=admin,dc=cts4348,dc=fiu,dc=edu <<FFF
dn: dc=cts4348,dc=fiu,dc=edu
dc: cts4348
objectClass: top
objectClass: domain

dn: ou=person,dc=cts4348,dc=fiu,dc=edu
ou: person
objectClass: top
objectClass: organizationalUnit

dn: ou=groups,dc=cts4348,dc=fiu,dc=edu
ou: groups
objectClass: top
objectClass: organizationalUnit
FFF

#Adding the groups
ldapadd -x -w 5439236 -D cn=admin,dc=cts4348,dc=fiu,dc=edu<<EOF
dn: cn=gold,ou=groups,dc=cts4348,dc=fiu,dc=edu
objectClass: top
objectClass: posixGroup
gidNumber: 32

dn: cn=silver,ou=groups,dc=cts4348,dc=fiu,dc=edu
objectClass: top
objectClass: posixGroup
gidNumber: 33

dn: cn=bronze,ou=groups,dc=cts4348,dc=fiu,dc=edu
objectClass: top
objectClass: posixGroup
gidNumber: 34
EOF

#adding Athletes
uid=( $(grep olympic /root/dleal010.csv | cut -d, -f1) )
cn=( $(grep olympic /root/dleal010.csv | cut -d, -f2,3) )
sn=( $(grep olympic /root/dleal010.csv | cut -d, -f3) )
description=( $(grep olympic /root/dleal010.csv | cut -d, -f8) )
title=( $(grep olympic /root/dleal010.csv | cut -d, -f6) )

i=0
while [ $i -lt 502 ]
do
cat <<EOF >> /root/athletes
dn: uid=${uid[$i]},ou=person,dc=cts4348,dc=fiu,dc=edu
objectClass: person
objectClass: top
objectClass: inetorgperson
uid: ${uid[$i]}
cn: ${cn[$i]}
sn: ${sn[$i]}
mobile: 7865432109
description: ${description[$i]}
postalcode: 00000
title: ${title[$i]}


EOF

i=$(( $i + 1))
done

ldapadd -x -w 5439236 -D cn=admin,dc=cts4348,dc=fiu,dc=edu < /root/athletes

#adding athletes to the medal groups
gold=( $(grep paralympic /root/dleal010.csv | grep gold | cut -d, -f1) )
silver=( $(grep paralympic /root/dleal010.csv | grep silver | cut -d, -f1) )
bronze=( $(grep paralympic /root/dleal010.csv | grep bronze | cut -d, -f1) )

#gold
i=0
while [ $i -lt 164 ]
do
cat <<EOF >> /root/gold
dn: cn=gold,ou=groups,dc=cts4348,dc=fiu,dc=edu
changeType: modify
add: memberUid
memberUid: ${gold[$i]}

EOF

i=$(( $i + 1 ))
done

#silver
i=0
while [ $i -lt 173 ]
do
cat <<EOF >> /root/silver
dn: cn=silver,ou=groups,dc=cts4348,dc=fiu,dc=edu
changeType: modify
add: memberUid
memberUid: ${silver[$i]}

EOF

i=$(( $i + 1 ))
done

#bronze
i=0
while [ $i -lt 162 ]
do
cat <<EOF >> /root/bronze
dn: cn=bronze,ou=groups,dc=cts4348,dc=fiu,dc=edu
changeType: modify
add: memberUid
memberUid: ${bronze[$i]}

EOF

i=$(( $i + 1 ))
done

ldapadd -x -w 5439236 -D cn=admin,dc=cts4348,dc=fiu,dc=edu < /root/gold
ldapadd -x -w 5439236 -D cn=admin,dc=cts4348,dc=fiu,dc=edu < /root/silver
ldapadd -x -w 5439236 -D cn=admin,dc=cts4348,dc=fiu,dc=edu < /root/bronze

rm -f /root/new.ldif
rm -f /root/athletes
rm -f /root/gold
rm -f /root/silver
rm -f /root/bronze