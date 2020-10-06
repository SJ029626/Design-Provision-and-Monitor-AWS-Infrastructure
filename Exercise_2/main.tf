#Intitalize Credentials
provider "aws" {
  access_key = ""
  secret_key = ""
  region = "us-east-1"
}

data "archive_file" "lambda" {
  type        = "zip"
  output_path = "greet_lambda.zip"
  source_file = "greet_lambda.py"
}

resource "aws_iam_role" "iam_lambda" {
  name = "iam_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_log" {
  name        = "lambda_log"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "policy_lambda" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_cloudwatch_log_group" "lambda_policy_cloudwatch" {
  name              = "/aws/lambda/greet_lambda"
  retention_in_days = 14
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.iam_lambda.name
  policy_arn = aws_iam_policy.lambda_log.arn
}

resource "aws_lambda_function" "greet_lambda" {
  filename         = "greet_lambda.zip"
  function_name    = "greet_lambda"
  role       = aws_iam_role.iam_lambda.arn
  handler          = "greet_lambda.lambda_handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  depends_on       = [aws_cloudwatch_log_group.lambda_policy_cloudwatch]

  runtime = var.runtime
  environment {
    variables = {
      greeting = "Hello, World!"
    }
  }
}