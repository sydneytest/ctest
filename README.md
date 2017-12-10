# ctest
Repo for ctest
Deploy Flask app
 
 
 Prerequisite:
 
 1. Unix based OS (where you can execute shell script)
 2. Access key and secret key of an IAM AWS user with privilige to launch EC2 resources.
 3. VPC id, VPC cidr and subnet ids. - These should be added in variables.tf
 4. Git installed

       How to install git:

       Choose the appropriate command according to your OS version from https://git-scm.com/download/linux.     
 5. Terraform installed.

       How to install Terraform:

       Get appropriate package for your system from https://www.terraform.io/downloads.html and download it.
 
       Unzip the package. Terraform runs as a single binary named terraform. Replace terraform binary in deploy folder with this binary.

       Default terraform binary in deploy folder is compatible with MAC OS
 6.   AWS cli installed

      How to install aws cli:

      Follow the steps from http://docs.aws.amazon.com/cli/latest/userguide/installing.html
  
      AWS cli should be added to the PATH

      example: export PATH=$PATH:/Users/user1/Library/Python/2.7/bin/
              
 
 Steps to deploy:
 
 1. Clone the below public github repo

      git clone https://github.com/sydneytest/ctest.git
      
 2. Edit the default variable values in variables.tf in deploy folder for customisation. Mandatory variables to be changed are "access_key", "secret_key", "vpc_cidr", "vpc_id", "subnet". If you need the app to be scaled, change the max, min and desired values in variables.tf

      cd ctest/deploy/

      vi variables.tf -> Edit and Save the file
  
 3. As mentioned in prerequisite, replace the terraform binary in deploy folder with your downloaded one.

       cp "<your_downloaded_unzipped_terraform_binary> ctest/deploy/
       
    
 4. Execute deploy.sh

     cd ctest/deploy/

     ./deploy.sh
     
     This will take ~5minutes to complete.  
     After app deployment, script access the application end point from AWS ELB and return the status.
     
 5. After the above successful URL Sanity testing proceed to unit testing.

    Execute testing.sh. This will prompt to enter the IP address of the instance, which can be found in instance_ip.txt(This txt file would be generated during deployment.)

      cd ctest/deploy/

      ./testing.sh   
      
 6. To roll back the deployment and destroy all the resources created, execute rollback.sh

      cd ctest/deploy

      ./rollback.sh
    
 Technologies Used:

 Cloud Provider : AWS

 Infrastructure Automation : Terraform

 High availability, Scaling and Monitoring: Autoscaling, ELB

 Configuration management : Puppet

 Scripting : Shell and Python

 Instance OS : Centos 7 AMI

 Default terraform binary compatible with MAC OS
