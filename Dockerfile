FROM ubuntu:trusty
MAINTAINER bearice@icybear.net

RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty-backports main restricted" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y pptp-linux squid3 && \
    apt-get install -t trusty-backports jq && \ 
    ln -sf /bin/true /sbin/modprobe && \
    echo "200 squid" >> /etc/iproute2/rt_tables

ADD init.sh /
ADD squid-up.sh /etc/ppp/ip-up.local
ADD squid-down.sh /etc/ppp/ip-down.local
ADD squid.conf.in /etc/ppp

#ENTRYPOINT /init.sh
