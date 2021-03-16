#!/bin/bash

# Detect network connectivity
if ! ping -qc1 -W3 8.8.8.8 > /dev/null; then
    echo -e '\n\t\e[31mNo internet connection detected, run \e[1;35mnmtui\e[0m\e[31m in the terminal if connecting through wifi\e[0m\n'
    exit 1
fi

# Function to list all choices
LIST_SCRIPTS() {
    echo -e '\n\e[1;36mSelect a script to run\e[0m'
    echo -e '\t1) Arch Installer'
    echo -e '\t2) Air-gapped Crypto Wallet Generator'
    echo -e '\t3) Nextcloud Server Installer'
    echo -e '\t4) USB Rescue'
        until [[ "$SCRIPT" = [1-4] ]]; do
            read -n1 -p '> ' SCRIPT
                [[ "$SCRIPT" = [1-4] ]] || echo -e '\n\n\e[1;31mInvalid selection, type an option from 1 to 4\e[0m'
        done ; echo
    if [ "$SCRIPT" = "1" ]; then SCRIPT='arch.sh'
    elif [ "$SCRIPT" = "2" ]; then SCRIPT='airgap.sh'
    elif [ "$SCRIPT" = "3" ]; then SCRIPT='nx.sh'
    elif [ "$SCRIPT" = "4" ]; then SCRIPT='rescue.sh'
    fi
}
# Function to download script from webdav server
DOWNLOAD_SCRIPT() { echo
    curl -sO -u "scripts:$PASSWORD" "http://70.64.30.185:8080/remote.php/dav/files/scripts/$SCRIPT"
    if ! grep -q '#!/bin/bash' $SCRIPT; then
        curl -sO -u "zkkm@pm.me:$PASSWORD" "https://shared02.opsone-cloud.ch/remote.php/dav/files/zkkm@pm.me/$SCRIPT"
    fi
}

# Detect script choice and prompt for webdav password
if [ "$*" ]; then
    # Assign "$1" as script name
    if grep -q "a[^ ]*h" <<< "$1"; then SCRIPT='arch.sh'
    elif grep -q "a[^ ]*p" <<< "$1"; then SCRIPT='airgap.sh'
    elif grep -q "n[^ ]*d\|nx" <<< "$1"; then SCRIPT='nx.sh'
    elif grep -q "u[^ ]*b\|r[^ ]*e" <<< "$1"; then SCRIPT='rescue.sh'
    else LIST_SCRIPTS
    fi
    # Assign "$2" as password if present
    if [ "$2" ]; then PASSWORD="$2"
    else read -rp $'\n\e[1;36mEnter installer password: \e[0m' PASSWORD
    fi
else
    LIST_SCRIPTS
    read -rp $'\n\e[1;36mEnter installer password: \e[0m' PASSWORD
fi

DOWNLOAD_SCRIPT

while ! grep -q '#!/bin/bash' "$SCRIPT"; do
    echo -e '\t\e[1;31mIncorrect password, try again\e[0m'
    read -rp $'\n\e[1;36mEnter installer password: \e[0m' PASSWORD
    DOWNLOAD_SCRIPT
done

sh "$SCRIPT"
