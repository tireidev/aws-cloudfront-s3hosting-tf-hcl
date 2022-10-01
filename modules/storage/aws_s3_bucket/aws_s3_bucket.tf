# ========================================================== #
# プロバイダ設定(AWS)
# ========================================================== #
provider "aws" {
  region = var.u_region
}

# ========================================================== #
#   1.1. S3バケット作成
# ========================================================== #
resource "aws_s3_bucket" "s3_bucket" {
  # バケット名は独自ドメイン名と同じにしないとS3ホスティングが出来ない点に注意。
  bucket = var.u_domain_name  

  tags = {
    Name        = var.u_domain_name 
    Environment = var.u_env 
  }
}

output "id" {
  value       = "${aws_s3_bucket.s3_bucket.id}"
}

output "arn" {
  value       = "${aws_s3_bucket.s3_bucket.arn}"
}

output "hosted_zone_id" {
  value       = "${aws_s3_bucket.s3_bucket.hosted_zone_id}"
}

output "bucket_regional_domain_name" {
  value       = "${aws_s3_bucket.s3_bucket.bucket_regional_domain_name}"
}

