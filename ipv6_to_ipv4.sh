#!/bin/bash

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

# Install proxychains if not already installed
if ! command -v proxychains &> /dev/null; then
  echo "Installing proxychains..."
  apt-get update
  apt-get install -y proxychains
fi

# Set up proxychains configuration
echo "socks5 $PROXY_IPV4 $PROXY_PORT" > /etc/proxychains.conf

# Command to run IPv4 scripts or applications
IPv4_COMMAND="your_ipv4_script.sh"  # Replace with the command for running your IPv4 script

# Run IPv4 script using the IPv6-to-IPv4 proxy
proxychains $IPv4_COMMAND

