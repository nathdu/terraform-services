variable "security_group_ids" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "service_names" {
  type = list(string)
}

variable "server_ids" {
  type = list(string)
}