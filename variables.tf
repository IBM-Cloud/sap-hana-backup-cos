variable "RESOURCE_GROUP" {
  type        = string
  description = "An EXISTING Resource Group for VSI and volumes"
  default     = "Default"
}

variable "REGION" {
	type		= string
	description	= "Cloud Region"
	validation {
		condition     = contains(["au-syd", "jp-osa", "jp-tok", "eu-de", "eu-gb", "ca-tor", "us-south", "us-east", "br-sao"], var.REGION )
		error_message = "For CLI deployments, the REGION must be one of: au-syd, jp-osa, jp-tok, eu-de, eu-gb, ca-tor, us-south, us-east, br-sao. \n For Schematics, the REGION must be one of: eu-de, eu-gb, us-south, us-east."
	}
}

variable "VPC" {
	type		= string
	description = "EXISTING VPC name"
	default = "sap"
	validation {
		condition     = length(regexall("^([a-z]|[a-z][-a-z0-9]*[a-z0-9]|[0-9][-a-z0-9]*([a-z]|[-a-z][-a-z0-9]*[a-z0-9]))$", var.VPC)) > 0
		error_message = "The VPC name is not valid."
	}
}

variable "SUBNET" {
	type		= string
	description = "EXISTING Subnet name"
	default		= "sap-subnet"
	validation {
		condition     = length(regexall("^([a-z]|[a-z][-a-z0-9]*[a-z0-9]|[0-9][-a-z0-9]*([a-z]|[-a-z][-a-z0-9]*[a-z0-9]))$", var.SUBNET)) > 0
		error_message = "The SUBNET name is not valid."
	}
}

variable "SECURITY_GROUP" {
	type		= string
	description = "EXISTING Security group name"
	default = "sap-securitygroup"
	validation {
		condition     = length(regexall("^([a-z]|[a-z][-a-z0-9]*[a-z0-9]|[0-9][-a-z0-9]*([a-z]|[-a-z][-a-z0-9]*[a-z0-9]))$", var.SECURITY_GROUP)) > 0
		error_message = "The SECURITY_GROUP name is not valid."
	}
}

variable "ID_RSA_FILE_PATH" {
    default = "~/.ssh/id_rsa"
    nullable = false
    description = "Input your id_rsa private key file path in OpenSSH format with 0600 permissions."
    validation {
    	condition = fileexists("${var.ID_RSA_FILE_PATH}") == true
    	error_message = "The id_rsa file does not exist."
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
	description = "Choose if High Availability is configured for HANA Database. Accepted values: yes/no. For the value \"no\" it is required that only the \"DB_HOSTNAME_1\" variable to be filled in.For the value \"yes\" it is required that both next variables to be filled in: DB_HOSTNAME_1, DB_HOSTNAME_2."
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

variable "LIFECYCLE_POLICY" {
	type		= string
	description = "LIFECYCLE_POLICY for Object Storage in Days."
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
	description = "SAP HANA SID"
	default		= "HDB"
	validation {
		condition     = length(regexall("^[a-zA-Z][a-zA-Z0-9][a-zA-Z0-9]$", var.HANA_SID)) > 0  && !contains(["ADD", "ALL", "AMD", "AND", "ANY", "ARE", "ASC", "AUX", "AVG", "BIT", "CDC", "COM", "CON", "DBA", "END", "EPS", "FOR", "GET", "GID", "IBM", "INT", "KEY", "LOG", "LPT", "MAP", "MAX", "MIN", "MON", "NIX", "NOT", "NUL", "OFF", "OLD", "OMS", "OUT", "PAD", "PRN", "RAW", "REF", "ROW", "SAP", "SET", "SGA", "SHG", "SID", "SQL", "SUM", "SYS", "TMP", "TOP", "UID", "USE", "USR", "VAR"], var.HANA_SID)
		error_message = "The HANA_SID is not valid."
	}
}

variable "HANA_TENANTS" {
	type        = list(string)
	description = "SAP HANA tenant databases"
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
	description = "SAP HANA Instance Number"
	default		= "00"
	validation {
		condition     = var.HANA_SYSNO >= 0 && var.HANA_SYSNO <=97
		error_message = "The HANA_SYSNO is not valid."
	}
}

variable "HANA_MAIN_PASSWORD" {
	type		= string
	sensitive = true
	description = "SAP HANA DB main password"
	validation {
		condition     = length(regexall("^(.{0,7}|.{15,}|[^0-9a-zA-Z]*)$", var.HANA_MAIN_PASSWORD)) == 0 && length(regexall("^[^0-9_][0-9a-zA-Z!@#$_]+$", var.HANA_MAIN_PASSWORD)) > 0
		error_message = "The HANA_MAIN_PASSWORD is not valid."
	}
}

variable "HANA_KIT_FOR_BACKINT_COS" {
	type		= string
	description = "The full path to SAP HANA kit file to be used by the automation to extract backint agent kit for IBM COS aws-s3-backint-....-linuxx86_64.tar.gz. Mandatory only if BACKINT_COS_KIT is not provided. Make sure the version of the contained backint agent kit is at least aws-s3-backint-1.2.17-linuxx86_64"
}

variable "BACKINT_COS_KIT" {
	type		= string
	description = "The full path to the backup agent for IBM COS kit. Mandatory only if HANA_KIT_FOR_BACKINT_COS is not provided. Make sure the version of the backint agent kit is at least aws-s3-backint-1.2.17-linuxx86_64"
}

variable "CREATE_HDBBACKINT_SCRIPT" {
	type		= string
	description = "The full path to the Python script provided by SAP (SAP note 2935898 - Install and Configure SAP HANA Backint Agent for Amazon S3) to modify the \"hdbbackint\" script so that it points to the Python 3 libraries"
	default		= "/storage/hdb_backup_kit_files/python_script/create_hdbbackint.py"
	    validation {
    condition = fileexists("${var.CREATE_HDBBACKINT_SCRIPT}") == true
    error_message = "The file create_hdbbackint.py does not exist."
    }
}

variable "sap_sid" {
	type		= string
	description = "sap_sid"
	default		= "S4A"
	validation {
		condition     = length(regexall("^[a-zA-Z][a-zA-Z0-9][a-zA-Z0-9]$", var.sap_sid)) > 0 && !contains(["ADD", "ALL", "AMD", "AND", "ANY", "ARE", "ASC", "AUX", "AVG", "BIT", "CDC", "COM", "CON", "DBA", "END", "EPS", "FOR", "GET", "GID", "IBM", "INT", "KEY", "LOG", "LPT", "MAP", "MAX", "MIN", "MON", "NIX", "NOT", "NUL", "OFF", "OLD", "OMS", "OUT", "PAD", "PRN", "RAW", "REF", "ROW", "SAP", "SET", "SGA", "SHG", "SID", "SQL", "SUM", "SYS", "TMP", "TOP", "UID", "USE", "USR", "VAR"], var.sap_sid)
		error_message = "The sap_sid is not valid."
	}
}

resource "null_resource" "check_bk_agent_kit_files" {
  lifecycle {
    precondition {
      condition     = can(fileexists("${var.HANA_KIT_FOR_BACKINT_COS}")) || can(fileexists("${var.BACKINT_COS_KIT}"))
      error_message = "The kit for SAP HANA backint agent or a SAP HANA kit file for SAP HANA backint agent should be provided."
    }
  }
}
