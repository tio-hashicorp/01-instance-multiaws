provider "aws" {
#  shared_config_files = [var.tfc_aws_dynamic_credentials.default.shared_config_file]
  region = var.aws_region
}
/*
provider "aws" {
  alias = "SG"
  shared_config_files = [var.tfc_aws_dynamic_credentials.aliases["SG"].shared_config_file]
  region = "ap-southeast-1"
}

variable "tfc_aws_dynamic_credentials" {
  description = "Object containing AWS dynamic credentials configuration"
  type = object({
    default = object({
      shared_config_file = string
    }) 
    aliases = map(object({
      shared_config_file = string
    }))
  })
}
*/

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
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
