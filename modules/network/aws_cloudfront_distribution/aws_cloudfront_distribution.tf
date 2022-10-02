# ========================================================== #
# プロバイダ設定(AWS)
# ========================================================== #
provider "aws" {
  region = var.u_region
}

# ========================================================== #
#   5.1. クラウドフロントディストリビューション作成
# ========================================================== #
resource "aws_cloudfront_distribution" "static-www" {
  origin {
    domain_name = var.u_bucket_regional_domain_name
    origin_id   = var.u_s3_bucket_id
    s3_origin_config {
      origin_access_identity = var.u_cloudfront_access_identity_path
    }
  }

  enabled = true

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.u_s3_bucket_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"]
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
    # acm_certificate_arn      = "${var.u_acm_certificate_arn}"
    # ssl_support_method       = "sni-only"
    # minimum_protocol_version = "TLSv1"
  }
}

output "hosted_zone_id" {
  value = aws_cloudfront_distribution.static-www.hosted_zone_id
}