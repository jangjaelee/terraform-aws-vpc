# Amazon VPC Terraform module

Terraform module which creates VPC resources on AWS.

These types of resources are supported:

* [VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
* [Subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet):
  * Public, Private, EKS
* [Route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)
* [Route table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)
* [Internet Gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)
* [Network ACL](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl)
* [Default Network ACL](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl)
* [VPC Endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint):
  * Gateway: S3, DynamoDB


## Usage
### Create VPC

main.tf
```hcl
module "kubesphere_vpc" {
  source = "git@github.com:jangjaelee/terraform-aws-vpc.git"

  vpc_id       = ""
  vpc_name     = local.vpc_name
  cluster_name = local.cluster_name
  igw_name     = local.vpc_name

  vpc_cidr     = "10.1.0.0/17"
  k8s_cni_cidr = "10.1.128.0/17"
  
  az_zone_names = ["ap-northeast-2a","ap-northeast-2b","ap-northeast-2c","ap-northeast-2d"]

  enable_sub_env   = false
  
  private_sub_env1 = "1"
  private_sub_env2 = "2"
  public_sub_env1  = "1"
  public_sub_env2  = "2"
  
  account_id = var.account_id
  bucket     = "kubesphere-vpc-flowlogs"
  create_flowlogs_s3        = false
  flowlogs_traffic_type     = "ACCEPT"
  flowlogs_destination_type = "s3"
  logging_bucket_prefix     = "vpc-flowlog-dev/"
  #kms_arn_s3                = "arn:aws:kms:ap-northeast-2:123456789012:key/value"
  
  env = "dev"
}
```

locals.tf
```hcl
locals {
  vpc_name = "KubeSphere-dev"
  cluster_name = "KubeSphere-v121-dev"
  cluster_version = "1.21"
}
```

providers.tf
```hcl
provider "aws" {
  version = ">= 3.2.0"
  region = var.region
  allowed_account_ids = var.account_id
  profile = "eks_service"
}
```

terraform.tf
```hcl
terraform {
  required_version = ">= 0.13.0"

  backend "s3" {
    bucket = "kubesphere-terraform-state-backend"
    key = "kubesphere/vpc/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "kubesphere-terraform-state-locks"
    encrypt = true
    profile = "eks_service"
  }
}
```

variables.tf
```hcl
variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-northeast-2"
}

variable "account_id" {
  description = "List of Allowed AWS account IDs"
  type        = list(string)
  default     = ["123456789012"]
}
```
