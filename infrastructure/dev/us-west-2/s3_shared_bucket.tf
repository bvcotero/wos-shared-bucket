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
variable snapshots_prefix   { }
variable bucket_policy_tmpl { }

data "template_file" "bucket_policy" {
  template = "${ file( "${ var.bucket_policy_tmpl }" ) }"
  vars {
    bucket_name      = "${aws_s3_bucket.build-tools.id}"
    aws_account_dev  = "${var.aws_wos_dev}"
    aws_account_prod = "${var.aws_wos_prod}"
  }
}

resource "aws_s3_bucket" "build-tools" {
  bucket = "clarivate.${var.app}.${var.env}.${var.region}.build-tools" 
  acl = "private"
  force_destroy = true

  lifecycle_rule {
    id      = "snapshots"
    prefix  = "${var.snapshots_prefix}"
    enabled = true

    tags {
      "rule"       = "snapshots"
      "clean_days" = "14-days"
    }

    expiration {
      days = 14
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags {
    Owner       = "WOS-DevOps"
    Environment = "${terraform.workspace}"
    User        = "${var.user}"
  }
}

resource "aws_s3_bucket_policy" "shared-bucket" {
  bucket = "${aws_s3_bucket.build-tools.id}"
  policy = "${data.template_file.bucket_policy.rendered}"
}

output "build-tools-bucket" {
    value = "${aws_s3_bucket.build-tools.id}"
}
