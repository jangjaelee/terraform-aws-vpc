# Create VPC (Virtual Private Cloud)
resource "aws_vpc" "this" {
  count                = var.create_vpc ? 1 : 0

  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    {
      "Name" = format("%s", var.vpc_name)
    },
    var.tags,
    var.vpc_tags,
  )
}

