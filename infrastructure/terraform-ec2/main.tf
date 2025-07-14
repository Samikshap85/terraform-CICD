provider "aws" {
  region = "us-east-1"
}

# the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] 
}

# Create IAM role for EC2 to assume
resource "aws_iam_role" "ec2_role" {
  name = "ec2-write-s3-role-samiksha"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach S3 write policy to IAM role
resource "aws_iam_role_policy" "ec2_s3_write_policy" {
  name = "ec2-write-s3-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:PutObject"
      ],
      Resource = "arn:aws:s3:::samiksha-ec2-s3-write-bucket/*"
    }]
  })
}

# Instance profile for EC2 to use the role
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-write-s3-profile"
  role = aws_iam_role.ec2_role.name
}



# Launch EC2 instance with IAM role
resource "aws_instance" "my_ec2" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name    = "Samiksha-ec2"
    Creator = "samikshapaudel"
  }
}

# Temporary change to trigger tfsec commenter
