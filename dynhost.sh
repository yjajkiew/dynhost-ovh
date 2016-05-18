#/bin/sh

#
# CONFIG
#

HOST=DOMAINE_NAME
LOGIN=LOGIN
PASSWORD=PASSWORD

PATH_LOG=/var/log/dynhost

#
# GET IPs
#

HOST_IP=`dig +short $HOST`
CURRENT_IP=`curl ifconfig.co`

#
# LOG
#
echo > $PATH_LOG
echo "Run dyndns" >> $PATH_LOG
date >> $PATH_LOG

echo "Current IP" >> $PATH_LOG
echo "$CURRENT_IP" >> $PATH_LOG
echo "Host IP" >> $PATH_LOG
echo "$HOST_IP" >> $PATH_LOG

#
# DO THE WORK
#
if [ -z $CURRENT_IP ] || [ -z $HOST_IP ]
then
        echo "No IP retrieved" >> $PATH_LOG
else
        if [ "$HOST_IP" != "$CURRENT_IP" ]
        then
                echo "IP has changed" >> $PATH_LOG
                RES=`curl --user "$LOGIN:$PASSWORD" "https://www.ovh.com/nic/update?system=dyndns&hostname=$HOST&myip=$CURRENT_IP"`
                echo "Result request dynHost" >> $PATH_LOG
                echo "$RES" >> $PATH_LOG
        else
                echo "IP has not changed" >> $PATH_LOG
        fi
fi
