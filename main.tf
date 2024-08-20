provider "aws" {
  region = "us-east-1"
}



resource "aws_s3_bucket" "s3_jenkins" {
  bucket = "s3-with-jenkins"
  tags = {
    Name = "s3-with-jenkins"
  }
}