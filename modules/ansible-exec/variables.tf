variable "BASTION_FLOATING_IP" {
    type = string
    description = "IP used to execute the remote script"
}

variable "IP" {
    type = string
    description = "IP used by ansible"
}

variable "PRIVATE_SSH_KEY" {
    type = string
    description = "Private ssh key"
}

variable "ID_RSA_FILE_PATH" {
    nullable = false
    description = "Input your id_rsa private key file path in OpenSSH format."
}

variable "HANA_MAIN_PASSWORD" {
    type = string
    description = "HANA_MAIN_PASSWORD"
}


variable "HA_CLUSTER" {
    type = string
    description = "HA_CLUSTER"
}

variable "DB_HOSTNAME_1" {
	type		= string
	nullable = false
	default = ""
	description = "DB VSI Hostname-1."
	}

variable "DB_HOSTNAME_2" {
	type		= string
	description = "Enter your DB VSI Hostname-2 only for HA Deployments"
	nullable = true
	default = ""
}

# Developer settings:
locals {

SAP_DEPLOYMENT = "sap-hana-backup-cos"
SCHEMATICS_TIMEOUT = 45         #(Max 55 Minutes). It is multiplied by 5 on Schematics deployments and it is relying on the ansible-logs number.

}
