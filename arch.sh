#!/bin/bash
# Detect network connectivity
if ! ping -qc1 -W3 8.8.8.8 > /dev/null; then
    echo -e '\n\t\e[31mNo internet connection detected, run \e[1;35mnmtui\e[0m\e[31m or use \e[1;35miwd\e[0m\e[31m in the terminal if connecting through wifi\e[0m\n'
    exit 1
fi

# Function to list all script options
LIST_SCRIPTS() { unset SCRIPT_SELECTION CUSTOM_SCRIPT
    echo -e '\n\e[1;36mSelect a script to run\e[0m'
    echo -e '\t1) Arch Installer'
    echo -e '\t2) Air-gapped Crypto Wallet Generator'
    echo -e '\t3) Nextcloud Server Installer'
    echo -e '\t4) Live USB Rescue'
    echo -e '\t5) Custom script (manually enter a script filename)'
        until [[ "$SCRIPT_SELECTION" = [1-5] ]]; do
            read -n1 -p '> ' SCRIPT_SELECTION
            [[ "$SCRIPT_SELECTION" = [1-5] ]] || echo -e '\n\n\e[1;31mInvalid selection, type an option from 1 to 5\e[0m'
        done ; echo
    if [ "$SCRIPT_SELECTION" = "5" ]; then
        until [ "$CUSTOM_SCRIPT" ]; do
            read -p $'\n\e[1;36mEnter a filename\e[0m\n> ' CUSTOM_SCRIPT
            [ "$CUSTOM_SCRIPT" ] || echo -e '\n\e[1;31mField cannot be empty, try again\e[0m'
        done
        SCRIPT="$(sed 's/\.sh$//' <<< "$CUSTOM_SCRIPT")"'.sh'
    elif [ "$SCRIPT_SELECTION" = "1" ]; then SCRIPT='arch.sh'
    elif [ "$SCRIPT_SELECTION" = "2" ]; then SCRIPT='airgap.sh'
    elif [ "$SCRIPT_SELECTION" = "3" ]; then SCRIPT='nextcloud.sh'
    elif [ "$SCRIPT_SELECTION" = "4" ]; then SCRIPT='rescue.sh'
    fi
}

# Detect script choice and prompt for webdav password
if [ "$*" ]; then
    # Assign "$1" as script name
    if grep -q "a[^ ]*h" <<< "$1"; then SCRIPT='arch.sh'
    elif grep -q "a[^ ]*p" <<< "$1"; then SCRIPT='airgap.sh'
    elif grep -q "n[^ ]*d\|nx" <<< "$1"; then SCRIPT='nextcloud.sh'
    elif grep -q "u[^ ]*b\|r[^ ]*e" <<< "$1"; then SCRIPT='rescue.sh'
    else LIST_SCRIPTS
    fi
    # Assign "$2" as password if present
    if [ "$2" ]; then
        PASSWORD="$2"
    else
        read -rp $'\n\e[1;36mEnter installer password: \e[0m' PASSWORD
    fi
else
    LIST_SCRIPTS
    read -rp $'\n\e[1;36mEnter installer password: \e[0m' PASSWORD
fi

# Download script from webdav server
while :; do echo
    curl -sO -u "scripts:$PASSWORD" "https://nx.daskap.io/remote.php/dav/files/scripts/$SCRIPT"
    if ! [ -f "$SCRIPT" ] && ! grep -q '#!/bin/bash' "$SCRIPT"; then
        curl -sO -u "scripts:$PASSWORD" "https://cloud.daskap.io/remote.php/dav/files/scripts/$SCRIPT"
    fi
    if [ -f "$SCRIPT" ] && grep -q '#!/bin/bash' "$SCRIPT"; then
        unset PASSWORD
        sh "$SCRIPT"
    elif [ -f "$SCRIPT" ] && ! grep -q '#!/bin/bash' "$SCRIPT"; then
        echo -e '\e[31mInvalid custom script filename, make another selection or try again\e[0m'
        LIST_SCRIPTS
    else 
        echo -e '\t\e[1;31mIncorrect password, try again\e[0m'
        read -rp $'\n\e[1;36mEnter installer password: \e[0m' PASSWORD
    fi
done
