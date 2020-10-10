#!/bin/sh
! ping -q -c 1 -W 1 8.8.8.8 > /dev/null &&
    echo -e "\nNo internet connectivity detected" &&
    echo -e "Connect to a network and try again" &&
    echo -e "Aborting installer...\n" &&
    exit 0

if [ "$*" ]; then
    if echo "$2" | grep 'arch'; then
        script='arch.sh'
    elif echo "$2" | grep 'nx\|nextcloud'; then
        script='nx.sh'
    elif echo "$2" | grep 'usb\|recover'; then
        script='liveusbrecovery.sh'
    else
        echo -e "\n\e[1;36mSelect a script to run\e[0m"
        echo -e "\t1) Arch Installer"
        echo -e "\t2) Nextcloud Server Installer"
        echo -e "\t2) Live USB Recovery"
            until [[ "$scriptoption" = [123] ]]; do
                read -n1 -p '> ' scriptoption
                    [[ "$scriptoption" != [123] ]] && echo -e "\n\n\e[1;31mInvalid selection, type an option from 1 to 3\e[0m"
            done
        [ "$scriptoption" = 1 ] && script='arch.sh'
        [ "$scriptoption" = 2 ] && script='nx.sh'
        [ "$scriptoption" = 3 ] && script='liveusbrecovery.sh'
    fi
    echo
    curl -O --user "zkkm@pm.me:$1" "https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/$script" || curl -O --user "zkkm@pm.me:$1" "https://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/$script"
else
    read -rp $'\n\e[1;36mEnter installer password: \e[0m' password
    echo -e "\n\n\e[1;36mSelect a script to run\e[0m"
        echo -e "\t1) Arch Installer"
        echo -e "\t2) Nextcloud Server Installer"
        echo -e "\t2) Live USB Recovery"
            until [[ "$scriptoption" = [123] ]]; do
                read -n1 -p '> ' scriptoption
                    [[ "$scriptoption" != [12] ]] && echo -e "\n\n\e[1;31mInvalid selection, type an option from 1 to 3\e[0m"
            done
        [ "$scriptoption" = 1 ] && script='arch.sh'
        [ "$scriptoption" = 2 ] && script='nx.sh'
        [ "$scriptoption" = 3 ] && script='liveusbrecovery.sh'
    echo    
    curl -O --user "zkkm@pm.me:$password" "https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/$script" || curl -O --user "zkkm@pm.me:$password" "https://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/$script"
fi

echo

while grep -q "Username or password was incorrect" $script ; do
    echo -e "\n\e[1;31mIncorrect password, try again\e[0m"
    read -rp $'\n\e[1;36mEnter installer password: \e[0m' password
    echo
    curl -O --user "zkkm@pm.me:$password" "https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/$script" || curl -O --user "zkkm@pm.me:$password" "https://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/$script"
done

chmod +x $script

[ "$3" ] &&
    ./$script template

[ -z "$3" ] &&
    ./$script
