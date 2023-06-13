############################################################
# Data sources
############################################################

data "ibm_is_vpc" "vpc" {
  name		= var.VPC
}

data "ibm_resource_group" "group" {
  name		= var.RESOURCE_GROUP
}

data "ibm_is_instance" "db-vsi-1" {
  name    =  var.DB_HOSTNAME_1
}


data "ibm_is_instance" "db-vsi-2" {
  count   = (var.HA_CLUSTER == "yes"  ? 1 : 0)
  name    =  var.DB_HOSTNAME_2
}

locals {
  db-vsi-2 = (var.HA_CLUSTER == "yes") ? data.ibm_is_instance.db-vsi-2[0].primary_network_interface[0].primary_ip[0].address : null
  db-vsi-2-ansible = (var.HA_CLUSTER == "yes") ? data.ibm_is_instance.db-vsi-2[0].primary_network_interface[0].primary_ip[0].address : "!none"
}

data "ibm_resource_instance" "cos_instance_resource" {
  depends_on = [module.cos]
  name              = "${local.hana_sid}-hana-backup-instance"
  location          = "global"
  resource_group_id = data.ibm_resource_group.group.id
  service           = "cloud-object-storage"
}

data "ibm_resource_key" "key" { 
  depends_on = [module.cos_clean_up]
  name                  = "${local.hana_sid}"
  resource_instance_id  = "${data.ibm_resource_instance.cos_instance_resource.id}"
}


data "ibm_cos_bucket" "regional_cos_bucket" {
  depends_on = [module.cos.ibm_cos_bucket]
  bucket_name          = "${local.hana_sid}-hana-backup-bucket"
  resource_instance_id  = "${data.ibm_resource_instance.cos_instance_resource.id}"
  bucket_type          = "region_location"
  bucket_region        = var.REGION
  }