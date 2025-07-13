terraform {
  backend "s3" {
    bucket = "samiksha-bucket-tf-state-03"   # MUST be created manually beforehand
    key    = "ec2/terraform.tfstate"
    region = "us-east-1"
  }
}