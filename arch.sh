#!/bin/sh
pass="$1"

if [[ -z "$pass" ]] ; then
    echo ; read -p 'Enter installer password: ' password
    echo
    curl --user "zkkm@pm.me:${password}" 'http://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/arch.sh' > arch.sh
else
    echo
    curl --user "zkkm@pm.me:${pass}" 'http://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/arch.sh' > arch.sh
fi

echo
while grep -q "Username or password was incorrect" arch.sh ; do
    echo "Incorrect password, try again"
    if [[ -z "$pass" ]] ; then
        echo ; read -p 'Enter installer password: ' password
        echo
        curl --user "zkkm@pm.me:${password}" 'http://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/arch.sh' > arch.sh
    else
        echo
        exit 0
    fi
done
sh arch.sh
echo
exit 0
