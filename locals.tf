locals {
  vpc_id = var.create_vpc ? element(concat(aws_vpc.this.*.id, [""]), 0) : var.vpc_id
  default_nacl_id = var.create_vpc ? element(concat(aws_vpc.this.*.default_network_acl_id, [""]), 0) : var.vpc_id

  common_tags = {
    "cloud/platform" = "AWS"
    "cloud/platform_env"  = var.env
    "cloud/managed_by" = "terraform"
    "cloud/module" = "vpc"
  }
}
