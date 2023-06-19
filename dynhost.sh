#!/usr/bin/env sh

# Account configuration
HOST_LIST="HOST1 HOST2 HOST3"
LOGIN=LOGIN
PASSWORD=PASSWORD

PATH_LOG=/var/log/dynhostovh.log

for HOST in $HOST_LIST
do
   # Get current IPv4 and corresponding configured
    HOST_IP=$(dig +short $HOST A)
    CURRENT_IP=$(curl -m 5 -4 ifconfig.co 2>/dev/null)
    if [ -z "$CURRENT_IP" ]
    then
        CURRENT_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
    fi
    CURRENT_DATETIME=$(date -R)

    echo "[$CURRENT_DATETIME]: Checking host $HOST" >> "$PATH_LOG"

    # Update dynamic IPv4, if needed
    if [ -z "$CURRENT_IP" ] || [ -z "$HOST_IP" ]
    then
        echo "[$CURRENT_DATETIME]: No IP retrieved for $HOST" >> "$PATH_LOG"
    else
        echo "[$CURRENT_DATETIME]: Current IP: $CURRENT_IP" >> "$PATH_LOG"
        echo "[$CURRENT_DATETIME]: Host IP: $HOST_IP" >> "$PATH_LOG"
        
        if [ "$HOST_IP" != "$CURRENT_IP" ]
        then
            RES=$(curl -m 5 -L --location-trusted --user "$LOGIN:$PASSWORD" "https://www.ovh.com/nic/update?system=dyndns&hostname=$HOST&myip=$CURRENT_IP")
            echo "[$CURRENT_DATETIME]: IPv4 has changed for $HOST - request to OVH DynHost: $RES" >> "$PATH_LOG"
        else
            echo "[$CURRENT_DATETIME]: IPv4 is up to date for $HOST" >> "$PATH_LOG"
        fi
    fi

    echo "----------------------" >> "$PATH_LOG"
done