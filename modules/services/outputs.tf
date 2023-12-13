output "server_ids" {
  value = aws_instance.services[*].id
}