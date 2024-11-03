# Replay PCAP
You've captured some packets in a pcap file (e.g., using tcpdump).  Now you
want to replay them to your application. This container/script replays the
pcap. It modifies the src/dst MAC and IP addresses, so that the packets are
valid and delivered to a user-space process.

## Build
Build the Docker image:
```bash
docker build -t replay-pcap .
```

## Usage
Run the container, mounting the pcap you want to replay, specifying the
destination address:
```bash
$ docker run -it --rm replay-pcap                                                
Usage: /replay-pcap.sh <dest_address> <pcap_file> [extra args for tcpreplay-edit...]

    Replay the packets in <pcap_file> to <dest_address>.
$ docker run -it --rm -v PACKETS.PCAP:/out.pcap replay-pcap DESTINATION_ADDRESS /out.pcap -t
+ tcpreplay-edit --enet-smac=02:42:0a:f0:00:04 --enet-dmac=02:42:f4:6c:b0:7b --srcipmap=0.0.0.0/0:10.240.0.4 --dstipmap=0.0.0.0/0:123.4.5.6 --fixcsum -i eth0 -t /out.pcap
Actual: 287011 packets (361734846 bytes) sent in 2.02 seconds
Rated: 178470035.0 Bps, 1427.76 Mbps, 141603.34 pps
Flows: 1 flows, 0.49 fps, 287011 unique flow packets, 0 unique non-flow packets
Statistics for network device: eth0
        Successful packets:        287011
        Failed packets:            0
        Truncated packets:         0
        Retried packets (ENOBUFS): 0
        Retried packets (EAGAIN):  0
```
