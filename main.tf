module "pre-init-schematics" {
  source  = "./modules/pre-init"
  count = (var.PRIVATE_SSH_KEY == "n.a" && var.BASTION_FLOATING_IP == "localhost" ? 0 : 1)
  ID_RSA_FILE_PATH = var.ID_RSA_FILE_PATH
  PRIVATE_SSH_KEY = var.PRIVATE_SSH_KEY
}

module "pre-init-cli" {
  source  = "./modules/pre-init/cli"
  count = (var.PRIVATE_SSH_KEY == "n.a" && var.BASTION_FLOATING_IP == "localhost" ? 1 : 0)
  CREATE_HDBBACKINT_SCRIPT = var.CREATE_HDBBACKINT_SCRIPT
  HANA_KIT_FOR_BACKINT_COS =  var.HANA_KIT_FOR_BACKINT_COS
  BACKINT_COS_KIT = var.BACKINT_COS_KIT
}

module "precheck-ssh-exec" {
  source  = "./modules/precheck-ssh-exec"
  depends_on	= [ module.pre-init-schematics ]
  count = (var.PRIVATE_SSH_KEY == "n.a" && var.BASTION_FLOATING_IP == "localhost" ? 0 : 1)
  BASTION_FLOATING_IP = var.BASTION_FLOATING_IP
  ID_RSA_FILE_PATH = var.ID_RSA_FILE_PATH
  PRIVATE_SSH_KEY = var.PRIVATE_SSH_KEY
  HOSTNAME  = var.DB_HOSTNAME_1
  SECURITY_GROUP = var.SECURITY_GROUP
  
}

module "cos" {
  source  = "./modules/cos"
  depends_on = [ module.precheck-ssh-exec ]
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

module "app-ansible-exec-schematics" {
  source  = "./modules/ansible-exec"
  depends_on	= [ module.pre-init-schematics , module.cos_clean_up , local_file.db_ansible_saphana-vars]
  count = (var.PRIVATE_SSH_KEY == "n.a" && var.BASTION_FLOATING_IP == "localhost" ? 0 : 1)
  IP = data.ibm_is_instance.db-vsi-1.primary_network_interface[0].primary_ip[0].address
  HANA_MAIN_PASSWORD = var.HANA_MAIN_PASSWORD
  BASTION_FLOATING_IP = var.BASTION_FLOATING_IP
  ID_RSA_FILE_PATH = var.ID_RSA_FILE_PATH
  PRIVATE_SSH_KEY = var.PRIVATE_SSH_KEY
  HA_CLUSTER = var.HA_CLUSTER
  DB_HOSTNAME_1 = var.DB_HOSTNAME_1
  DB_HOSTNAME_2 = var.DB_HOSTNAME_2
  
}


module "ansible-exec-cli" {
  source  = "./modules/ansible-exec/cli"
  depends_on	= [ module.pre-init-cli , module.cos_clean_up , local_file.db_ansible_saphana-vars]
  count = (var.PRIVATE_SSH_KEY == "n.a" && var.BASTION_FLOATING_IP == "localhost" ? 1 : 0)
  HANA_MAIN_PASSWORD = var.HANA_MAIN_PASSWORD
  ID_RSA_FILE_PATH = var.ID_RSA_FILE_PATH
  HA_CLUSTER = var.HA_CLUSTER
  DB_HOSTNAME_1 = var.DB_HOSTNAME_1
  DB_HOSTNAME_2 = var.DB_HOSTNAME_2
}
