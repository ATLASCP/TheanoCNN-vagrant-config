#!/usr/bin/env bash
##
## This script has to be ran first when bringing up this vagrant configuration,
## sets up all essential libraries, dependencies and tools.
##

# To display detailed information when executing this script
set -ex

###### Apt-Get #########

# PTI stands for Programs To Install
PTI=''

# Git
PTI="${PTI} git"

# Vim
PTI="${PTI} vim"

# Python packages and requirements
PTI="${PTI} curl zlib1g-dev libbz2-dev libreadline-dev libgdbm-dev libssl-dev \
libsqlite3-dev python python-setuptools python-dev python-numpy python-scipy python-matplotlib \
ipython ipython-notebook python-pandas python-sympy python-nose \
g++ python-software-properties libopenblas-base libopenblas-dev liblapack-dev \
gfortran libfreetype6-dev"

# Remove libatlas because Theanos requires blas, and it is faster
apt-get --purge -y remove libatlas3gf-base libatlas-dev

# Bring apt-get up to date
apt-get update

# Install all the apt-get packages
apt-get install -y ${PTI}

####### Python ##########  
   
# Upgrade older Ubuntu packages to most recent PyPi versions
# Sequence matters
easy_install pip
pip install --upgrade setuptools --no-use-wheel
pip install --upgrade pip
pip install --upgrade cython

# Install scimath and numpy, these components are at the bottom
# as they tend to cause problems and should crash at the end to avoid reprovisioning
pip install --upgrade numpy
/usr/local/bin/easy_install scimath
pip install --upgrade ipython[all] jinja2 vincent virtualenv pythonbrew pandas SciPy matplotlib
pip install --upgrade theano

# Switch symlink from libatlas to libopenblas
# Manually this would be done with commmand
# update-alternatives --config libblas.so.3gf < Option 2: /usr/lib/lapack/liblapack.so.3gf 
rm -rf /usr/lib/liblapack.so.3gf
ln -s /usr/lib/lapack/liblapack.so.3gf /usr/lib/liblapack.so.3gf

# Insert cludge to fix Theano imports
sed -i '130iimport numpy.distutils.__config__' /usr/local/lib/python2.7/dist-packages/theano/tensor/blas.py


# Add sync folder
mkdir -p "/vagrant/sync"
sudo chown -R vagrant:vagrant "/vagrant/sync/"

# Link sync directory into home
if [[ ! -L "/home/vagrant/sync" ]]; then
  ln -s "/vagrant/sync" "/home/vagrant/sync"
  chown -R vagrant:vagrant /home/vagrant/sync
fi

echo "Done! Vagrant provision complete."



