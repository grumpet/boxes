# builds the nmap container image
docker build -f Dockerfile.nmap --no-cache -t nmap-container .

# builds the http server container image
docker build -f Dockerfile.http --no-cache -t http-container .

# creates a custom network
docker network create my_custom_network

# runs the nmap container on the custom network
docker run --rm --name nmap_container --network my_custom_network -it nmap-container

# runs the http server container on the custom network with additional capabilities
docker run --rm --name http_container --network my_custom_network -p 80:80 --cap-add=CAP_NET_ADMIN --cap-add=CAP_NET_RAW -d http-container

# find the IP address of the http container
docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" http_container

# scan the http container from the nmap container
nmap <http_container_ip>

# use tcpdump inside the http container
docker exec -it http_container tcpdump -i eth0 -w /root/capture.pcap

# use tshark inside the http container
docker exec -it http_container tshark -i eth0 -w /root/capture.pcap

# access the CLI of the http container
docker exec -it http_container /bin/bash

# view the pcap file using tcpdump inside the http container
docker exec -it http_container tcpdump -r /root/capture.pcap

# view the pcap file using tshark inside the http container
docker exec -it http_container tshark -r /root/capture.pcap

# copy the pcap file to your host machine
docker cp http_container:/root/capture.pcap ./capture.pcap

# convert pcap to csv using tshark
tshark -r capture.pcap -T fields -E separator=, -E quote=d -E header=y -e frame.number -e frame.time -e ip.src -e ip.dst -e tcp.srcport -e tcp.dstport -e frame.len -e _ws.col.Info > capture.csv