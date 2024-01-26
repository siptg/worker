#!/usr/bin/env bash

TRUSTED_IPS="/config/fail2ban/fw.txt"
TRUSTED_IPS_URL="https://files.sip.tg/fw.txt"
MAX_AGE=600

update_trusted_ips() {
    CURRENT_TIME=$(date +%s)
    if [ ! -f "$TRUSTED_IPS" ] || [ $(($(stat -c %Y "$TRUSTED_IPS") + MAX_AGE)) -lt $CURRENT_TIME ]; then
        if wget -O "$TRUSTED_IPS.tmp" "$TRUSTED_IPS_URL"; then
            mv "$TRUSTED_IPS.tmp" "$TRUSTED_IPS"
        else
            rm -f "$TRUSTED_IPS.tmp"
            [ -f "$TRUSTED_IPS" ] && touch "$TRUSTED_IPS"
        fi
    fi
}

is_trusted_ip() {
    IP_TO_CHECK=$1
    while read -r SUBNET; do
        if [[ $SUBNET = \#* ]]; then
            continue
        fi
        NETMASK=${SUBNET#*/}
        NETWORK1=$(ipcalc -n "$IP_TO_CHECK/$NETMASK" | cut -d'=' -f2)
        NETWORK2=$(ipcalc -n "$SUBNET" | cut -d'=' -f2)
        if [ "$NETWORK1" = "$NETWORK2" ]; then
            return 0
        fi
    done < "$TRUSTED_IPS"
    return 1
}

update_trusted_ips
is_trusted_ip "$1"
