module "app" {
  source        = "./modules/ec2"
  instance_name = "app1"
  vpc_id        = var.vpc_id
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  ami           = var.ami
}

module "nagios" {
  source        = "./modules/ec2"
  instance_name = "nagios1"
  vpc_id        = var.vpc_id
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  ami           = var.ami
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    nagios_public_ip  = module.nagios.public-ip-address
    nagios_private_ip = module.nagios.private-ip-address
    app_public_ip     = module.app.public-ip-address
    app_private_ip    = module.app.private-ip-address
    private_key_path  = var.private_key_path
  })
  filename = "inventory.ini"
}
