provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}

resource "aws_lambda_function" "lambdaFunction" {
    filename = var.archive_name
    function_name = "lambdaFunction"
    role = aws_iam_role.asssume_role.arn
    handler = "greet_lambda.lambda_handler"
    source_code_hash = data.archive_file.archived.output_base64sha256
    runtime = "python3.8"
    depends_on = [aws_iam_role_policy_attachment.role_logs]
    environment {
        variables = {
            greeting = "Hi peter!"
        }
    }
}

resource "aws_iam_role" "asssume_role" {
    name = "asssume_role"
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

resource "aws_iam_role_policy_attachment" "role_logs" {
  role       = aws_iam_role.asssume_role.name
  policy_arn = aws_iam_policy.logging.arn
}

resource "aws_iam_policy" "logging" {
  name        = "logging"
  path        = "/"
  description = "Logging policy for lambda"

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

data "archive_file" "archived" {
    type        = "zip"
    source_file = "greet_lambda.py"
    output_path = var.archive_name
}