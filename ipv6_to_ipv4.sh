#!/bin/bash

# Get IPv4 proxy info
read -p "Enter public IPv4 proxy address: " IPV4_PROXY
if [[ ! $IPV4_PROXY =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
  echo "Invalid public IP address format. Please try again."
  exit 1
fi

read -p "Enter proxy port: " PORT
if [[ ! $PORT =~ ^[0-9]+$ ]] || [[ $PORT -lt 1 ]] || [[ $PORT -gt 65535 ]]; then
  echo "Invalid port number. Please enter a number between 1 and 65535."
  exit 1
fi

# Install proxychains if needed
if ! command -v /usr/bin/proxychains >/dev/null 2>&1; then
  echo "Installing proxychains..."
  
  apt-get update
  apt-get install -y proxychains
  
  if [[ $? -ne 0 ]]; then
    echo "Error installing proxychains"
    exit 1
  fi
else
  echo "proxychains already installed"
fi

# Set up proxychains config
echo "Using proxy: $IPV4_PROXY $PORT"
echo "socks5 $IPV4_PROXY $PORT" > /etc/proxychains.conf

if [[ $? -ne 0 ]]; then
  echo "Error writing proxychains config"
  exit 1
fi

# Run commands through proxy
PROXY_CMD="/usr/bin/proxychains"

echo "Proxy setup completed. Use '$PROXY_CMD' before commands to route through proxy."

# Example:
$PROXY_CMD ping 8.8.8.8
