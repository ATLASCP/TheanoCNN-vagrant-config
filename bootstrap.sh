#!/usr/bin/env bash
##
## This script has to be ran first when bringing up this vagrant configuration,
## sets up all essential libraries, dependencies and tools.
##

# To display detailed information when executing this script
set -ex

# Update apt-get
apt-get update

# Generic tools
apt-get install -y git
apt-get install -y vim
apt-get install -y build-essential

# Theano dependencies (Python Math Toolbox)
apt-get install -y python-numpy python-scipy python-dev python-pip python-nose
apt-get install -y libopenblas-dev
pip install Theano


# Add sync folder
mkdir -p "/vagrant/sync"
sudo chown -R vagrant:vagrant "/vagrant/sync/"

# Link sync directory into home
if [[ ! -L "/home/vagrant/sync" ]]; then
  ln -s "/vagrant/sync" "/home/vagrant/sync"
  chown -R vagrant:vagrant /home/vagrant/sync
fi

echo "Done! Vagrant provision complete."



