output "security_group_ids" {
  value = [aws_security_group.http_and_https_sg.id, aws_security_group.ssh_sg.id]
}