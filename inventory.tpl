[nagios]
nagios_server ansible_host=${nagios_public_ip} private_ip=${nagios_private_ip}

[app]
app_server ansible_host=${app_public_ip} private_ip=${app_private_ip}

[all:vars]
ansible_ssh_private_key_file=${private_key_path}
