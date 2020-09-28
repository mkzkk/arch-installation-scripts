#!/bin/sh
! ping -q -c 1 -W 1 8.8.8.8 > /dev/null &&
    echo -e "\nNo internet connectivity detected\nConnect to a network and try again\nAborting installer...\n" &&
    exit 0

[ "$1" ] &&
    echo &&
    curl -O --user "zkkm@pm.me:$1" "https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/nx.sh"
[ -z "$1" ] &&
    read -p "Enter installer password: " password &&
    echo &&
    curl -O --user "zkkm@pm.me:$password" "https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/nx.sh"

echo
    
while grep -q "Username or password was incorrect" nx.sh ; do
    echo -e "\nIncorrect password, try again"
    read -p "Enter installer password: " password
    echo
    curl -O --user "zkkm@pm.me:$password" "https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/nx.sh"
done

sh nx.sh
