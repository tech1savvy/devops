#!/usr/bin/env bash

# Exit on errors
set -e

# Ensure we are running as root
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run this script with sudo:"
  echo "  sudo $0"
  exit 1
fi

hostnamectl set-hostname master

# ============================
# MASTER CONFIGURATION
# ============================

apt-get update

# Set the master IP and map it to hostname "puppet"
# TODO: replace this with the actual private IP of the master
MASTER_IP="<private_ip_of_master>"
MASTER_HOSTNAME="puppet"

# Only add the hosts entry if it isn't already there
if ! grep -q "$MASTER_HOSTNAME" /etc/hosts; then
  echo "$MASTER_IP $MASTER_HOSTNAME" >>/etc/hosts
fi

# ============================
# INSTALL PUPPET SERVER
# ============================

apt-get install -y puppetserver puppet-agent

# ============================
# SERVICE & JVM SETTINGS
# ============================

# Configure memory allocation for Puppet Server (512m)
# (File path is for AIO puppetserver on Debian/Ubuntu)
# if [[ -f /etc/default/puppetserver ]]; then
#   sed -i 's/^JAVA_ARGS=.*/JAVA_ARGS="-Xms512m -Xmx512m"/' /etc/default/puppetserver
# fi

# Enable and restart Puppet Server service
systemctl enable puppetserver
systemctl restart puppetserver

# ============================
# CERTIFICATE MANAGEMENT (AGENTS)
# ============================
# These commands are meant to be run after agents have requested certificates.
# They are left commented so the script doesn't fail if no requests exist yet.

# List certificate signing requests from agents
# sudo puppetserver ca list

# Sign all pending certificate requests
# sudo puppetserver ca sign --all

# ============================
# MANIFEST CREATION ON MASTER
# ============================

# Puppet Server code directory (AIO layout)
/bin/mkdir -p /etc/puppet/code/environments/production/manifests
/bin/touch /etc/puppet/code/environments/production/manifests/site.pp

# Reload Puppet Server to ensure code changes are picked up
systemctl restart puppetserver
