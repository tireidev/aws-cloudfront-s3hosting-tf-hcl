# ========================================================== #
# プロバイダ設定(AWS)
# ========================================================== #
provider "aws" {
  region = var.u_region
}

# ========================================================== #
#   4.3. Route53 証明書ドメイン確認
# ========================================================== #
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in var.u_domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
  type = each.value.type
  ttl = "300"

  # レコードを追加するドメインのホストゾーンIDを指定
  zone_id = var.u_zone_id
}