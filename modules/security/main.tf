resource "aws_security_group" "http_and_https_sg" {
  name        = "http_and_https_sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "http_and_https_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http_ingress_rule" {
  security_group_id = aws_security_group.http_and_https_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "app_port_ipv4_ingress_rule" {
  security_group_id = aws_security_group.http_and_https_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 3000
  ip_protocol = "tcp"
  to_port     = 3000 + length(var.service_names) - 1
}

resource "aws_vpc_security_group_ingress_rule" "app_port_ipv6_ingress_rule" {
  security_group_id = aws_security_group.http_and_https_sg.id

  cidr_ipv6   = "::/0"
  from_port   = 3000
  ip_protocol = "tcp"
  to_port     = 3000 + length(var.service_names) - 1
}

resource "aws_vpc_security_group_egress_rule" "app_port_ipv4_egress_rule" {
  security_group_id = aws_security_group.http_and_https_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 3000
  ip_protocol = "tcp"
  to_port     = 3000 + length(var.service_names) - 1
}

resource "aws_vpc_security_group_egress_rule" "app_port_ipv6_egress_rule" {
  security_group_id = aws_security_group.http_and_https_sg.id

  cidr_ipv6   = "::/0"
  from_port   = 3000
  ip_protocol = "tcp"
  to_port     = 3000 + length(var.service_names) - 1
}


resource "aws_vpc_security_group_ingress_rule" "https_ingress_rule" {
  security_group_id = aws_security_group.http_and_https_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "http_egress_rule" {
  security_group_id = aws_security_group.http_and_https_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "https_egress_rule" {
  security_group_id = aws_security_group.http_and_https_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_security_group" "ssh_sg" {
  name        = "ssh_sg"
  description = "Allow SSH traffic from my IP"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ssh_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_ingress_rule" {
  security_group_id = aws_security_group.ssh_sg.id

  cidr_ipv4   = "109.153.206.253/32"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}
