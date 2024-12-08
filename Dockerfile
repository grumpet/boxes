# Use an official Ubuntu as a parent image
FROM ubuntu:latest

# Install nmap and tcpdump
RUN apt-get update && apt-get install -y nmap tcpdump && apt-get install -y net-tools && apt-get install -y iputils-ping

# Expose all ports
EXPOSE 1-65535

# Set the working directory
WORKDIR /root

# Run a shell to keep the container running
CMD ["bash"]