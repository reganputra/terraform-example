provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}

module "ec2_instance" {
  source        = "./modules/ec2-instance"
  instance_type = var.instance_type
}

