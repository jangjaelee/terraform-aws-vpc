output "base_cidr_blocks" {
  value = module.subnet_addrs.network_cidr_blocks
}

output "k8s_cni_cidr_blocks" {
  #value = module.k8s_cni_subnet_addrs.network_cidr_blocks
  #value = length(module.k8s_cni_subnet_addrs.network_cidr_blocks) > 0 ? module.k8s_cni_subnet_addrs.network_cidr_blocks : null 
  value = var.create_eks_cidr ? module.k8s_cni_subnet_addrs.network_cidr_blocks : {}
}

output "availability_zone_name" {
  value = data.aws_availability_zones.available.names
}

/*output "route_talbes" {
  value = data.aws_route_tables.this.ids
}

output "count" {
  value = length(data.aws_route_tables.this.ids)
}*/
