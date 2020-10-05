#!/bin/sh
! ping -q -c 1 -W 1 8.8.8.8 > /dev/null &&
    echo -e "\nNo internet connectivity detected" &&
    echo -e "Connect to a network and try again" &&
    echo -e "Aborting installer...\n" &&
    exit 0

if [ "$*" ]; then
    echo
    curl -O --user "zkkm@pm.me:$1" "https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/arch.sh" || curl -O --user "zkkm@pm.me:$1" "https://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/arch.sh"
else
    read -p "Enter installer password: " password
    echo
    curl -O --user "zkkm@pm.me:$password" "https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/arch.sh" || curl -O --user "zkkm@pm.me:$password" "https://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/arch.sh"
fi

echo

while grep -q "Username or password was incorrect" arch.sh ; do
    echo -e "\nIncorrect password, try again"
    read -p "Enter installer password: " password
    echo
    curl -O --user "zkkm@pm.me:$password" "https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/arch.sh" || curl -O --user "zkkm@pm.me:$password" "https://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/arch.sh"
done

[ "$2" ] &&
    chmod +x arch.sh &&
    ./arch.sh template
[ -z "$2" ] &&
    sh arch.sh
