# variables for instance
variable "aws_access_key"{
    default = "AKIA47D7MJI37JT4BO7I"
}
variable "aws_secret_key"{
    default = "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"
}
variable "region" {
  default = "ap-south-1"
}

variable "ami.id" {
  default = "sg-0fe6c5fd56c0db9de"
}
variable "instance_type" {
  default = "t2.micro"
}

variable "max_size" {
  default = "3"
}

variable "min_size" {
  default = "1"
}
variable "health_check_grace_period" {
  default = "100"
}
variable "desired_capacity" {
  default = "4"
}
variable "force_delete" {
    type = bool
  default = "true"
}
variable "scaling_adjustment" {
  default = "1"
}
variable "adjustment_type" {
  default = "ChangeInCapacity"
}
variable "cooldown" {
  default = "60"
}