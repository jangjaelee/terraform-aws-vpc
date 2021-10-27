data "aws_availability_zones" "available" {
  state = "available"
}

module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = var.vpc_cidr
   networks = concat(
    [for az in var.az_zone_names : {name: "${az}_private_${var.private_sub_env1}", new_bits = var.private_subnets_new_bits}],
    [for az in var.az_zone_names : {name: "${az}_public_${var.public_sub_env1}", new_bits = var.public_subnets_new_bits} if var.enable_public_subnet],
    [for az in var.az_zone_names : {name: "${az}_private_${var.private_sub_env2}", new_bits = var.private_subnets_new_bits} if var.enable_sub_env],
    [for az in var.az_zone_names : {name: "${az}_public_${var.public_sub_env2}", new_bits = var.public_subnets_new_bits} if var.enable_sub_env && var.enable_public_subnet]
  )
}

resource "aws_subnet" "this" {
  for_each = module.subnet_addrs.network_cidr_blocks

  vpc_id = local.vpc_id
  availability_zone = split("_", each.key)[0]
  cidr_block = each.value
  map_public_ip_on_launch = split("_", each.key)[1] == "public"

  tags = merge(
    {
      Name = "${var.vpc_name}-${split("_", each.key)[1]}-${split("_", each.key)[2]}-sn"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/${split("_", each.key)[1] == "private" ? "internal-" : ""}elb" = 1
      "net:type" = split("_", each.key)[1]
      "net:env" = split("_", each.key)[2]
    },
    local.common_tags,
  )
}

module "k8s_cni_subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = var.k8s_cni_cidr
  networks = concat(
    [for az in var.az_zone_names : {name: "${az}_private_k8s-cni", new_bits = var.k8s_cni_subnets_new_bits}]
  )
}

resource "aws_subnet" "k8s_cni" {
  for_each = module.k8s_cni_subnet_addrs.network_cidr_blocks

  vpc_id = local.vpc_id
  availability_zone = split("_", each.key)[0]
  cidr_block = each.value
  map_public_ip_on_launch = split("_", each.key)[1] == "public"

  tags = merge(
    {
      Name = "${var.vpc_name}-${split("_", each.key)[1]}-${split("_", each.key)[2]}-sn"
      "net:type" = split("_", each.key)[2]
    },
    local.common_tags,
  )

  depends_on = [
    aws_vpc_ipv4_cidr_block_association.k8s_cni_cidr
  ]
}
