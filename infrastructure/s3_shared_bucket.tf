#######################################################
#          Creates shared bucket for WOS              #
#      access to root wos-dev and wos-prod            #
#        enforces sse AES256 encryption               #
#       acl string enforced to PUT action             # 
#######################################################

variable user               { }
variable app                { }
variable aws_wos_dev        { }
variable aws_wos_prod       { }
variable bucket_policy_tmpl { }

resource "aws_s3_bucket" "build-tools" {
    bucket = "clarivate.${var.app}.${var.env}.${var.region}.build-tools" 
    acl = "private"
    force_destroy = true
    tags {

        Owner       = "WOS-DevOps"
        Environment = "${var.env}"
        User        = "${var.user}"
    }
}

data "template_file" "bucket_policy" {
  template = "${ file( "${ var.bucket_policy_tmpl }" ) }"
  vars {
    bucket_name      = "${aws_s3_bucket.build-tools.id}"
    aws_account_dev  = "${var.aws_wos_dev}"
    aws_account_prod = "${var.aws_wos_prod}"
  }
}

resource "aws_s3_bucket_policy" "shared-bucket" {
  bucket = "${aws_s3_bucket.build-tools.id}"
  policy = "${data.template_file.bucket_policy.rendered}"
}

output "build-tools-bucket" {
    value = "${aws_s3_bucket.build-tools.id}"
}