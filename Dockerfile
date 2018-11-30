FROM ubuntu:xenial
MAINTAINER bearice@icybear.net

RUN apt-get update && \
    apt-get install -y jq pptp-linux squid3 curl && \
    ln -sf /bin/true /sbin/modprobe && \
    echo "200 squid" >> /etc/iproute2/rt_tables

ADD init.sh /
ADD squid-up.sh /etc/ppp/ip-up.local
ADD squid-down.sh /etc/ppp/ip-down.local
ADD squid.conf.in /etc/ppp

#ENTRYPOINT /init.sh
