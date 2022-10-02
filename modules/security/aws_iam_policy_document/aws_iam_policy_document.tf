# ========================================================== #
# プロバイダ設定(AWS)
# ========================================================== #
provider "aws" {
  region = var.u_region
}

# ========================================================== #
#   2.3. S3バケットポリシー用のIAMポリシー作成
# ========================================================== #
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["${var.u_cloudfront_iam_arn}"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      var.u_s3_bucket_arn,
      "${var.u_s3_bucket_arn}/*",
    ]
  }
}

output "json" {
  value       = data.aws_iam_policy_document.s3_bucket_policy.json
}