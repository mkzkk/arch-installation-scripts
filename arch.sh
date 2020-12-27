#!/bin/sh

if [ "$*" ]; then
    if grep -q "a[^ ]*h" <<< "$1"; then
        SCRIPT='arch.sh'
    elif grep -q "a[^ ]*p" <<< "$1"; then
        SCRIPT='airgap.sh'
    elif grep -q "n[^ ]*d\|nx" <<< "$1"; then
        SCRIPT='nx.sh'
    elif grep -q "u[^ ]*b\|r[^ ]*e" <<< "$1"; then
        SCRIPT='rescue.sh'
    else
        echo -e "\n\e[1;36mSelect a script to run\e[0m"
        echo -e "\t1) Arch Installer"
        echo -e "\t2) Air-gapped Crypto Wallet Generator"
        echo -e "\t3) Nextcloud Server Installer"
        echo -e "\t4) USB Rescue"
            until [[ "$SCRIPT" = [1-4] ]]; do
                read -n1 -p '> ' SCRIPT
                    [[ "$SCRIPT" = [1-4] ]] || echo -e "\n\n\e[1;31mInvalid selection, type an option from 1 to 3\e[0m"
            done ; echo
        [ "$SCRIPT" = 1 ] && SCRIPT='arch.sh'
        [ "$SCRIPT" = 2 ] && SCRIPT='airgap.sh'
        [ "$SCRIPT" = 3 ] && SCRIPT='nx.sh'
        [ "$SCRIPT" = 4 ] && SCRIPT='rescue.sh'
    fi
    if [ "$2" ]; then
        PASSWORD="$2"
    else
        read -rp $'\n\e[1;36mEnter installer password: \e[0m' PASSWORD
    fi
else
        echo -e "\n\e[1;36mSelect a script to run\e[0m"
        echo -e "\t1) Arch Installer"
        echo -e "\t2) Air-gapped Crypto Wallet Generator"
        echo -e "\t3) Nextcloud Server Installer"
        echo -e "\t4) USB Rescue"
            until [[ "$SCRIPT" = [1-4] ]]; do
                read -n1 -p '> ' SCRIPT
                    [[ "$SCRIPT" = [1-4] ]] || echo -e "\n\n\e[1;31mInvalid selection, type an option from 1 to 3\e[0m"
            done ; echo
        [ "$SCRIPT" = 1 ] && SCRIPT='arch.sh'
        [ "$SCRIPT" = 2 ] && SCRIPT='airgap.sh'
        [ "$SCRIPT" = 3 ] && SCRIPT='nx.sh'
        [ "$SCRIPT" = 4 ] && SCRIPT='rescue.sh'
    read -rp $'\n\n\e[1;36mEnter installer password: \e[0m' PASSWORD
fi
    echo
    curl -sO -u "zkkm@pm.me:$PASSWORD" "https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/$SCRIPT" || curl -sO -u "zkkm@pm.me:$PASSWORD" "https://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/$SCRIPT"

while ! grep -q '#!/bin/bash' $SCRIPT; do
    echo -e "\t\e[1;31mIncorrect password, try again\e[0m"
    read -rp $'\n\e[1;36mEnter installer password: \e[0m' PASSWORD
    echo
    curl -sO -u "zkkm@pm.me:$PASSWORD" "https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/$SCRIPT" || curl -sO -u "zkkm@pm.me:$PASSWORD" "https://us.cloudamo.com/remote.php/dav/files/zkkm@pm.me/$SCRIPT"
done

sh $SCRIPT "$3"
