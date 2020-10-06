# TODO: Define the output variable for the lambda function.
output "output_lambda" {
  value = "${aws_lambda_function.greet_lambda.qualified_arn}"
}