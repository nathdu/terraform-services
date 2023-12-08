data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "services" {
  count                       = 3
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnets[count.index]
  vpc_security_group_ids      = var.security_group_id
  associate_public_ip_address = true
  key_name                    = "octopus"
  tags = {
    Name = "${var.service_names[count.index]}-service"
  }
}

resource "aws_dynamodb_table" "service-tables" {
  count = length(var.database_names)
  name           = "${var.database_names[count.index]}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "N"
  }

  tags = {
    Name        = "${var.database_names[count.index]}"
    Environment = "production"
  }
}