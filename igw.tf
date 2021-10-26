# Create Internet Gateway
resource "aws_internet_gateway" "this" {
  count = var.create_igw ? 1 : 0
  
  vpc_id = local.vpc_id

  tags = merge(
    { 
      "Name" = format("%s-igw", var.igw_name)
    },
    local.common_tags,
    var.igw_tags,
  )
}