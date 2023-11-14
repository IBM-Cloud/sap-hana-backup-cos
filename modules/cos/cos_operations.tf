data "ibm_resource_group" "group" {
  name = var.RESOURCE_GROUP
}

data "ibm_resource_instance" "activity_tracker" {
  count             = var.ATR_ENABLE == true ? 1 : 0
  name              = var.ATR_NAME
  location          = var.REGION
  service           = "logdnaat"
}

resource "ibm_resource_instance" "cos_instance" {
  name              = "${var.HANA_SID}-hana-backup-instance"
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
  resource_group_id = data.ibm_resource_group.group.id
  tags              = ["hana backup", "wes-sap-automation"]

  # User can increase timeout values
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_cos_bucket" "cos_bucket_at" {
  count             = var.ATR_ENABLE == true ? 1 : 0
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
  activity_tracking {
    read_data_events     = true
    write_data_events    = true
    activity_tracker_crn = data.ibm_resource_instance.activity_tracker[0].id
  }

  lifecycle {
    precondition {
      condition = data.ibm_resource_instance.activity_tracker[0].status == "active"
      error_message = "Provided Activity Tracker instance doesn't exists"
    }
  }
}

resource "ibm_cos_bucket" "cos_bucket" {
  count             = var.ATR_ENABLE == false ? 1 : 0
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
