#!/bin/bash
 
set -e

# add PuppetLabs release repo to get latest Puppet
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
sudo dpkg -i puppetlabs-release-trusty.deb

# update package lists; upgrade installed packages
apt-get update -y
apt-get upgrade -y

# install latest version of Puppet
apt-get install puppet -y

# install Puppet modules
puppet module install puppetlabs-firewall
puppet module install puppetlabs-stdlib
