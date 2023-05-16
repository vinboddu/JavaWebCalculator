# variables for security
variable "aws_access_key"{}
variable "aws_secret_key"{}


# aws provider detailsprovider 
provider "aws" {
  region     = "ap-south-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
