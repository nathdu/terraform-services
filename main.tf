module "networking" {
  source             = "./modules/networking"
  vpc_name           = "project"
  cidr_range         = "10.0.0.0/20"
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
}

module "security" {
  source        = "./modules/security"
  vpc_id        = module.networking.vpc_id
  service_names = var.service_names
}

module "services" {
  source                 = "./modules/services"
  public_subnets         = module.networking.public_subnets
  vpc_security_group_ids = module.security.security_group_ids
  security_group_id      = module.security.security_group_ids
  service_names          = var.service_names
  database_names         = var.database_names
}

module "load_balancing" {
  source             = "./modules/load_balancing"
  public_subnets     = module.networking.public_subnets
  security_group_ids = module.security.security_group_ids
  vpc_id             = module.networking.vpc_id
  service_names      = var.service_names
  server_ids         = module.services.server_ids
}