provider "aws" {
  region = "us-east-1"
}

# Import EC2 ARN from remote state
data "terraform_remote_state" "ec2" {
  backend = "s3"
  config = {
    bucket = "samiksha-bucket-tf-state-03" # same as EC2 backend bucket
    key    = "ec2/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_s3_bucket" "samiksha_bucket" {
  bucket = var.bucket_name
  # fake change for tfsec test
  force_destroy = true
  tags = {
    Name = "samiksha-s3-bucket-read-write-ec2"
  }
}

resource "aws_s3_bucket_policy" "samiksha_policy" {
  bucket = aws_s3_bucket.samiksha_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EC2RoleCanPut"
        Effect = "Allow"
        Principal = {
          AWS = data.terraform_remote_state.ec2.outputs.ec2_instance_role_arn
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.samiksha_bucket.arn}/*"
      }
    ]
  })
}
