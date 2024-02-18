#!/bin/bash

# Project ID and desired instance name
PROJECT_ID="lucky-monument-408108"
INSTANCE_NAME="instance-2"

# Zone (find it in the Compute Engine instance details)
ZONE="asia-east1-b"

# Subnetwork name (find it in the VPC settings)
SUBNET_NAME="asia-east1"

# Check if the subnet has available IPv6 ranges
IPV6_RANGE=$(gcloud compute networks subnets describe $SUBNET_NAME \
              --project $PROJECT_ID \
              --format="value(ipv6CidrRange)")

if [[ -z "$IPV6_RANGE" ]]; then
  echo "Error: Subnet does not have IPv6 enabled. 
        Enable IPv6 on the subnet before proceeding."
  exit 1
fi

# **Important Notice:** 
# Enabling IPv6 will cause a brief restart of your instance.

read -p "Enabling IPv6 will restart your instance. Continue? (y/n) " -n 1 -r
echo   
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "IPv6 enabling canceled."
    exit 1
fi

# Add IPv6 access config
gcloud compute instances add-access-config $INSTANCE_NAME \
    --zone $ZONE \
    --project $PROJECT_ID \
    --access-config-name "External NAT"

echo "IPv6 enabled. Your instance will restart momentarily."
