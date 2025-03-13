resource "random_id" "bucket_suffix" {
  byte_length = 4  # Generates an 8-character hexadecimal string
}

locals {
  bucket_name = "${var.bucket_base_name}-${var.environment}-${random_id.bucket_suffix.hex}"
}

resource "aws_s3_bucket" "main" {
  bucket = local.bucket_name
  tags = {
    Name        = local.bucket_name
    Environment = var.environment
  }
}