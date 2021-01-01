#!/bin/bash

cd /var/www/html

echo $DOCKER_HOST_OSTYPE | grep -i Linux >/dev/null 2>/dev/null

if  [ $? -eq 0 ];
then
   echo "Adding host.docker.internal to /etc/hosts"
   /sbin/ip route | awk '/default/ { print $3 }' > /tmp/host_ip.txt
   HOST_IP=$( cat /tmp/host_ip.txt )
   echo "$HOST_IP host.docker.internal" | sudo tee -a /etc/hosts
else
    echo "host.docker.internal already defined"
fi

sudo service apache2 start

tail -f /dev/null
