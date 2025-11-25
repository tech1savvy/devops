resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

resource "aws_instance" "web-server" {
  ami           = var.ami
  instance_type = "t2.micro"
  tags = {
    Name = "etp"
  }
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = var.key_name
  subnet_id              = var.subnet_id
}
