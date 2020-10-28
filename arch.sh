#!/bin/sh

if [ "$*" ]; then
    if echo "$1" | grep -q "a[^ ]*h"; then
        SCRIPT='arch.sh'
    elif echo "$1" | grep -q "n[^ ]*d\|nx"; then
        SCRIPT='nx.sh'
    elif echo "$1" | grep -q "u[^ ]*b\|r[^ ]*r\|r[^ ]*y"; then
        SCRIPT='recovery.sh'
    else
        echo -e "\n\e[1;36mSelect a script to run\e[0m"
        echo -e "\t1) Arch Installer"
        echo -e "\t2) Nextcloud Server Installer"
        echo -e "\t3) Live USB Recovery"
            until [[ "$SCRIPT" = [123] ]]; do
                read -n1 -p '> ' SCRIPT
                    [[ "$SCRIPT" = [123] ]] || echo -e "\n\n\e[1;31mInvalid selection, type an option from 1 to 3\e[0m"
            done ; echo
        [ "$SCRIPT" = 1 ] && SCRIPT='arch.sh'
        [ "$SCRIPT" = 2 ] && SCRIPT='nx.sh'
        [ "$SCRIPT" = 3 ] && SCRIPT='recovery.sh'
    fi
    echo
    curl -O --user "zkkm@pm.me:$2" "https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/$SCRIPT" || curl -O --user "zkkm@pm.me:$2" "https://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/$SCRIPT"
else
    echo -e "\n\e[1;36mSelect a script to run\e[0m"
        echo -e "\t1) Arch Installer"
        echo -e "\t2) Nextcloud Server Installer"
        echo -e "\t3) Live USB Recovery"
            until [[ "$SCRIPT" = [123] ]]; do
                read -n1 -p '> ' SCRIPT
                    [[ "$SCRIPT" != [123] ]] && echo -e "\n\n\e[1;31mInvalid selection, type an option from 1 to 3\e[0m"
            done
        [ "$SCRIPT" = 1 ] && SCRIPT='arch.sh'
        [ "$SCRIPT" = 2 ] && SCRIPT='nx.sh'
        [ "$SCRIPT" = 3 ] && SCRIPT='recovery.sh'
    read -rp $'\n\n\e[1;36mEnter installer password: \e[0m' PASSWORD
    echo    
    curl -O --user "zkkm@pm.me:$PASSWORD" "https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/$SCRIPT" || curl -O --user "zkkm@pm.me:$PASSWORD" "https://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/$SCRIPT"
fi

while grep -q "Username or password was incorrect" $SCRIPT ; do
    echo -e "\n\e[1;31mIncorrect password, try again\e[0m"
    read -rp $'\n\e[1;36mEnter installer password: \e[0m' PASSWORD
    echo
    curl -O --user "zkkm@pm.me:$PASSWORD" "https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/$SCRIPT" || curl -O --user "zkkm@pm.me:$PASSWORD" "https://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/$SCRIPT"
done

sh $SCRIPT "$3"
