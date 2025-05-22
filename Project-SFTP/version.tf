# Required Terraform Version
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = ""
    key    = "state"
    region = "us-east-1"
  }
}