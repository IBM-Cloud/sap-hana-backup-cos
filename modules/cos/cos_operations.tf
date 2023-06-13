data "ibm_resource_group" "group" {
  name = var.RESOURCE_GROUP
}

resource "ibm_resource_instance" "cos_instance" {
  name              = "${var.HANA_SID}-hana-backup-instance"
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
  resource_group_id = data.ibm_resource_group.group.id
  tags              = ["hana backup"]

  //User can increase timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_cos_bucket" "cos_bucket" {

  bucket_name          = "${var.HANA_SID}-hana-backup-bucket"
  resource_instance_id = ibm_resource_instance.cos_instance.id
  region_location        = var.REGION
  storage_class        = "smart"
  expire_rule {
    enable = true
    days = var.LIFECYCLE_POLICY
  }
  object_versioning {
    enable  = true
  }
  noncurrent_version_expiration {
    enable  = true
    noncurrent_days = var.LIFECYCLE_POLICY
  }
}