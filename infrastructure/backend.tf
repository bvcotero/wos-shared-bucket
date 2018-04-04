################################################
#            CONFIGURE REMOTE STATE            #
################################################

terraform {
  backend "s3"  {
    bucket  = "clarivate-wos-dev-terraform-state"
    key     = "env:/global/dev/s3-shared-bucket/terraform.tfstate"
    region  = "us-east-1"
    profile = "wos-dev"
  }
}

