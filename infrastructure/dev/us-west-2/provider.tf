##################################################
#     CONFIGURING AWS ENVIRONMENT ACCOUNT        #
##################################################

variable "region"     { default = "us-west-2" }
variable "env"        { default = "dev" }

provider "aws" {
  region    = "${var.region}"
  profile   = "wos-${var.env}"
}

