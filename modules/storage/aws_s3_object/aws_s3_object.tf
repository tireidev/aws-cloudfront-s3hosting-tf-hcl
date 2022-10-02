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

  # オブジェクト名を記載します。ホスティングするためindex.htmlと記載しております。
  key    = var.u_object_key_name #"index.html"

  # オブジェクトのソース元を記載します。ファイルパスは任意で設定下さい。
  source = var.u_object_source # "C:/test/index.html"

  # ホスティングするため、Content-Typeを「text/html」にしております。こちらを変更しないとホスティングに失敗します。
  content_type = var.u_contect_type # "text/html" 
}