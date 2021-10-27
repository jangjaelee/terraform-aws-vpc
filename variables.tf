variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "The VPC ID."
  type        = string
  default     = ""
}

variable "vpc_name" {
  description = "Name to be used on all the resources as identifier for VPC"
  type        = string
}

variable "cluster_name" {
  description = "Name for EKS Cluster "
  type        = string
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/17"
}

variable "k8s_cni_cidr" {
  description = "CIDR block for k8s CNI"
  type        = string
  default     = "10.0.128.0/17"
}

variable "default_destination" {
  description = "Default route destnation"
  type        = string
  default     = "0.0.0.0/0"
}

variable "az_zone_names" {
  description = "Availability Zone"
  type        = list(string)
  #default     = ["ap-northeast-2a","ap-northeast-2c"]
}

variable "private_subnets_new_bits" {
  description = "Number of additional network prefix bits to add for private subnets"
  type        = number
  default     = 7
}

variable "public_subnets_new_bits" {
  description = "Number of additional network prefix bits to add for public subnets"
  type        = number
  default     = 7
}

variable "k8s_cni_subnets_new_bits" {
  description = "Number of additional network prefix bits to add for k8s cni subnets"
  type        = number
  default     = 5
}

variable "enable_public_subnet" {
  description = "Indicate whether to create public subnet"
  type        = bool
  default     = true
}

variable "enable_sub_env" {
  description = "Indicate whether to enable sub-environment"
  type        = bool
  default     = false
}

variable "private_sub_env1" {
  description = "Private Sub-Environment 1"
  type        = string
  default     = ""
}

variable "public_sub_env1" {
  description = "Public Sub-Environment 1"
  type        = string
  default     = ""
}

variable "private_sub_env2" {
  description = "Private Sub-Environment 2"
  type        = string
  default     = ""
}

variable "public_sub_env2" {
  description = "Public Sub-Environment 2"
  type        = string
  default     = ""
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "create_igw" {
  description = "Controls if an Internet Gateway is created for public subnets and the related routes that connect them."
  type        = bool
  default     = true
}

variable "igw_name" {
  description = "Name of Internet Gateway"
  type        = string
  #default     = ""
}

variable "create_flowlogs_cloudwatch" {
  description = "Controls if VPC Flow Log with CloudWatch should be created"
  type        = bool
  default     = false
}

variable "create_flowlogs_s3" {
  description = "Controls if VPC Flow Log with S3 should be created"
  type        = bool
  default     = false
}

variable "flowlogs_traffic_type" {
  description = "The type of traffic to capture. (Valid values : ACCEPT, REJECT, ALL)"
  type        = string
}

variable "flowlogs_destination_type" {
  description = "The type of the logging destination. Valid values: cloud-watch-logs, s3. (Default: cloud-watch-logs)"
  type        = string
  default     = "cloud-watch-logs"
}

variable "account_id" {
  description = "List of Allowed AWS account IDs"
  type        = list(string)
}

variable "bucket" {
  description = "S3 bucket for VPC Flow logs"
  type        = string
}

variable "s3_acl" {
  description = "ACL of S3 Bucket"
  type        = string
  default     = "private"
}

variable "logging_bucket" {
  description = "Target bucket for Server access logging"
  type        = string
  default     = "bucket-accesslog"
}

variable "logging_bucket_prefix" {
  description = "Target bucket prefix for Server access logging"
  type        = string
}

variable "kms_arn_s3" {
	description = "KMS ARN for S3"
	type        = string
	default     = "arn:aws:kms:ap-northeast-2:123456789012:key/value"
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "igw_tags" {
  description = "Additional tags for the internet gateway"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "env" {
  description = "Environment"
  type = string
}
