# module "lambda" {
#   source = "../../modules/lambda"
# }

# create two S3 buckets
resource "aws_s3_bucket" "buckets" {
  for_each = {
    origin    = var.s3_origin
    thumbnail = var.s3_thumbnail
  }
  bucket = each.value
  tags   = var.dev_tag
  #ts:skip=AWS.S3Bucket.IAM.High.0370 Still get Violated policy even s3 bucket versioning is enabled # Severity: HIGH.
  # Refer: https://github.com/tenable/terrascan/issues/1603
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_versioning" "enable_versioning" {
  for_each = aws_s3_bucket.buckets
  bucket   = each.value.id
  versioning_configuration {
    status = "Enabled"
  }
}
# create dynamodb table
resource "aws_dynamodb_table" "thumbnail" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "thumbnail_object"
  attribute {
    name = "thumbnail_object"
    type = "S"
  }
}

# create a policy to allow the lambda function to get and put object in the S3 bucket
resource "aws_iam_policy" "lambda_access_s3" {
  name        = "lambda_access_s3"
  description = "Allow lambda to get and put object in the S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream"
        ],
        "Resource" : "arn:aws:logs:*:*:*"
      },
      {
        "Action" : [
          "s3:GetObject"
        ],
        "Effect"   = "Allow"
        "Resource" = "arn:aws:s3:::${var.s3_origin}/*"
      },
      {
        "Action" : [
          "s3:PutObject"
        ],
        "Effect"   = "Allow"
        "Resource" = "arn:aws:s3:::${var.s3_thumbnail}/*"
      },
      {
        "Action" : [
          "dynamodb:PutItem"
        ],
        "Effect"   = "Allow"
        "Resource" = aws_dynamodb_table.thumbnail.arn
      }
    ]
  })
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# attach the policy to the lambda role
resource "aws_iam_policy_attachment" "lambda_access_s3" {
  name       = "lambda_access_s3"
  policy_arn = aws_iam_policy.lambda_access_s3.arn
  # roles      = module.lambda.lambda_role
  roles = [aws_iam_role.iam_for_lambda.name]
}

# create a lambda function
resource "aws_lambda_function" "lambda" {
  function_name    = "thumbnail"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "lambda.lambda_handler"
  runtime          = "python${var.python_version}"
  architectures    = ["arm64"]
  filename         = "${path.cwd}/../../../${var.lambda_file}"
  source_code_hash = filebase64sha256("${path.cwd}/../../../${var.lambda_file}")
  timeout          = 30
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.s3_origin}"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.s3_origin
  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".jpg"
  }
  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".png"
  }
  depends_on = [aws_lambda_permission.allow_bucket]
}
