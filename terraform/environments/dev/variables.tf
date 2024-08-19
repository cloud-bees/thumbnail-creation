variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"
  type        = string
}

variable "dev_tag" {
  description = "Tag for the Dev environment"
  default = {
    Name        = "Environment"
    Environment = "Dev"
  }
  type = map(string)
}

variable "s3_origin" {
  type        = string
  default     = "origin"
  description = "S3 bucket name"
}

variable "s3_thumbnail" {
  type        = string
  default     = "thumbnail"
  description = "S3 bucket name"
}

variable "lambda_file" {
  type        = string
  default     = "lambda.zip"
  description = "Lambda zip file"
}

variable "dynamodb_table_name" {
  type        = string
  default     = "thumbnail"
  description = "DynamoDB table name"
}

variable "python_version" {
  type        = string
  default     = "3.8"
  description = "Python version"

}
