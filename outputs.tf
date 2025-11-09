output "app_server_public_ip" {
  description = "Public IP address of the App server."
  value       = module.app.public-ip-address
}

output "nagios_server_public_ip" {
  description = "Public IP address of the Nagios server."
  value       = module.nagios.public-ip-address
}
