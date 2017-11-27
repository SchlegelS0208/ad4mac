#!/bin/bash
### script to add given host to W2k12 domain (AD)
olddomain="oldtest.corp"
newdomain="test.corp"
windowsdc="mydc.test.corp"
username="adjoin"
password="mySecret"
org_unit="OU=Computers,DC=test,DC=corp"
dsconfigad -show | grep -qi "$olddomain"
RES=$?
if [ $RES -eq 0 ]; then
        echo "Host ($(hostname -s)) is currently joined to Domain \"$olddomain\"!"
        echo "Please use \"unjoin_osx.sh\" to remove given host from old Active Directory (2003) Domain!"
else
	
	dsconfigad -show | grep -qi ".${newdomain}"
	RES=$?
	if [ $RES -eq 0 ]; then
		echo "Host ($(hostname -s)) already joined to Domain \"$newdomain\"!"
		echo "Nothing to do, aborting script now ..."
	else
		echo "Trying to join given host ($(hostname -s)) to new Active Directory (2012) Domain ..."
		dsconfigad -add $newdomain -computer $(hostname -s) -force -username $username -password "$password" -ou "OU=Computers,DC=uptrade,DC=intern" -domain "TEST" -mobile enable -mobileconfirm disable -localhome enable -useuncpath enable -protocol smb -shell "/bin/bash" -uid uidNumber -gid gidNumber -ggid gidNumber -authority enable -preferred "$windowsdc" -groups "Domain-Admins,Domain-Users" -alldomains enable -packetsign allow -packetencrypt allow -namespace domain -passinterval 30
	fi
fi
