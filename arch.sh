#!/bin/sh

if ! ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
    echo -e "\nNo internet connectivity detected\nConnect to a network and try again\nAborting installer...\n"
    exit 0
fi

pass="$1"

if [[ -z "$pass" ]] ; then
    echo ; read -p 'Enter installer password: ' password
    echo
    curl -O --user "zkkm@pm.me:${password}" 'http://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/arch.sh'
else
    echo
    curl -O --user "zkkm@pm.me:${pass}" 'http://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/arch.sh'
fi

echo
while grep -q "Username or password was incorrect" arch.sh ; do
    echo "Incorrect password, try again"
    echo ; read -p 'Enter installer password: ' password
    echo
    curl --user "zkkm@pm.me:${password}" 'http://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/arch.sh'
done

sh arch.sh
