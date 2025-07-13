# variable "ami_id" {
#   type        = string
#   description = "AMI ID for EC2 instance"
# }

variable "instance_type" {
  type        = string
  default     = "t2.micro"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
}
