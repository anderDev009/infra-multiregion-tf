terraform {
  backend "s3" {
    bucket = "infra-multiregion"
    key    = "tf/terraform.tfstate"
    region = "us-east-1"
    endpoints = {
      s3       = "http://192.168.1.101:4566"
      dynamodb = "http://192.168.1.101:4566"
      iam      = "http://192.168.1.101:4566"
      sso      = "http://192.168.1.101:4566"
      sts      = "http://192.168.1.101:4566"
    }
    encrypt                     = false
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    access_key                  = "test"
    secret_key                  = "test"
    use_path_style              = true
  }
}