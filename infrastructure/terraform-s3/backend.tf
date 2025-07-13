terraform {
  backend "s3" {
    bucket = "samiksha-bucket-tf-state-03"
    key    = "s3/terraform.tfstate"
    region = "us-east-1"
  }
}
