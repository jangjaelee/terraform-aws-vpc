resource "aws_default_network_acl" "this" {
  count = var.create_vpc ? 1 : 0

  default_network_acl_id = local.default_nacl_id

  ingress {
    rule_no    = 100
    protocol   = "-1"
    from_port  = 0
    to_port    = 0
    cidr_block = var.default_destination
    action     = "allow"
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    from_port  = 0
    to_port    = 0
    cidr_block = var.default_destination
    action     = "allow"
  }

  tags = merge(
    {
      "Name" = format("%s-default-nacl", var.vpc_name)
    },
    local.common_tags,
  )
}

resource "aws_network_acl" "public" {
  vpc_id = local.vpc_id
  subnet_ids = [for k, v in aws_subnet.this : v.id if split("_", k)[1] == "public"]

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.default_destination
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.default_destination
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    { 
      "Name" = format("%s-public-nacl", var.vpc_name)
    },
    local.common_tags,
  )
}

resource "aws_network_acl" "private_sub_env1" {
  vpc_id = local.vpc_id
  subnet_ids = [for k, v in aws_subnet.this : v.id if split("_", k)[1] == "private" && split("_", k)[2] == var.private_sub_env1]

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.default_destination
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.default_destination
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    { 
      "Name" = format("%s-private-%s-nacl", var.vpc_name, var.private_sub_env1)
    },
    local.common_tags,
  )
}

resource "aws_network_acl" "private_sub_env2" {
  vpc_id = local.vpc_id
  subnet_ids = [for k, v in aws_subnet.this : v.id if split("_", k)[1] == "private" && split("_", k)[2] == var.private_sub_env2]

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.default_destination
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.default_destination
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    { 
      "Name" = format("%s-private-%s-nacl", var.vpc_name, var.private_sub_env2)
    },
    local.common_tags,    
  )    
}

resource "aws_network_acl" "private_k8s-cni" {
  vpc_id = local.vpc_id
  subnet_ids = [for k, v in aws_subnet.k8s_cni : v.id if split("_", k)[1] == "private" && split("_", k)[2] == "k8s-cni"]

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.default_destination
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.default_destination
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    { 
      "Name" = format("%s-private-k8s-cni-nacl", var.vpc_name)
    },    
    local.common_tags,
  )
}