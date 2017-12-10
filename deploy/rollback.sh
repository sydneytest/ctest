#!/bin/bash
# Rollback Wrapper script

# Preparing
echo "Preparing terraform destroy ....."
sleep 10

# Terraform destroy
./terraform destroy --force

# Removing elb identifiers
rm elb_dns.txt

# Rollback completed
echo "rollback complete ...."
