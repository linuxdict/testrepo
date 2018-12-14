terraform {
  backend "s3" {
    bucket = "linuxdict-tf-state"
    key    = "tfstate"
    region = "us-west-2"
  }
}
