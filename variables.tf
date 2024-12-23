variable "PRIVATE_SSH_KEY" {
	type		= string
	description = "id_rsa private key content in OpenSSH format (Sensitive value). This private key should be used only during the terraform provisioning and it is recommended to be changed after the SAP deployment."
	nullable = false
	validation {
	condition = length(var.PRIVATE_SSH_KEY) >= 64 && var.PRIVATE_SSH_KEY != null && length(var.PRIVATE_SSH_KEY) != 0 || contains(["n.a"], var.PRIVATE_SSH_KEY )
	error_message = "The content for PRIVATE_SSH_KEY variable must be in OpenSSH format."
      }
}

variable "ID_RSA_FILE_PATH" {
    default = "ansible/id_rsa"
    nullable = false
    description = "The file path for PRIVATE_SSH_KEY. It will be automatically generated. If it is changed, it must contain the relative path from git repo folders."
}

variable "BASTION_FLOATING_IP" {
	type		= string
	description = "The FLOATING IP of the BASTION Server (Deployment Server)."
	nullable = false
	validation {
        condition = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$",var.BASTION_FLOATING_IP)) || contains(["localhost"], var.BASTION_FLOATING_IP ) && var.BASTION_FLOATING_IP!= null
        error_message = "Incorrect format for variable: BASTION_FLOATING_IP."
      }
}

variable "RESOURCE_GROUP" {
  	type        = string
  	description = "EXISTING Resource Group, the same as for HANA VSI. The list of Resource Groups is available here: https://cloud.ibm.com/account/resource-groups."
  	default     = "Default"
}

variable "REGION" {
	type		= string
	description	= "The cloud region where HANA VSI was deployed. The COS will be created in the same region as HANA VSI. The regions and zones for VPC are available here: https://cloud.ibm.com/docs/containers?topic=containers-regions-and-zones#zones-vpc. Review supported locations in IBM Cloud Schematics here: https://cloud.ibm.com/docs/schematics?topic=schematics-locations."
	validation {
		condition     = contains(["eu-de", "eu-gb", "us-south", "us-east", "ca-tor", "au-syd", "jp-osa", "jp-tok", "eu-es", "br-sao"], var.REGION )
		error_message = "The REGION must be one of: eu-de, eu-gb, us-south, us-east, ca-tor, au-syd, jp-osa, jp-tok, eu-es, br-sao."
	}
}

variable "VPC" {
	type		= string
	description = "The name of the VPC where HANA VSI was deployed. The list of VPCs is available here: https://cloud.ibm.com/vpc-ext/network/vpcs"
	validation {
		condition     = length(regexall("^([a-z]|[a-z][-a-z0-9]*[a-z0-9]|[0-9][-a-z0-9]*([a-z]|[-a-z][-a-z0-9]*[a-z0-9]))$", var.VPC)) > 0
		error_message = "The VPC name is not valid."
	}
}

variable "SUBNET" {
	type		= string
	description = "EXISTING Subnet, the same as for HANA VSI. The list of Subnets is available here: https://cloud.ibm.com/vpc-ext/network/subnets."
	validation {
		condition     = length(regexall("^([a-z]|[a-z][-a-z0-9]*[a-z0-9]|[0-9][-a-z0-9]*([a-z]|[-a-z][-a-z0-9]*[a-z0-9]))$", var.SUBNET)) > 0
		error_message = "The SUBNET name is not valid."
	}
}

variable "SECURITY_GROUP" {
	type		= string
	description = "EXISTING Security group, the same as for HANA VSI. The list of Security Groups is available here: https://cloud.ibm.com/vpc-ext/network/securityGroups."
	validation {
		condition     = length(regexall("^([a-z]|[a-z][-a-z0-9]*[a-z0-9]|[0-9][-a-z0-9]*([a-z]|[-a-z][-a-z0-9]*[a-z0-9]))$", var.SECURITY_GROUP)) > 0
		error_message = "The SECURITY_GROUP name is not valid."
	}
}

resource "null_resource" "id_rsa_validation" {
  provisioner "local-exec" {
    command = "ssh-keygen -l -f ${var.ID_RSA_FILE_PATH}"
    on_failure = fail
  }
}

variable "HA_CLUSTER" {
	type		= string
	nullable = false
	description = "Specifies if High Availability is configured for HANA Database. Accepted values: yes/no. For the value \"no\" only \"DB_HOSTNAME_1\" variable must be filled in. For the value \"yes\" the following two variables must be filled in: DB_HOSTNAME_1, DB_HOSTNAME_2."
	}

variable "DB_HOSTNAME_1" {
	type		= string
	nullable = false
	default = ""
	description = "The Hostname of an EXISTING HANA VSI. Required. If High Availability is configured for HANA Database, it should be the hostname of HANA DB VSI 1."
	}

variable "DB_HOSTNAME_2" {
	type		= string
	description = "The Hostname of an EXISTING HANA VSI 2. Required only if High Availability is configured for HANA Database."
	nullable = true
	default = ""
}

variable "LIFECYCLE_POLICY" {
	type		= string
	description = "The number of retention days for HANA Database backup and Transaction LOG backup."
	nullable = false
}

