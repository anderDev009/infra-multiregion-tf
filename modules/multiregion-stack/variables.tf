variable "vpc_cidr" {
  type = string
}
variable "region_name" {
  type = string
}
#zonas de disponiblidad 
variable "avaliability_zones" {
  type        = list(string)
  description = "Zonas de disponibilidad para configuracion de la VPC"
}
#bloques cidr
variable "cidr_block" {
  type = list(string)
}
#bloques cidr privado
variable "cidr_block_private" {
  type = list(string)
}