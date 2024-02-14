variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "bucket_name" {
  description = "The name for the S3 bucket to store Terraform state"
  type        = string
}

variable "environment" {
  description = "The environment for which infrastructure is being provisioned"
  type        = string
}

variable "dynamodb_table" {
  description = "The name for the DynamoDB table used for state locking"
  type        = string
}

variable "gh_token" {
  description = "The name for the DynamoDB table used for state locking"
  type        = string
}
