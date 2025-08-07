# Specify the AWS provider
provider "aws" {
  region = "ap-southeast-1" # Change to your preferred region

  # https://registry.terraform.io/providers/hashicorp/aws/2.70.1/docs#static-credentials
}

# Define the S3 bucket
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "terraform-state-production-2025817" # Replace with your bucket name
  acl    = "private"
  versioning {
    enabled = true
  }

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Production"
  }
}

# # Configure bucket ACL separately
# resource "aws_s3_bucket_acl" "bucket_acl" {
#   bucket = aws_s3_bucket.terraform_state_bucket.id
#   acl    = "private"
# }

# # Configure versioning separately
# resource "aws_s3_bucket_versioning" "bucket_versioning" {
#   bucket = aws_s3_bucket.terraform_state_bucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# Define the DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform-state-production-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform State Lock Table"
    Environment = "Production"
  }
}
