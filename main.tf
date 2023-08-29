provider "aws" {
  alias = "US"
  shared_config_files = [var.tfc_aws_dynamic_credentials.default.shared_config_file]
}

provider "aws" {
  alias = "SG"
  shared_config_files = [var.tfc_aws_dynamic_credentials.aliases["SG"].shared_config_file]
  region = var.aws_region
}


data "aws_ami" "amazon_linux" {
  provider = aws.SG
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  provider = aws.SG
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<html><body><div>Hello, world!</div></body></html>" > /var/www/html/index.html
    EOF

  tags = var.tags
}
