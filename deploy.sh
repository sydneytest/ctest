#!/bin/bash
# app deploy wrapper script

# Updating all system packages
#yum update -y

# Download puppet for rhel7
rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm

# Puppet install
yes | yum -y install puppet

# Install git
yum install git -y

# Download artifacts and configs
git clone https://github.com/sydneytest/ctest.git /tmp/flask

# Removing default puppet modules
rm -rf /etc/puppet

# Copying app specific puppet modules
cp -pvrf /tmp/flask/puppet /etc/puppet

# Execute puppet code
puppet apply /etc/puppet/manifests/commtest.pp
