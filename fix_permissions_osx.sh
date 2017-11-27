#!/bin/bash
### repair permissions for given user account
newdomain="test.corp"
userlist=$(dscl . list /Users UniqueID | awk '$2 > 1000 {print $1}')
for user in $userlist; do
	echo "Trying to repair Ownership / Permissions for User: $user"
	dscl . delete /Users/$user
	chown -R $user:"TEST\\$(groups $user | grep -o 'Domain-Users')" /Users/$user
        echo "Adding user $user to the local admin group:"
        admgroup="admin"
        dseditgroup -o edit -a $user -t user $admgroup
done
