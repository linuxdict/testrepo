resource "aws_s3_bucket" "tstate" {
  bucket = "${var.s3b4tf}"
  acl    = "private"

  region = "${var.region["region1"]}"

  versioning {
    enabled = true
  }

  tags {
    Name  = "TerraformStateFile"
    Usage = "Used by Terraform for State file"
  }
}
