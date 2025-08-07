locals {
  region          = "ap-southeast-1"
  name            = "fastcampus-cluster"
  vpc_cidr        = "10.123.0.0/16"
  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  public_subnets  = ["10.123.1.0/24", "10.123.2.0/24", "10.123.3.0/24"]
  private_subnets = ["10.123.4.0/24", "10.123.5.0/24", "10.123.6.0/24"]
  tags = {
    cluster = local.name
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Using a compatible version for EKS module 19.15.1
    }
  }

  backend "s3" {
    bucket         = "terraform-state-production-2025817"
    key            = "terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-state-production-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-southeast-1"
}
