# Manual Puppet Certificate Signing

This guide outlines the manual process for an authenticated-based workflow for certificate signing between a Puppet agent and a Puppet master.

## 1. On the Puppet Agent Node

These steps are needed to generate a certificate signing request (CSR) from the agent to the master.

### a. Set the Certificate Name

First, you need to define a unique `certname` for the agent. This is typically the agent's fully qualified domain name (FQDN).

Edit the `puppet.conf` file:
```bash
sudo nano /etc/puppet/puppet.conf
```

In the `[agent]` section, set the `certname`:
```ini
[agent]
certname = <agent-certname>
```
Replace `<agent-certname>` with the desired certificate name for your agent node.

### b. Trigger a Certificate Request

Run the Puppet agent in test mode. This will generate the certificate request and send it to the master.
```bash
sudo puppet agent --test
```
You will likely see an error that the certificate is not signed yet. This is expected.

## 2. On the Puppet Master Node

These steps are for the administrator to sign the request on the Puppet Master.

### a. List Pending Requests

You can see a list of all pending certificate signing requests.
```bash
sudo puppetserver ca list
```
This will show you the `certname` of the agent that just requested a certificate.

### b. Sign the Agent's Certificate

Once you have verified the request, you can sign it.
```bash
sudo puppetserver ca sign --certname <agent-certname>
```
Replace `<agent-certname>` with the same name you saw in the list from the previous command.

## 3. Final Agent Run

Go back to the **Puppet Agent Node** and run the agent again to confirm it can now connect to the master.
```bash
sudo puppet agent --test
```
This time, it should successfully connect and apply any configurations from the master.