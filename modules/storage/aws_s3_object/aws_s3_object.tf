# ========================================================== #
# プロバイダ設定(AWS)
# ========================================================== #
provider "aws" {
  region = var.u_region
}

# ========================================================== #
#   1.2. S3バケットオブジェクト作成
# ========================================================== #
resource "aws_s3_object" "web" {
  
  bucket = var.u_s3_bucket_id

  # オブジェクト名を記載.ホスティングするためindex.htmlと記載しております。
  key    = var.u_object_key_name_html #"index.html"

  # オブジェクトのソース元を記載
  source = var.u_object_source_html

  # ホスティングするため、Content-Typeを「text/html」にしております。こちらを変更しないとホスティングに失敗します。
  content_type = var.u_contect_type_html # "text/html" 
}

resource "aws_s3_object" "css" {
  
  for_each = fileset(var.u_object_source_css, "**")
  bucket = var.u_s3_bucket_id

  # /cssフォルダ
  key    = "${var.u_object_key_name_css}${each.value}"

  # オブジェクトのソース元を記載
  source = "${var.u_object_source_css}${each.value}" 
}

resource "aws_s3_object" "javascript" {
  
  for_each = fileset(var.u_object_source_js, "**")
  bucket = var.u_s3_bucket_id

  # /jsフォルダ
  key    = "${var.u_object_key_name_js}${each.value}"

  # オブジェクトのソース元を記載
  source = "${var.u_object_source_js}${each.value}"
}