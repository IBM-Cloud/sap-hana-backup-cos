module "cos" {
  source  = "./modules/cos"
  depends_on = [ null_resource.id_rsa_validation ]
  IBM_CLOUD_API_KEY=var.IBM_CLOUD_API_KEY
  REGION  = var.REGION
  RESOURCE_GROUP = var.RESOURCE_GROUP
  HANA_SID = local.hana_sid
  BUCKET_NAME = "${local.hana_sid}-hana-backup-bucket"
  LIFECYCLE_POLICY = var.LIFECYCLE_POLICY
}


module "cos_clean_up" {
  source  = "./modules/cos/clean_up"
  depends_on = [ module.cos ]
  IBM_CLOUD_API_KEY=var.IBM_CLOUD_API_KEY
  REGION  = var.REGION
  BUCKET_NAME = "${local.hana_sid}-hana-backup-bucket"
  HANA_SID = local.hana_sid
  INSTANCE_ID = "${data.ibm_resource_instance.cos_instance_resource.id}"
}

module "ansible-exec-cli" {
  source  = "./modules/ansible-exec/cli"
  depends_on	= [ module.cos_clean_up , local_file.db_ansible_saphana-vars ]
  HANA_MAIN_PASSWORD = var.HANA_MAIN_PASSWORD
  ID_RSA_FILE_PATH = var.ID_RSA_FILE_PATH
  HA_CLUSTER = var.HA_CLUSTER
  DB_HOSTNAME_1 = var.DB_HOSTNAME_1
  DB_HOSTNAME_2 = var.DB_HOSTNAME_2
}



