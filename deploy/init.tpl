import os

# adding puppet repo
os.system("rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm")

# Puppet install
os.system("yes | yum -y install puppet")

# Install git 
os.system("yum install git -y")

# Download artifacts
os.system("git clone https://github.com/sydneytest/ctest.git /tmp/flask")

# Removing default puppet modules
os.system("rm -rf /etc/puppet")

# Copying app specific puppet modules
os.system("cp -pvrf /tmp/flask/puppet /etc/puppet")

# Execute puppet code
os.system("puppet apply /etc/puppet/manifests/commtest.pp")
