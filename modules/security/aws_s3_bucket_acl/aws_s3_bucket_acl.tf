# ========================================================== #
# プロバイダ設定(AWS)
# ========================================================== #
provider "aws" {
  region = var.u_region
}

# ========================================================== #
#   2.2. S3バケットACL作成
# ========================================================== #
resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = var.u_s3_bucket_id
  acl    = var.u_s3_acl
}