##############################################################
# The variables used in SAP Ansible Modules.
##############################################################


locals {
  hana_sid = lower(var.HANA_SID)
}

variable "HANA_SID" {
	type		= string
	description = "EXISTING SAP HANA system ID. The SAP system ID identifies the SAP HANA system."
	default		= "HDB"
	validation {
		condition     = length(regexall("^[a-zA-Z][a-zA-Z0-9][a-zA-Z0-9]$", var.HANA_SID)) > 0  && !contains(["ADD", "ALL", "AMD", "AND", "ANY", "ARE", "ASC", "AUX", "AVG", "BIT", "CDC", "COM", "CON", "DBA", "END", "EPS", "FOR", "GET", "GID", "IBM", "INT", "KEY", "LOG", "LPT", "MAP", "MAX", "MIN", "MON", "NIX", "NOT", "NUL", "OFF", "OLD", "OMS", "OUT", "PAD", "PRN", "RAW", "REF", "ROW", "SAP", "SET", "SGA", "SHG", "SID", "SQL", "SUM", "SYS", "TMP", "TOP", "UID", "USE", "USR", "VAR"], var.HANA_SID)
		error_message = "The HANA_SID is not valid."
	}
}

variable "HANA_TENANTS" {
	type        = list(string)
	description = "A list of EXISTENT SAP HANA tenant databases."
	default     = ["HDB"]
	validation {
		condition     = alltrue([for tenant in var.HANA_TENANTS : !contains(["ADD", "ALL", "AMD", "AND", "ANY", "ARE", "ASC", "AUX", "AVG", "BIT", "CDC", "COM", "CON", "DBA", "END", "EPS", "FOR", "GET", "GID", "IBM", "INT", "KEY", "LOG", "LPT", "MAP", "MAX", "MIN", "MON", "NIX", "NOT", "NUL", "OFF", "OLD", "OMS", "OUT", "PAD", "PRN","RAW","REF","ROW","SAP","SET","SGA","SHG","SID","SQL","SUM","SYS","TMP","TOP","UID","USE","USR","VAR"], upper(tenant))])
		error_message = "${join(", ", var.HANA_TENANTS)} is an invalid hana_tenant value."
	}
	validation {
		condition     = alltrue([for tenant in var.HANA_TENANTS : length(upper(tenant)) <= 253]) && alltrue([for s in var.HANA_TENANTS : can(regex("^\\w+$", s))])
		error_message = "${join(", ", var.HANA_TENANTS)} contains invalid hana_tenant values."
	}

}

variable "HANA_SYSNO" {
	type		= string
	description = "EXISTING SAP HANA instance number. Specifies the instance number of the SAP HANA system."
	default		= "00"
	validation {
		condition     = var.HANA_SYSNO >= 0 && var.HANA_SYSNO <=97
		error_message = "The HANA_SYSNO is not valid."
	}
}

variable "HANA_MAIN_PASSWORD" {
	type		= string
	sensitive = true
	description = "HANA system master password. The HANA DB SYSTEM user should have the same password for SYSTEMDB and all tenant databases."
	validation {
		condition     = length(regexall("^(.{0,7}|.{15,}|[^0-9a-zA-Z]*)$", var.HANA_MAIN_PASSWORD)) == 0 && length(regexall("^[^0-9_][0-9a-zA-Z!@#$_]+$", var.HANA_MAIN_PASSWORD)) > 0
		error_message = "The HANA_MAIN_PASSWORD is not valid."
	}
}

variable "HANA_KIT_FOR_BACKINT_COS" {
	type		= string
	description = "The full path to SAP HANA kit file, to be used by the automation to extract backint agent kit for IBM COS aws-s3-backint-....-linuxx86_64.tar.gz. Mandatory only if BACKINT_COS_KIT is not provided. Make sure the version of the contained backint agent kit is at least aws-s3-backint-1.2.17-linuxx86_64."
}

variable "BACKINT_COS_KIT" {
	type		= string
	description = "The full path to the backup agent for IBM COS kit. Mandatory only if HANA_KIT_FOR_BACKINT_COS is not provided. Make sure the version of the backint agent kit is at least aws-s3-backint-1.2.17-linuxx86_64."
}

variable "CREATE_HDBBACKINT_SCRIPT" {
	type		= string
	description = "The full path to the Python script provided by SAP (SAP note 2935898 - Install and Configure SAP HANA Backint Agent for Amazon S3) to modify the \"hdbbackint\" script so that it points to the Python 3 libraries."
	default		= "/storage/hdb_backup_kit_files/python_script/create_hdbbackint.py"

}

resource "null_resource" "check_bk_agent_kit_vars" {
  lifecycle {
    precondition {
      condition     = (var.HANA_KIT_FOR_BACKINT_COS != null && var.HANA_KIT_FOR_BACKINT_COS != "") || (var.BACKINT_COS_KIT != null && var.BACKINT_COS_KIT != "")
      error_message = "The path for the kit for SAP HANA backint agent or the path for a SAP HANA kit file to be used to extract the SAP HANA backint agent should be provided."
    }
  }
}
