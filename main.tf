# ========================================================== #
# [処理名]
# メイン処理
# 
# [概要]
# S3にWebサービスをホスティングし、CloudFront経由で独自ドメインによるアクセスを行う方法。
# 
# [手順]
# 1. ストレージ作成
#   1.1. S3バケット作成
#   1.2. S3バケットオブジェクト作成
# 2. セキュリティ設定
#   2.1. S3バケットパブリックアクセスブロック設定
#   2.2. S3バケットACL作成
#   2.3. S3バケットポリシー用のIAMポリシー作成
#   2.4. S3バケットポリシー作成 (IAMポリシーとのマッピング)
#   2.5. CloudFront OAI作成
# 3. S3ホスティング設定
#   3.1. S3ホスティング
# 4. DNS設定
#   4.1. ホストゾーン作成
#   4.2. 証明書作成
#   4.3. Route53 証明書ドメイン確認
# 5. コンテンツ配信
#   5.1. クラウドフロントディストリビューション作成
# ========================================================== #

# ========================================================== #
# 1. ストレージ作成
# ========================================================== #
#   1.1. S3バケット作成
# ========================================================== #
module "aws_s3_bucket" {
  source        = "./modules/storage/aws_s3_bucket"
  u_region = var.u_region_ap_northeast_1
  u_domain_name = var.u_domain_name
  u_env         = var.u_env
}

# ========================================================== #
#   1.2. S3バケットオブジェクト作成
# ========================================================== #
module "aws_s3_object" {
  source            = "./modules/storage/aws_s3_object"
  u_region = var.u_region_ap_northeast_1
  u_s3_bucket_id    = module.aws_s3_bucket.id
  u_object_key_name = var.u_object_key_name
  u_object_source   = var.u_object_source
  u_contect_type    = var.u_contect_type
}

# ========================================================== #
# 2. セキュリティ設定
# ========================================================== #
#   2.1. S3バケットパブリックアクセスブロック設定
# ========================================================== #
module "aws_s3_bucket_public_access_block" {
  source         = "./modules/security/aws_s3_bucket_public_access_block"
  u_region = var.u_region_ap_northeast_1
  u_s3_bucket_id = module.aws_s3_bucket.id
}

# ========================================================== #
#   2.2. S3バケットACL作成
# ========================================================== #
module "aws_s3_bucket_acl" {
  source         = "./modules/security/aws_s3_bucket_acl"
  u_region = var.u_region_ap_northeast_1
  u_s3_bucket_id = module.aws_s3_bucket.id
  u_s3_acl       = var.u_s3_acl
}

# ========================================================== #
#   2.3. S3バケットポリシー用のIAMポリシー作成
# ========================================================== #
module "aws_iam_policy_document" {
  source              = "./modules/security/aws_iam_policy_document"
  u_region = var.u_region_ap_northeast_1
  u_s3_bucket_arn     = module.aws_s3_bucket.arn
  u_cloudfront_iam_arn = module.aws_cloudfront_origin_access_identity.iam_arn
}

# ========================================================== #
#  2.4. S3バケットポリシー作成 (IAMポリシーとのマッピング)
# ========================================================== #
module "aws_s3_bucket_policy" {
  source             = "./modules/security/aws_s3_bucket_policy"
  u_region = var.u_region_ap_northeast_1
  u_s3_bucket_id     = module.aws_s3_bucket.id
  u_s3_bucket_policy = module.aws_iam_policy_document.json
}

# ========================================================== #
#   2.5. CloudFront OAI作成
# ========================================================== #
module "aws_cloudfront_origin_access_identity" {
  source = "./modules/security/aws_cloudfront_origin_access_identity"
  u_region = var.u_region_ap_northeast_1
}

# ========================================================== #
# 3. S3ホスティング設定
# ========================================================== #
#   3.1. S3ホスティング
# ========================================================== #
module "aws_s3_bucket_website_configuration" {
  source         = "./modules/storage/aws_s3_bucket_website_configuration"
  u_region = var.u_region_ap_northeast_1
  u_s3_bucket_id = module.aws_s3_bucket.id
}


# ========================================================== #
# 4. DNS設定
# ========================================================== #
#   4.1. ホストゾーン作成
# ========================================================== #
module "aws_route53_zone" {
  source        = "./modules/network/aws_route53_zone"
  u_region = var.u_region_ap_northeast_1
  u_domain_name = var.u_domain_name 
}

# ========================================================== #
#   4.2. 証明書作成
# ========================================================== #
module "aws_acm_certificate" {
  source        = "./modules/security/aws_acm_certificate"
  u_region = var.u_region_us_east_1
}

# ========================================================== #
#   4.3. Route53 証明書ドメイン確認
# ========================================================== #
module "aws_route53_record" {
  source                = "./modules/network/aws_route53_record"
  u_region = var.u_region_ap_northeast_1
  u_zone_id             = module.aws_route53_zone.zone_id
  u_domain_validation_options = module.aws_acm_certificate.domain_validation_options
}

# ========================================================== #
# 5. コンテンツ配信
# ========================================================== #
#   5.1. クラウドフロントディストリビューション作成
# ========================================================== #
module "aws_cloudfront_distribution" {
  source = "./modules/network/aws_cloudfront_distribution"
  u_region = var.u_region_ap_northeast_1
  u_bucket_regional_domain_name = module.aws_s3_bucket.bucket_regional_domain_name
  u_s3_bucket_id = module.aws_s3_bucket.id
  u_cloudfront_access_identity_path = module.aws_cloudfront_origin_access_identity.cloudfront_access_identity_path
  u_acm_certificate_arn = module.aws_acm_certificate.arn
}