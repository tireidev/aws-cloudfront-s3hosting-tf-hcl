# ========================================================== #
# プロバイダ設定(AWS)
# ========================================================== #
provider "aws" {
  region = var.u_region
}

# ========================================================== #
#   4.2. 証明書作成
# ========================================================== #
resource "aws_acm_certificate" "cert" {
  domain_name               = "cloud-service-study.net"
  validation_method         = "DNS"
}

output "domain_validation_options" {
    value = aws_acm_certificate.cert.domain_validation_options
}

output "arn" {
    value = aws_acm_certificate.cert.arn
}