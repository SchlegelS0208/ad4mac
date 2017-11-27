#!/bin/bash
### script to remove given host from W2k3 domain (AD)
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
	echo "Trying to remove given host from old Active Directory (2003) Domain ..."
	dsconfigad -force -remove -username $username -password "$password"
else
	dsconfigad -show | grep -qi ".${newdomain}"
	RES=$?
	if [ $RES -eq 0 ]; then
	        echo "Host ($(hostname -s)) already joined to Domain \"$newdomain\"!"
		echo "Nothing to do, aborting script now ..."
		exit
	else
		echo "Host ($(hostname -s)) is NOT joined to any Win2k AD Domain!"
		echo "Please use \"adjoin_osx.sh\" to join given host to new Active Directory (2012) Domain!"
	fi
fi
