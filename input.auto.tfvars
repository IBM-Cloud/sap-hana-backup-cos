##########################################################
# General VPC variables:
##########################################################

REGION = ""  
# The cloud region where HANA VSI was deployed. The COS will be created in the same region as HANA VSI. Supported regions: https://cloud.ibm.com/docs/containers?topic=containers-regions-and-zones#zones-vpc
# Example: REGION = "eu-de"

VPC = ""
# The name of the VPC where HANA VSI was deployed. The list of available VPCs: https://cloud.ibm.com/vpc-ext/network/vpcs
# Example: VPC = "ic4sap"

SECURITY_GROUP = ""
# The Security group which was set for HANA VSI. The list of available Security Groups: https://cloud.ibm.com/vpc-ext/network/securityGroups
# Example: SECURITY_GROUP = "ic4sap-securitygroup"

RESOURCE_GROUP = ""
# The name of an EXISTING Resource Group, same as for HANA VSI. The list of available Resource Groups: https://cloud.ibm.com/account/resource-groups
# Example: RESOURCE_GROUP = "wes-automation"

SUBNET = ""
# The Subnet set for HANA VSI. The list of available Subnets: https://cloud.ibm.com/vpc-ext/network/subnets
# Example: SUBNET = "ic4sap-subnet"

ID_RSA_FILE_PATH = "ansible/id_rsa"
# Existing id_rsa private key file path in OpenSSH format with 0600 permissions.
# This private key it is used only during the terraform provisioning and it is recommended to be changed after the SAP deployment.
# It must contain the relative or absoute path on your Bastion.
# Examples: "ansible/sap_hana_backup_cos" , "~/.ssh/sap_hana_backup_cos" , "/root/.ssh/id_rsa".

##########################################################
# COS variables:
##########################################################

LIFECYCLE_POLICY = ""
# The number of retention days for HANA Database backup and Transaction LOG backup
# Example: LIFECYCLE_POLICY = "120"

##########################################################
# Activity Tracker variables:
##########################################################

ATR_NAME = ""
# The name of the EXISTING Activity Tracker instance, in the same region as HANA VSI and COS. The list of available Activity Tracker is available here: https://cloud.ibm.com/observe/activitytracker
# Example: ATR_NAME="Activity-Tracker-SAP-eu-de"

##########################################################
# HANA VSI variables:
##########################################################

HA_CLUSTER = ""
# Specifies if High Availability is configured for HANA Database. Accepted values: yes/no
# For the value "no", only variable DB_HOSTNAME_1 must be filled in
# For the value "yes" the following two variables must to be filled in: DB_HOSTNAME_1, DB_HOSTNAME_2
# Example: HA_CLUSTER = "yes"

DB_HOSTNAME_1 = ""
# The Hostname of an EXISTING HANA DB VSI. Required. The hostname should be up to 13 characters, as required by SAP
# If High Availability is configured for HANA Database should be the hostname of HANA DB VSI 1.
# Example: DB_HOSTNAME_1 = "hanadb-vsi1"

DB_HOSTNAME_2 = ""
# The Hostname of an EXISTING HANA DB VSI 2. It is required only if High Availability is configured for HANA Database
# The hostname should be up to 13 characters, as required by SAP.
# Example: DB_HOSTNAME_2 = "hanadb-vsi2"

##########################################################
# SAP HANA backup configuration
##########################################################

HANA_SID = "HDB"
# EXISTING SAP HANA system ID. Should follow the SAP rules for SID naming.
# Obs. This will be used  also as identification number across different HA name resources. Duplicates are not allowed.
# Example: HANA_SID = "HDB"

HANA_SYSNO = "00"
# EXISTING SAP HANA instance number. Should follow the SAP rules for instance number naming.
# Example: HANA_SYSNO = "00"

HANA_TENANTS = ["HDB"]
# A list of EXISTING SAP HANA tenant databases
# Examples: HANA_TENANTS = ["HDB"] or HANA_TENANTS = ["Ten_HDB1", "Ten_HDB2", ..., "Ten_HDBn"]

##########################################################
# Kit Paths
##########################################################

BACKINT_COS_KIT = ""
# The full path to the backup agent for IBM COS kit. Mandatory only if HANA_KIT_FOR_BACKINT_COS is not provided. 
# Make sure the version of the backint agent kit is at least aws-s3-backint-1.2.17-linuxx86_64
# Example: BACKINT_COS_KIT = "/storage/hdb_backup_kit_files/aws-s3-backint/aws-s3-backint-1.2.18-linuxx86_64.tar.gz"

HANA_KIT_FOR_BACKINT_COS = ""
# The full path to SAP HANA kit file to be used by the automation to extract backint agent kit for IBM COS aws-s3-backint-....-linuxx86_64.tar.gz. 
# Mandatory only if BACKINT_COS_KIT is not provided. 
# Make sure the version of the contained backint agent kit is at least aws-s3-backint-1.2.17-linuxx86_64
# Example: HANA_KIT_FOR_BACKINT_COS = "/storage/HANADB/51056441.ZIP"

CREATE_HDBBACKINT_SCRIPT = "/storage/hdb_backup_kit_files/python_script/create_hdbbackint.py"
# The full path to the Python script provided by SAP (SAP note 2935898 - Install and Configure SAP HANA Backint Agent for Amazon S3) 
# to modify the "hdbbackint" script so that it points to the Python 3 libraries
# Example: CREATE_HDBBACKINT_SCRIPT = "/storage/hdb_backup_kit_files/python_script/create_hdbbackint.py"
