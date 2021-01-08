###############gender.sh

#Adding the groups
ldapadd -x -w 5439236 -D cn=admin,dc=cts4348,dc=fiu,dc=edu<<EOF
dn: cn=male,ou=groups,dc=cts4348,dc=fiu,dc=edu
objectClass: top
objectClass: posixGroup
gidNumber: 35

dn: cn=female,ou=groups,dc=cts4348,dc=fiu,dc=edu
objectClass: top
objectClass: posixGroup
gidNumber: 36

EOF

#adding athletes
male=( $(grep paralympic /root/dleal010.csv | grep ,m, | cut -d, -f1) )
female=( $(grep paralympic /root/dleal010.csv | grep ,f, | cut -d, -f1) )

#male
i=0
while [ $i -lt 204 ]
do
cat <<EOF >> /root/male
dn: cn=male,ou=groups,dc=cts4348,dc=fiu,dc=edu
changeType: modify
add: memberUid
memberUid: ${male[$i]}

EOF

i=$(( $i + 1 ))
done

#female
i=0
while [ $i -lt 298 ]
do
cat <<EOF >> /root/female
dn: cn=female,ou=groups,dc=cts4348,dc=fiu,dc=edu
changeType: modify
add: memberUid
memberUid: ${female[$i]}

EOF

i=$(( $i + 1 ))
done 

ldapadd -x -w 5439236 -D cn=admin,dc=cts4348,dc=fiu,dc=edu < /root/male
ldapadd -x -w 5439236 -D cn=admin,dc=cts4348,dc=fiu,dc=edu < /root/female

rm -f /root/male
rm -f /root/female