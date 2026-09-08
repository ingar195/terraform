bucket = "tf-state"
key    = "fleet/terraform.tfstate"
region = "us-east-1"

endpoints = {
  s3 = "http://10.11.0.50:9000"
}

skip_credentials_validation = true
skip_metadata_api_check     = true
skip_region_validation      = true
skip_requesting_account_id  = true
use_path_style              = true
