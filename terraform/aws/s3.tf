resource "aws_s3_bucket" "tstate" {
  bucket = "${var.s3b4tf}"
  acl    = "private"

  region = "${var.region["region1"]}"

  versioning {
    enabled = true
  }

  # expire the old object version
  lifecycle_rule {
    prefix  = "/"
    enabled = true

    noncurrent_version_expiration {
      days = 7
    }
  }

  tags {
    Name  = "TerraformStateFile"
    Usage = "Used by Terraform for State file"
  }
}
