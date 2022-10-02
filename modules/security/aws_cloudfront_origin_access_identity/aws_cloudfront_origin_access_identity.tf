# ========================================================== #
# プロバイダ設定(AWS)
# ========================================================== #
provider "aws" {
  region = var.u_region
}

# ========================================================== #
#   2.5. CloudFront OAI作成
# ========================================================== #
resource "aws_cloudfront_origin_access_identity" "static_web" {}

output "iam_arn" {
    value = aws_cloudfront_origin_access_identity.static_web.iam_arn
}

output "cloudfront_access_identity_path" {
    value = aws_cloudfront_origin_access_identity.static_web.cloudfront_access_identity_path
}