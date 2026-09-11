module "region_primary" {
  source             = "./modules/multiregion-stack"
  region_name        = "us-east-1"
  cidr_block         = ["10.0.1.0/24", "10.0.2.0/24"]
  cidr_block_private = ["10.0.11.0/24", "10.0.12.0/24"]
  providers = {
    aws = aws.primary
  }
  vpc_cidr           = "10.0.0.0/16"
  avaliability_zones = ["us-east-1a", "us-east-1b"]
}
module "region_secondary" {
  source             = "./modules/multiregion-stack"
  region_name        = "us-west-2"
  cidr_block         = ["10.1.1.0/24", "10.1.2.0/24"]
  cidr_block_private = ["10.1.11.0/24", "10.1.12.0/24"]
  providers = {
    aws = aws.secondary
  }
  vpc_cidr           = "10.0.0.0/16"
  avaliability_zones = ["us-west-2a", "us-west-2b"]
}


module "dns" {
  source      = "./modules/dns"
  domain_name = "app.lab.local"
  providers = {
    aws = aws.primary
  }
  primary_alb_dns_name   = module.region_primary.alb_dns_name
  primary_alb_zone_id    = module.region_primary.alb_zone_id
  primary_region         = "us-east-1"
  secondary_alb_dns_name = module.region_secondary.alb_dns_name
  secondary_alb_zone_id  = module.region_secondary.alb_zone_id
  secondary_region       = "us-west-2"
}