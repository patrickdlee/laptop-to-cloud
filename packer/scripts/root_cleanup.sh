#!/bin/bash
 
set -e

# clean up old packages
apt-get autoclean
apt-get autoremove -y
