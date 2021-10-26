data "aws_region" "this" {}

resource "aws_vpc_endpoint" "s3" {
  vpc_id = local.vpc_id
  vpc_endpoint_type = "Gateway"
  service_name = "com.amazonaws.${data.aws_region.this.name}.s3"

  route_table_ids = compact([aws_route_table.k8s_cni.id, aws_route_table.private.id, var.enable_public_subnet ? aws_route_table.public[0].id : ""])

  tags = merge(
    {
      "Name" = format("%s-s3-vpce", var.vpc_name)
    },
    local.common_tags,
  )
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id = local.vpc_id
  vpc_endpoint_type = "Gateway"
  service_name = "com.amazonaws.${data.aws_region.this.name}.dynamodb"

  route_table_ids = compact([aws_route_table.k8s_cni.id, aws_route_table.private.id, var.enable_public_subnet ? aws_route_table.public[0].id : ""])

  tags = merge(
    {
      "Name" = format("%s-dynamodb-vpce", var.vpc_name)
    },
    local.common_tags,
  )
}