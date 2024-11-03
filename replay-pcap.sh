#!/bin/bash

usage() {
    echo "Usage: $0 <dest_address> <pcap_file> [extra args for tcpreplay-edit...]"
    echo
    echo "    Replay the packets in <pcap_file> to <dest_address>."
    exit 1
}

if [ $# -lt 2 ] ; then
    usage
else
    dest_addr=$1
    pcap_path=$2
    shift
    shift
fi

dest_ip4=$(getent hosts ${dest_addr} | awk '{print $1}')

# E.g.: 1.1.1.1 via 1.2.3.4 dev eth0 src 1.2.3.5
route=$(ip route get ${dest_ip4} | head -n1)
gw_iface=$(echo ${route} | awk '{print $5}')
src_ip=$(echo ${route} | awk '{print $7}')
gw_mac=$(ip neigh show dev ${gw_iface} | tail -n1 | awk '{print $3}')
local_mac=$(cat /sys/class/net/${gw_iface}/address)

set -x
tcpreplay-edit  --enet-smac=${local_mac} --enet-dmac=${gw_mac} --srcipmap=0.0.0.0/0:${src_ip} --dstipmap=0.0.0.0/0:${dest_ip4} --fixcsum -i ${gw_iface} $@ ${pcap_path}
