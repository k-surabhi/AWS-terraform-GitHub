provider "aws" {
  region     = "eu-west-1"
}


resource "aws_instance" "devops" {
  ami           = "ami-0766b4b472db7e3b9"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}