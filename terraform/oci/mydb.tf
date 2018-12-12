#variable db_system_availability_domain {}
variable db_system_database_edition {
  default = "ENTERPRISE_EDITION"
}

variable db_system_db_home_database_admin_password {
  default = "not-steal-mypass"
}

variable db_system_db_home_database_backup_tde_password {
  default = "not-steal-mypass"
}

#variable db_system_db_home_database_character_set {}
#variable db_system_db_home_database_db_backup_config_auto_backup_enabled {}

variable db_system_db_home_database_db_name {
  default = "myldora"
}

variable db_system_db_home_database_db_workload {
  default = "OLTP"
}

#variable db_system_db_home_database_defined_tags {}
#variable db_system_db_home_database_freeform_tags {}
#variable db_system_db_home_database_ncharacter_set {}
#variable db_system_db_home_database_pdb_name {}
#variable db_system_db_home_db_version {}
#variable db_system_db_home_display_name {}

variable db_system_hostname {
  default = "mydb"
}

variable db_system_shape {
  default = "VM.Standard2.1"

  #  default = "BM.DenseIO1.36"
}

variable db_system_ssh_public_keys {
  default = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHsgwV2rO4hvhqKjdiMEh/KOpCaHKwY/UdADED6RPni6KOarYvRoQfA30MT1Zd+ql7a9RLOe2pfASflVoFrhzanRnv8Y6m3hfbfY/ijpsrs4fhu7pU5KznZpQv0pr1ohNsiy9rQ3sALWtCW1zk9EWkIAb1xFGFAoZHY5emuOfMpOtckTjvNm97xTrZ51d/3y5LbaIdMXAtkY6feU7eCsQme/F5mo6vPTgRdu3+sy3ktAAGr3Enhwho+5v797LYodMIsNMjUnueHYelxUB9xC/LazIr4gl2jUaT0aS9OlU9Gn9p1uO2+g+ERGoSMYhuGBsc+sWw4qVB9GctLwwNUw/d hmsrv1"]
}

#variable db_system_cluster_name {}
variable db_system_cpu_core_count {
  default = 1
}

#variable db_system_data_storage_percentage {}
variable db_system_data_storage_size_in_gb {
  default = 256
}

#variable db_system_disk_redundancy {}
#variable db_system_display_name {}
#variable db_system_domain {}
#variable db_system_license_model {}
#variable db_system_node_count {}
#variable db_system_source {}

resource "oci_database_db_system" "my_ora_db" {
  #Required
  availability_domain = "${oci_core_subnet.subnet1.availability_domain}"
  compartment_id      = "${var.compartment_id}"

  database_edition = "${var.db_system_database_edition}"

  db_home {
    #Required
    database {
      #Required
      admin_password = "${var.db_system_db_home_database_admin_password}"

      #Optional
      #      backup_id           = "${oci_database_backup.test_backup.id}"
      #backup_tde_password = "${var.db_system_db_home_database_backup_tde_password}"

      character_set = "AL32UTF8"
      db_backup_config {
        auto_backup_enabled = false
      }
      db_name     = "${var.db_system_db_home_database_db_name}"
      db_workload = "${var.db_system_db_home_database_db_workload}"

      #defined_tags   = "${var.db_system_db_home_database_defined_tags}"
      #freeform_tags  = "${var.db_system_db_home_database_freeform_tags}"
      #ncharacter_set = "${var.db_system_db_home_database_ncharacter_set}"
      #pdb_name       = "${var.db_system_db_home_database_pdb_name}"
    }

    #Optional
    db_version = "11.2.0.4"

    display_name = "mytestdb"
  }

  hostname = "${var.db_system_hostname}"

  #	domain = ""
  shape           = "${var.db_system_shape}"
  ssh_public_keys = "${var.db_system_ssh_public_keys}"
  subnet_id       = "${oci_core_subnet.subnet1.id}"

  #Optional
  #  backup_subnet_id        = "${oci_database_backup_subnet.test_backup_subnet.id}"
  #  cluster_name = "${var.db_system_cluster_name}"

  cpu_core_count = "${var.db_system_cpu_core_count}"
  #  data_storage_percentage = "${var.db_system_data_storage_percentage}"
  data_storage_size_in_gb = "${var.db_system_data_storage_size_in_gb}"

  #  defined_tags = {
  #    "Operations.CostCenter" = "42"
  #  }

  #  disk_redundancy = "${var.db_system_disk_redundancy}"
  #  display_name    = "${var.db_system_display_name}"
  #  domain          = "${var.db_system_domain}"
  freeform_tags = {
    "Department" = "Finance"
  }
  #license_model = "LICENSE_INCLUDED"
  node_count = 1
  source     = "NONE"
}
