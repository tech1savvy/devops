# ansible command to ping all hosts

ansible all -i inventory.ini -m ping

## interpreting a failed ping

- if a host returns "UNREACHABLE", ansible cannot make an SSH connection  
  → check ssh service, firewall, network, or wrong IP.

- if it returns "FAILED", ansible connected but the ping module failed  
  → usually wrong python setup, sudo issues, or broken remote environment.

- successful output shows "pong", meaning the control node can reach and run modules on that host.
