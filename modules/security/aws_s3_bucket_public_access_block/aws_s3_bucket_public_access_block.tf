# ========================================================== #
# プロバイダ設定(AWS)
# ========================================================== #
provider "aws" {
  region = var.u_region
}

# ========================================================== #
#   2.1. S3バケットパブリックアクセスブロック設定
# ========================================================== #
resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket = var.u_s3_bucket_id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}