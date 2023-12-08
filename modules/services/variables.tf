variable "vpc_security_group_ids" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "security_group_id" {
  type = list(string)
}

variable "service_names" {
  type = list(string)
}

variable "database_names" {
  type = list(string)
}