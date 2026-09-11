data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_launch_template" "app" {
  name_prefix = "app-"
  image_id = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.sg_instance.id]
     user_data              = base64encode(<<-EOF
  #!/bin/bash
  apt-get update -y
  apt-get install -y nginx

  CONTAINER_IP=$(hostname -I | awk '{print $1}')

  sed -i "s/listen 80 default_server;/listen $${CONTAINER_IP}:80;/" /etc/nginx/sites-available/default

  echo "Hola desde $(hostname -f)" > /var/www/html/index.html

  pkill nginx
  sleep 2
  nginx
EOF
)
}