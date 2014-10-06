#!/bin/bash

# set timezone
echo "UTC" > /etc/timezone    
dpkg-reconfigure -f noninteractive tzdata

#{deb_cache_cmds}

# install a few base packages
apt-get update
apt-get install vim curl zip unzip git python-pip python-support -y

# install java
apt-get install openjdk-7-jre libjna-java -y

# configure Cassandra repo
echo "deb http://www.apache.org/dist/cassandra/debian 21x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
gpg --export --armor F758CE318D77295D | sudo apt-key add -
gpg --keyserver pgp.mit.edu --recv-keys 2B5C1B00
gpg --export --armor 2B5C1B00 | sudo apt-key add -
gpg --keyserver pgp.mit.edu --recv-keys 0353B12C
gpg --export --armor 0353B12C | sudo apt-key add -

# install DataStax community
apt-get update
apt-get install cassandra -y

# stop service if running
echo "Stopping Cassandra..."
service cassandra stop
rm -rf /var/lib/cassandra/data/system/*

# copy datacenter config files and restart service
cp /vagrant/cassandra.yaml /etc/cassandra

echo "Restarting Cassandra..."
service cassandra start

echo "Vagrant provisioning complete"