#!/usr/bin/env bash

# Exit on errors
set -e

# Ensure we are running as root
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run this script with sudo:"
  echo "  sudo $0"
  exit 1
fi

hostnamectl set-hostname agent

apt-get update
apt-get install -y wget

# ============================
# CONFIGURE MASTER HOST ENTRY
# ============================

# TODO: replace with actual private IP of puppet master
MASTER_IP="<private_ip_of_master>"
MASTER_HOSTNAME="puppet"

if ! grep -qE "\s${MASTER_HOSTNAME}\b" /etc/hosts; then
  echo "${MASTER_IP} ${MASTER_HOSTNAME}" >>/etc/hosts
fi

# ============================
# INSTALL PUPPET AGENT
# ============================

# This assumes repos are already set up (Ubuntu or PuppetLabs).
# On Ubuntu, this usually installs /usr/bin/puppet.
apt-get install -y puppet-agent || apt-get install -y puppet

# Find puppet binary (works for both distro and Puppet AIO layout)
PUPPET_BIN="$(command -v puppet || true)"
if [[ -z "$PUPPET_BIN" && -x /opt/puppetlabs/bin/puppet ]]; then
  PUPPET_BIN="/opt/puppetlabs/bin/puppet"
fi

if [[ -z "$PUPPET_BIN" ]]; then
  echo "puppet binary not found after installation. Exiting."
  exit 1
fi

# ============================
# CONFIGURE puppet.conf
# ============================

# Support both layouts: /etc/puppetlabs/puppet and /etc/puppet
PUPPET_CONF_DIR="/etc/puppetlabs/puppet"
if [[ ! -d "$PUPPET_CONF_DIR" ]]; then
  PUPPET_CONF_DIR="/etc/puppet"
  mkdir -p "$PUPPET_CONF_DIR"
fi

PUPPET_CONF="${PUPPET_CONF_DIR}/puppet.conf"

# Backup existing puppet.conf if present
if [[ -f "$PUPPET_CONF" ]]; then
  cp "$PUPPET_CONF" "${PUPPET_CONF}.bak.$(date +%s)"
fi

# Use FQDN as default certname
CERTNAME="$(hostname -f 2>/dev/null || hostname)"

cat >"$PUPPET_CONF" <<EOF
[main]
server = ${MASTER_HOSTNAME}
environment = production

[agent]
certname = ${CERTNAME}
EOF

# ============================
# ENABLE AND START AGENT
# ============================

# Service is usually named "puppet"
if systemctl list-unit-files | grep -q '^puppet\.service'; then
  systemctl enable puppet
  systemctl restart puppet
fi

# ============================
# INITIAL AGENT RUN
# ============================

# This will trigger a CSR on the master (first run will usually fail
# until the master signs the certificate).
"${PUPPET_BIN}" agent -t || true

echo "Puppet agent setup complete. Ensure the master signs the certificate, then re-run:"
echo "  sudo ${PUPPET_BIN} agent -t"
