#!/bin/bash

# Directories
pcap_dir="pcap"
csv_dir="csv"

# Ensure the csv directory exists
mkdir -p "$csv_dir"

# Loop through all pcap files in the pcap directory
for pcap_file in "$pcap_dir"/*.pcap; do
    # Get the base name of the pcap file (without directory and extension)
    base_name=$(basename "$pcap_file" .pcap)
    
    # Define the corresponding csv file path
    csv_file="$csv_dir/$base_name.csv"
    
    # Check if the csv file already exists
    if [ -f "$csv_file" ]; then
        echo "Skipping $pcap_file, $csv_file already exists."
    else
        # Convert pcap to csv using tshark
        tshark -r "$pcap_file" -T fields -E separator=, -E quote=d -E header=y \
            -e frame.number -e frame.time -e ip.src -e ip.dst -e tcp.srcport -e tcp.dstport -e frame.len -e _ws.col.Info > "$csv_file"
        
        # Check if the conversion was successful
        if [ $? -eq 0 ]; then
            echo "Conversion successful: $csv_file"
        else
            echo "Conversion failed for $pcap_file"
            exit 1
        fi
    fi
done