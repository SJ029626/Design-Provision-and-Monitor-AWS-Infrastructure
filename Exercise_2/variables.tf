# TODO: Define the variable for aws_region
variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

variable "runtime" {
  default = "python3.8"
}