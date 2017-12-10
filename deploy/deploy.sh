#!/bin/bash
# Deployment Wrapper script

# Preparing deploment
>elb_dns.txt
>instance_id.txt
>instance_ip.txt

# Terraform init
./terraform init

# Terraform apply
echo "Starting installation ...."
./terraform apply -auto-approve

# Waiting for aws resurces to come online
echo "Waiting for aws resurces to come online ...."
sleep 180

# Fetching elb resource identifiers
elbdns=$(sed -n '1p' elb_dns.txt)
elbname=$(sed -n '2p' elb_dns.txt)

# Getting AWS key
access_key=$(grep -A 1 access_key variables.tf | grep default | cut -d '"' -f2)
secret_key=$(grep -A 1 secret_key variables.tf | grep default | cut -d '"' -f2)

# Getting instance id attached to elb
AWS_ACCESS_KEY_ID=$access_key AWS_SECRET_ACCESS_KEY=$secret_key aws elb describe-load-balancers --load-balancer-name "$elbname" --output text --query "LoadBalancerDescriptions[*].Instances[*].InstanceId" --region ap-southeast-2 >> instance_id.txt 

# Getting instance public IP address
for instanceid in $(cat instance_id.txt);
do
 instanceip=$(AWS_ACCESS_KEY_ID=$access_key AWS_SECRET_ACCESS_KEY=$secret_key aws ec2 describe-instances --instance-ids $instanceid --output text --query "Reservations[*].Instances[*].PublicIpAddress" --region ap-southeast-2)
 echo $instanceip >> instance_ip.txt
done

# Testing app url endpoint
echo "testing app url endpoint ...."
curl http://$elbdns:5000/customers -v
