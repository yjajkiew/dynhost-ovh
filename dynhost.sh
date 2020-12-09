#!/usr/bin/env sh

# Account configuration
HOST=DOMAINE_NAME
LOGIN=LOGIN
PASSWORD=PASSWORD

PATH_LOG=/var/log/dynhostovh.log

# Get current IPv4 and corresponding configured
HOST_IP=$(dig +short $HOST A)
CURRENT_IP=$(curl -m 5 -4 ifconfig.co 2>/dev/null)
if [ -z $CURRENT_IP ]
then
  CURRENT_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
fi

# Update dynamic IPv4, if needed
if [ -z $CURRENT_IP ] || [ -z $HOST_IP ]
then
  echo "No IP retrieved" >> $PATH_LOG
else
  if [ "$HOST_IP" != "$CURRENT_IP" ]
  then
    echo "IP has changed" >> $PATH_LOG
    RES=$(curl -m 5 --user "$LOGIN:$PASSWORD" "https://www.ovh.com/nic/update?system=dyndns&hostname=$HOST&myip=$CURRENT_IP")
    echo "Result request dynHost" >> $PATH_LOG
    echo "$RES" >> $PATH_LOG
  fi
fi
