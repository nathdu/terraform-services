variable "availability_zones" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "service_names" {
  type = list(string)
}

variable "database_names" {
  type = list(string)
}