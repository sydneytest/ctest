#!/bin/bash
# Running unit test

# Reading input ip address
read -p "Enter ip: " ip

# Running unit test
echo "Running unit test for $ip ..."
ssh -i ssk_key -t centos@$ip <<ENDSSH
  sudo python /opt/app/system-engineer/testing/testing.py
ENDSSH
