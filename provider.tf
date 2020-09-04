provider "aws" {
  region                  = "us-east-1"
  profile                 = "tf-s3"
  shared_credentials_file = "~/.aws/config"
  alias                   = "tf-s3"
}

provider "aws" {
  region                  = "us-east-1"
  profile                 = "tf-route53"
  shared_credentials_file = "~/.aws/config"
  alias                   = "tf-route53"
}

provider "aws" {
  region                  = "us-east-1"
  profile                 = "tf-cloudfront"
  shared_credentials_file = "~/.aws/config"
  alias                   = "tf-cloudfront"
}

provider "aws" {
  region                  = "us-east-1"
  profile                 = "tf-certificatemanager"
  shared_credentials_file = "~/.aws/config"
  alias                   = "tf-certificatemanager"
}

provider "aws" {
  region                  = "us-east-1"
  profile                 = "tf-resource-group"
  shared_credentials_file = "~/.aws/config"
  alias                   = "tf-resource-group"
}

provider "aws" {
  region                  = "us-east-1"
  profile                 = "tf-budget"
  shared_credentials_file = "~/.aws/config"
  alias                   = "tf-budget"
}