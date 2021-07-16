#!/usr/bin/env sh
# Function to verify If IP adress is valid
check_ip () {
  rxV4='([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'
  rxV6='(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))'
  
  if [ "$2" == "V4" ]
  then
    if ! [[ $1 =~ ^$rxV4\.$rxV4\.$rxV4\.$rxV4$ ]]; then
      exit 5
    fi
  elif [ "$2" == "V6"  ]
  then
    if ! [[ $1 =~ ^$rxV6$ ]]; then
      exit 5
    fi
  else
    exit 6
  fi
}
# Account configuration
IP_VERSION="V4"
HOST=DOMAINE_NAME
LOGIN=LOGIN
PASSWORD=PASSWORD

PATH_LOG=/var/log/dynhostovh.log
# Get current IPv4 and corresponding configured
HOST_IP=$(dig +short $HOST A)


CURRENT_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
if [ -z "$CURRENT_IP" ]; then
  CURRENT_IP=`curl -m 5 -4 ifconfig.co 2>/dev/null`
fi
CURRENT_DATETIME=$(date -R)

# # Update dynamic IPv4, if needed
if [ -z "$CURRENT_IP" ] || [ -z "$HOST_IP" ]
then
  echo "[$CURRENT_DATETIME]: No IP retrieved"
else
  check_ip $CURRENT_IP $IP_VERSION
  if [ "$HOST_IP" != "$CURRENT_IP" ]
  then
    RES=$(curl -m 5 -L --location-trusted --user "$LOGIN:$PASSWORD" "https://www.ovh.com/nic/update?system=dyndns&hostname=$HOST&myip=$CURRENT_IP")
    echo "[$CURRENT_DATETIME]: IPv4 has changed - request to OVH DynHost: $RES" >> $PATH_LOG
  fi
fi
