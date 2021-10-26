resource "aws_route_table" "private" {
  vpc_id = local.vpc_id

  tags = merge(
    { 
      "Name" = format("%s-private-rt", var.vpc_name)
      "net:type" = "private"
    },
    local.common_tags,
  )
}

resource "aws_route_table_association" "private" {
  for_each = {for k, subnet in aws_subnet.this : k => subnet if split("_", k)[1] == "private"}

  subnet_id = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "public" {
  count = var.enable_public_subnet ? 1 : 0
  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = merge(
    { 
      "Name" = format("%s-public-rt", var.vpc_name)
      "net:type" = "public"
    },
    local.common_tags,
  )
}

resource "aws_route_table_association" "public" {
  for_each = {for k, subnet in aws_subnet.this : k => subnet if var.enable_public_subnet && split("_", k)[1] == "public"}

  subnet_id = each.value.id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table" "k8s_cni" {
  vpc_id = local.vpc_id

  tags = merge(
    { 
      "Name" = format("%s-k8s_cni-rt", var.vpc_name)
      "net:type" = "k8s_cni"
    },
    local.common_tags,
  )
}

resource "aws_route_table_association" "k8s_cni" {
  for_each = {for k, subnet in aws_subnet.k8s_cni : k => subnet if split("_", k)[2] == "k8s-cni"}

  subnet_id = each.value.id
  route_table_id = aws_route_table.k8s_cni.id
}