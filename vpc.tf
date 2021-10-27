# Create VPC (Virtual Private Cloud) for EKS
resource "aws_vpc" "this" {
  count                = var.create_vpc ? 1 : 0

  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    {
      "Name" = format("%s-vpc", var.vpc_name)
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    },
    local.common_tags,
    var.vpc_tags,
  )
}

resource "aws_vpc_ipv4_cidr_block_association" "k8s_cni_cidr" {
  vpc_id = local.vpc_id
  cidr_block = var.k8s_cni_cidr
}
