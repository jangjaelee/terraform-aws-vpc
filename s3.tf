resource "aws_s3_bucket" "s3_flow" {
  count  = var.create_flowlogs_s3 ? 1 : 0
  
  bucket = var.bucket
  acl    = var.s3_acl
  
  lifecycle {
  	prevent_destroy = false
  }
  
  versioning {
  	enabled = true
  }
  
  logging {
    target_bucket = var.logging_bucket
    target_prefix = var.logging_bucket_prefix
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_arn_s3
        sse_algorithm = "aws:kms"
      }
    }
  }

  force_destroy = true
  
  tags = merge(
    {
      "Name" = format("%s-s3", var.bucket)
      "kubernetes.io/cluster/${var.vpc_name}" = "shared"
    },
    local.common_tags,
    var.vpc_tags,
  )  
}

/*resource "aws_s3_bucket_policy" "s3_flow" {
  bucket = var.bucket
  
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.account_id[0]}:root"
            },
            "Action": "s3:Get*",
            "Resource": "arn:aws:s3:::${var.bucket}/*"
        },
        {
            "Effect": "Deny",
            "Principal": "*",
            "Action": "*",
            "Resource": "arn:aws:s3:::${var.bucket}/*",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
POLICY
}*/

resource "aws_s3_account_public_access_block" "s3_flow" {
  count  = var.create_flowlogs_s3 ? 1 : 0

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
  
  depends_on = [
    aws_s3_bucket.s3_flow,
  ]  
}

resource "aws_s3_bucket_public_access_block" "s3_flow" {
  count  = var.create_flowlogs_s3 ? 1 : 0

  bucket = var.bucket

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
  
  depends_on = [
    aws_s3_bucket.s3_flow,
  ]  
}
