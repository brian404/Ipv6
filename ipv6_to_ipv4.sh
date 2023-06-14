#!/bin/bash

# Prompt user for IPv4 proxy configuration

read -p "Enter IPv4 proxy address: " PROXY_IPV4

while [[ ! $PROXY_IPV4 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; do

  echo "Invalid IPv4 address format. Please try again."

  read -p "Enter IPv4 proxy address: " PROXY_IPV4

done

read -p "Enter proxy port: " PROXY_PORT

while ! [[ $PROXY_PORT =~ ^[0-9]+$ ]]; do

  echo "Invalid port number format. Please try again."

  read -p "Enter proxy port: " PROXY_PORT

done

# Command to run IPv4 scripts or applications

IPv4_COMMAND="your_ipv4_script.sh"  # Replace with the command for running your IPv4 script

# Check if the VPS has IPv4 connectivity

check_ipv4_connectivity() {

  if ping -c 1 -W 1 "$PROXY_IPV4" &> /dev/null; then

    echo "IPv4 connectivity is available."

    return 0

  else

    echo "IPv4 connectivity is not available."

    return 1

  fi

}

# Run IPv4 script using the IPv6-to-IPv4 proxy

run_ipv4_script() {

  if check_ipv4_connectivity; then

    # Set up environment variables to use the proxy

    export http_proxy="http://[$PROXY_IPV4]:$PROXY_PORT"

    export https_proxy="http://[$PROXY_IPV4]:$PROXY_PORT"

    

    # Run the IPv4 script

    "$IPv4_COMMAND"

  else

    echo "Cannot run IPv4 script. IPv4 connectivity is not available."

  fi

}

# Main script logic

run_ipv4_script

