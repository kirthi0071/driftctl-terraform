# Backend Configuration - S3 + DynamoDB Lock
# Update the bucket name with YOUR AWS account ID

terraform {
  backend "s3" {
    bucket         = "kirthi-s3-backend-990723917397"
    key            = "drift-demo/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "kirthi-terraform-locks"
  }
}
