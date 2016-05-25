#!/bin/bash
umask 022
exec 1>> /data/$(hostname).log 2>&1
set +x

echo "LINK UP"
env

: ${DNS1:=114.114.114.114}
: ${DNS2:=1.2.4.8}

PID=/var/run/squid3.pid
while [ -f "$PID" ] && kill -0 $(cat $PID)
do 
    echo Waiting for last squid to exit...
    sleep 1
done

ip rule add from $IPLOCAL lookup squid
ip route add default dev ppp0 src $IPLOCAL table squid
ip route add $DNS1 dev ppp0
ip route add $DNS2 dev ppp0

HOST_IP=$(hostname -i)
sed \
    -e "s/!HOST_IP!/$HOST_IP/g" \
    -e "s/!DNS_IP!/$DNS1 $DNS2/g" \
    -e "s/!PPP_IP!/$IPLOCAL/g" \
    /etc/ppp/squid.conf.in > /etc/squid3/squid.conf
squid3

jq \
    --arg ext "$(curl -s --interface ppp0 ipinfo.io || echo '{"error":"Fail to get external ip"}')" \
    --arg dns1 "$DNS1" \
    --arg dns2 "$DNS2" \
    --arg ip "$IPLOCAL" \
    '.status="CONNECTED"|.external=($ext|fromjson)|.dns1=$dns1|.dns2=$dns2|.tunnel_ip=$ip' </data/$(hostname).json >/data/.$(hostname).json

mv -f /data/.$(hostname).json /data/$(hostname).json


