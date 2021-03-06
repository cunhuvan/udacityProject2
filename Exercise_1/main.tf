provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "UdacityT2" {
  count = 4
  ami = "ami-0022f774911c1d690"
  instance_type = "t2.micro"
  subnet_id = "subnet-0757c02647e8c0f92"
}

resource "aws_instance" "UdacityM4" {
  count = 2
  ami = "ami-0022f774911c1d690"
  instance_type = "m4.large"
  subnet_id = "subnet-0a4cc392ad829c30a"
}
