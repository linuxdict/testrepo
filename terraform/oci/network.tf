variable vcn_cidr_block {}
variable vcn_display_name {}
variable vcn_dns_label {}

variable subnet_availability_domain {}

#variable subnet_security_list_ids {}
variable subnet_display_name {}

variable subnet_dns_label {}

#variable subnet_prohibit_public_ip_on_vnic {}

resource "oci_core_vcn" "ld_vcn" {
  #Required
  cidr_block     = "${var.vcn_cidr_block}"
  compartment_id = "${var.compartment_id}"

  #Optional
  #  defined_tags = {
  #    "Operations.CostCenter" = "42"
  #  }

  display_name = "${var.vcn_display_name}"
  dns_label    = "${var.vcn_dns_label}"
  freeform_tags = {
    "Department" = "R&D"
  }
}

resource "oci_core_subnet" "subnet1" {
  #Required
  availability_domain = "${var.subnet_availability_domain}"

  #  cidr_block          = "${oci_core_vcn.ld_vcn.cidr_block}"
  cidr_block = "${cidrsubnet(oci_core_vcn.ld_vcn.cidr_block, 3, 1)}"

  compartment_id = "${var.compartment_id}"

  #  security_list_ids   = "${var.subnet_security_list_ids}"
  vcn_id = "${oci_core_vcn.ld_vcn.id}"

  #Optional

  #  dhcp_options_id = "${oci_core_dhcp_options.test_dhcp_options.id}"
  display_name = "${var.subnet_display_name}"
  dns_label    = "${var.subnet_dns_label}"
  freeform_tags = {
    "Department" = "R&D"
  }

  #  prohibit_public_ip_on_vnic = "${var.subnet_prohibit_public_ip_on_vnic}"
  #  route_table_id             = "${oci_core_route_table.test_route_table.id}"
}
