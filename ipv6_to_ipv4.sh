#!/bin/bash

CONFIG_FILE=".ipv4_proxy_config"

# Check if the configuration file exists
if [[ -f $CONFIG_FILE ]]; then
  # Load the proxy settings from the configuration file
  source "$CONFIG_FILE"
fi

# Prompt user for IPv4 proxy configuration

read -p "Enter IPv4 proxy address (leave blank to use previous value: $PROXY_IPV4): " new_proxy_ipv4

if [[ -n $new_proxy_ipv4 ]]; then
  # Update the proxy address if a new value is provided
  while [[ ! $new_proxy_ipv4 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; do
    echo "Invalid IPv4 address format. Please try again."
    read -p "Enter IPv4 proxy address: " new_proxy_ipv4
  done

  PROXY_IPV4="$new_proxy_ipv4"
fi

read -p "Enter proxy port (leave blank to use previous value: $PROXY_PORT): " new_proxy_port

if [[ -n $new_proxy_port ]]; then
  # Update the proxy port if a new value is provided
  while ! [[ $new_proxy_port =~ ^[0-9]+$ ]]; do
    echo "Invalid port number format. Please try again."
    read -p "Enter proxy port: " new_proxy_port
  done

  PROXY_PORT="$new_proxy_port"
fi

# Save the proxy settings to the configuration file
echo "PROXY_IPV4=$PROXY_IPV4" > "$CONFIG_FILE"
echo "PROXY_PORT=$PROXY_PORT" >> "$CONFIG_FILE"

# Check if the IPv6-to-IPv4 proxy is accessible

check_proxy_connectivity() {
  if ping -c 1 -W 1 "$PROXY_IPV4" &> /dev/null; then
    echo "Proxy is accessible."
    return 0
  else
    echo "Proxy is not accessible."
    return 1
  fi
}

# Run IPv4 script using the IPv6-to-IPv4 proxy

run_ipv4_script() {
  if check_proxy_connectivity; then
    # Set up environment variables to use the proxy
    export http_proxy="http://[$PROXY_IPV4]:$PROXY_PORT"
    export https_proxy="http://[$PROXY_IPV4]:$PROXY_PORT"
    
    # Run the IPv4 script or command
    # Replace "your_ipv4_command" with the actual command you want to run
    your_ipv4_command
  else
    echo "Cannot run IPv4 script. Proxy is not accessible."
  fi
}

# Main script logic

run_ipv4_script
