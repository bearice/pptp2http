#!/bin/bash
umask 022
exec 1>> /data/$(hostname).log 2>&1
set +x

echo "LINK DOWN"
env

ip rule del from $IPLOCAL lookup squid
ip route flush table squid

jq '.status="DISCONNECTED"' </data/$(hostname).json >/data/.$(hostname).json

mv -f /data/.$(hostname).json /data/$(hostname).json


PID=/var/run/squid3.pid
squid3 -k kill
while [ -f "$PID" ] && kill -0 $(cat $PID)
do 
    echo Waiting squid to exit...
    sleep 1
done



