/*
resource "aws_flow_log" "cloudwatch_logging" {
  count           = var.create_flowlogs_cloudwatch ? 1 : 0
  traffic_type    = var.flowlogs_traffic_type

  iam_role_arn    = aws_iam_role.example.arn
  log_destination = aws_cloudwatch_log_group.example.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id
}
*/

resource "aws_flow_log" "s3_logging" {
  count                = var.create_flowlogs_s3 ? 1 : 0
  vpc_id               = local.vpc_id
  
	traffic_type         = var.flowlogs_traffic_type
  log_destination      = aws_s3_bucket.s3_flow[count.index].arn
  log_destination_type = var.flowlogs_destination_type

  depends_on = [
    aws_s3_bucket.s3_flow,
  ]
  
  tags = merge(
    {
      "Name" = format("%s-flowlogs", var.vpc_name)
    },
    local.common_tags,
  )  
}