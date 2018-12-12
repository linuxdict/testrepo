variable aws_access_key {}
variable aws_secret_key {}
variable subnet_id {}

variable availability_zone {
  type = "map"
}
variable key_name {}
variable vpc_security_group_ids {
  type = "list"
}
variable region {
  type = "map"
}
variable associate_public_ip_address {}
variable s3b4tf {
  default = "linuxdict-tf-state"
}

# cloudflare var
variable cloudflare_email {}
variable cloudflare_token {}
variable cloudflare_zone {}
