<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.63.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.63.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.thumbnail](https://registry.terraform.io/providers/hashicorp/aws/5.63.0/docs/resources/dynamodb_table) | resource |
| [aws_iam_policy.lambda_access_s3](https://registry.terraform.io/providers/hashicorp/aws/5.63.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.lambda_access_s3](https://registry.terraform.io/providers/hashicorp/aws/5.63.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.iam_for_lambda](https://registry.terraform.io/providers/hashicorp/aws/5.63.0/docs/resources/iam_role) | resource |
| [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/5.63.0/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_bucket](https://registry.terraform.io/providers/hashicorp/aws/5.63.0/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.buckets](https://registry.terraform.io/providers/hashicorp/aws/5.63.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/5.63.0/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_versioning.enable_versioning](https://registry.terraform.io/providers/hashicorp/aws/5.63.0/docs/resources/s3_bucket_versioning) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/5.63.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-west-2"` | no |
| <a name="input_dev_tag"></a> [dev\_tag](#input\_dev\_tag) | Tag for the Dev environment | `map(string)` | <pre>{<br>  "Environment": "Dev",<br>  "Name": "Environment"<br>}</pre> | no |
| <a name="input_dynamodb_table_name"></a> [dynamodb\_table\_name](#input\_dynamodb\_table\_name) | DynamoDB table name | `string` | `"thumbnail"` | no |
| <a name="input_lambda_file"></a> [lambda\_file](#input\_lambda\_file) | Lambda zip file | `string` | `"lambda.zip"` | no |
| <a name="input_python_version"></a> [python\_version](#input\_python\_version) | Python version | `string` | `"3.8"` | no |
| <a name="input_s3_origin"></a> [s3\_origin](#input\_s3\_origin) | S3 bucket name | `string` | `"origin"` | no |
| <a name="input_s3_thumbnail"></a> [s3\_thumbnail](#input\_s3\_thumbnail) | S3 bucket name | `string` | `"thumbnail"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
<!-- markdownlint-restore -->