# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = ""
  secret_key = ""
  region = "us-east-1"
}



# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "Udacity_T2" {
  ami = "ami-085925f297f89fce1"
  instance_type = "t2.micro"
  count = 4
  tags = {
    Name = "Udacity_T2"
  }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "Udacity_M4" {
  ami = "ami-085925f297f89fce1"
  instance_type = "m4.large"
  count = 2
  tags = {
    Name = "Udacity_M4"
  }
}
