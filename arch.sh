#!/bin/sh

if [ "$*" ]; then
    if echo "$1" | grep -q "a[^ ]*h"; then
        script='arch.sh'
    elif echo "$1" | grep -q "n[^ ]*d\|nx"; then
        script='nx.sh'
    elif echo "$1" | grep -q "u[^ ]*b\|r[^ ]*r\|r[^ ]*y"; then
        script='liveusbrecovery.sh'
    else
        echo -e "\n\e[1;36mSelect a script to run\e[0m"
        echo -e "\t1) Arch Installer"
        echo -e "\t2) Nextcloud Server Installer"
        echo -e "\t3) Live USB Recovery"
            until [[ "$scriptoption" = [123] ]]; do
                read -n1 -p '> ' scriptoption
                    [[ "$scriptoption" != [123] ]] && echo -e "\n\n\e[1;31mInvalid selection, type an option from 1 to 3\e[0m"
            done ; echo
        [ "$scriptoption" = 1 ] && script='arch.sh'
        [ "$scriptoption" = 2 ] && script='nx.sh'
        [ "$scriptoption" = 3 ] && script='liveusbrecovery.sh'
    fi
    echo
    curl -O --user "zkkm@pm.me:$2" "https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/$script" || curl -O --user "zkkm@pm.me:$2" "https://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/$script"
else
    echo -e "\n\e[1;36mSelect a script to run\e[0m"
        echo -e "\t1) Arch Installer"
        echo -e "\t2) Nextcloud Server Installer"
        echo -e "\t3) Live USB Recovery"
            until [[ "$scriptoption" = [123] ]]; do
                read -n1 -p '> ' scriptoption
                    [[ "$scriptoption" != [123] ]] && echo -e "\n\n\e[1;31mInvalid selection, type an option from 1 to 3\e[0m"
            done
        [ "$scriptoption" = 1 ] && script='arch.sh'
        [ "$scriptoption" = 2 ] && script='nx.sh'
        [ "$scriptoption" = 3 ] && script='liveusbrecovery.sh'
    read -rp $'\n\n\e[1;36mEnter installer password: \e[0m' password
    echo    
    curl -O --user "zkkm@pm.me:$password" "https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/$script" || curl -O --user "zkkm@pm.me:$password" "https://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/$script"
fi

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
