#!/bin/sh

## Exit when any command fails
set -e

## Check if running with root permissions
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

## Set variables
version="v1.3.0"
install_dir="/usr/local/bin"
config_dir="/usr/local/etc/nebula"
config_file="$config_dir/config.yml"
service_file="/usr/local/etc/rc.d/nebula"

## Download Nebula
url="https://github.com/slackhq/nebula/releases/download/$version/nebula-freebsd-amd64.tar.gz"
echo "Downloading $url"
curl "$url" -sLo /tmp/nebula.tar.gz

## Extract Nebula
tar xzf /tmp/nebula.tar.gz -C "$install_dir/"

## Create config directory
mkdir -p "$config_dir"

## Download example config file
if [ ! -f "$config_file" ]; then
  curl https://raw.githubusercontent.com/slackhq/nebula/master/examples/config.yml -sLo "$config_file"
fi

## Install service
if [ ! -f "$service_file" ]; then
  curl https://raw.githubusercontent.com/slackhq/nebula/master/examples/service_scripts/nebula.init.d.sh -sLo "$service_file"
fi

## Set permissions
chmod 755 "$service_file"
chown root:root "$service_file"