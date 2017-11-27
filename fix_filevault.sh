#!/bin/bash
#
add_user_filevault() {
echo -e "\n"
read -p "Please provide user to add to FileVault encryption: " username
ls -la /Users/ | grep -qi $username
RES=$?
if [ ! -z $username ] && [ $RES -eq 0 ]; then
	echo -e "\nTo be able to add new user account ($username) to FileVault encryption,"
	echo -e "you'll need to provide the password of a previously added administrator account"
	echo -e "\t\tOR\nprovide a valid recovery key!\n"
	fdesetup add -usertoadd $username
	fdesetup list | grep -qi $username
	RES=$?
	if [ $RES -eq 0 ]; then
		echo -e "\nUser ($username) was successfully added to FileVault encryption!\n"
	else
		echo -e "\nSomething went wrong during the FileVault process handling: "
		echo -e "User ($username) could not be found in FileVault encryption!\n"
	fi
else
	clear
	echo -e "\nYou did not specify a valid user account, aborting script now!\n"
fi
}

### MAIN function
echo -e "\n"
fdesetup list
echo -e "\n"
while true; do
        read -p "Is there any \"admin(istrator)\" user enabled (FileVault)? " yn
        case $yn in
                [Yy]* ) add_user_filevault; exit 0;;
                [Nn]* ) exit 1;;
                * ) clear; echo -e "\nPlease answer with \"yes\" or \"no\!\n";;
        esac
done
