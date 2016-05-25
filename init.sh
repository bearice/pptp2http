#!/bin/bash
set +x 

[ "x$1$2$3" = "x" ] && {
    echo "Usage: $0 <server> <user> <pass>"
    exit 1
}

PPTP_SERVER=$1
PPTP_USER=$2
PPTP_PASS=$3

umask 022
mkdir -p /data 

echo '{}' | jq \
    --arg server "$PPTP_SERVER" \
    --arg user "$PPTP_USER" \
    --arg id "$(hostname)" \
    --arg local "$(hostname -i)" \
    '.status="INITIAL"|.server=$server|.user=$user|.id=$id|.local=$local' > /data/$(hostname).json

pptpsetup --create pptp --server "$PPTP_SERVER" --username "$PPTP_USER" --password "$PPTP_PASS"
exec pppd call pptp usepeerdns persist nodetach debug

