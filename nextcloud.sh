#!/bin/sh
if ! ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
    echo -e "\nNo internet connectivity detected\nConnect to a network and try again\nAborting installer...\n"
    exit 0
fi

pass="$1"

if [[ -z "$pass" ]] ; then
    echo ; read -p 'Enter installer password: ' password
    echo
    curl -O --user "zkkm@pm.me:${password}" 'https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/nx.sh'
else
    echo
    curl -O --user "zkkm@pm.me:${pass}" 'https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/nx.sh'
fi

while grep -q "Username or password was incorrect" nx.sh ; do
    echo ; echo "Incorrect password, try again"
    read -p 'Enter installer password: ' password
    echo
    curl -O --user "zkkm@pm.me:${password}" 'https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/nx.sh'
done

sh nx.sh
