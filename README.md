# pptp2http
A Dockerfile to convert PPTP VPNs to HTTP proxy with squid3

## Usage:

before use, you should load kernel modules on docker hosts:

```bash
modprobe ppp_mppe
modprobe ip_nat_pptp #if your docker running a NAT mode network
```

to start instance:

```bash
docker run -d \
  --device /dev/ppp \
  --cap-add=net_admin \
  --name pptp1 \
  -v $HOME/pptp_status:/data \
  pptp2http \
  /init.sh $SERVER $USER $PASSWD
```

the volume $HOME/pptp_status is used to store logs and a json file of connection status, like following:

```json
{
  "status": "CONNECTED",
  "server": "<SERVER_ADDRESS>",
  "user": "<USERNAME>",
  "id": "d9b359c26f71",
  "local": "172.16.250.1",
  "external": {
    "ip": "117.42.199.5",
    "hostname": "No Hostname",
    "city": "Nanchang",
    "region": "Jiangxi Sheng",
    "country": "CN",
    "loc": "28.5500,115.9333",
    "org": "AS4134 No.31,Jin-rong Street"
  },
  "dns1": "202.101.224.69",
  "dns2": "202.101.226.69",
  "tunnel_ip": "12.12.12.50"
}
```
