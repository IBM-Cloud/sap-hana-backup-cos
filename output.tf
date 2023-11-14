
output "VPC" {
  value		= var.VPC
}

output "REGION" {
  value		= var.REGION
}

output "HA_CLUSTER" {
  value		= var.HA_CLUSTER
}

output "HANA_SID" {
  value		= var.HANA_SID
}

output "HANA_DB_HOSTNAME_1" {
  value		= var.DB_HOSTNAME_1
}

output "HANA_DB_PRIVATE_IP_VSI1" {
  value		= "${data.ibm_is_instance.db-vsi-1.primary_network_interface[0].primary_ip[0].address}"
}

output "HANA_DB_HOSTNAME_2" {
  value		= var.DB_HOSTNAME_2
}

output "HANA_DB_PRIVATE_IP_VSI2" {
  value		= local.db-vsi-2
}

output "COS_INSTANCE_NAME" {
  value = "${local.hana_sid}-hana-backup-instance"
}

output "BUCKET_NAME" {
  value = "${local.hana_sid}-hana-backup-bucket"
}

output "ATR_INSTANCE_NAME" {
  description = "Activity Tracker instance name."
    value       = var.ATR_NAME
}