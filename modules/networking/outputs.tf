output "vpc_id" {
  value = aws_vpc.project.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}