# dynhost-ovh
A simple (cron) script to update DynHost on OVH hosting

# Prerequisites
This script works with two linux commands : curl and dig.
If you do not have the dig you must install it from the package "dnsutils" :
```sh
sudo apt-get update
sudo apt-get install dnsutils
```

# How to use
1. Download the dynhost.sh script and put it in the folder /etc/cron.hourly (to check every hour)
2. Add execution permissions to file : chmod +x dynhost.sh
3. Modify the script with variables : HOST, LOGIN, PASSWORD

# How it works
1. The command dig is used to retrieve the IP address of your domain name.
2. The command curl (with the website ifconfig.co) is used to retrieve the current public IP address of your machine.
3. The two IPs are compared and if necessary a curl command to OVH is used to update your DynHost with your current public IP address.

