variable "CREATE_HDBBACKINT_SCRIPT" {
	type		= string
	description = "The full path to the Python script provided by SAP (SAP note 2935898 - Install and Configure SAP HANA Backint Agent for Amazon S3) to modify the \"hdbbackint\" script so that it points to the Python 3 libraries"
	default		= "/storage/hdb_backup_kit_files/python_script/create_hdbbackint.py"
}


variable "HANA_KIT_FOR_BACKINT_COS" {
	type		= string
	description = "The full path to SAP HANA kit file to be used by the automation to extract backint agent kit for IBM COS aws-s3-backint-....-linuxx86_64.tar.gz. Mandatory only if BACKINT_COS_KIT is not provided. Make sure the version of the contained backint agent kit is at least aws-s3-backint-1.2.17-linuxx86_64"
}

variable "BACKINT_COS_KIT" {
	type		= string
	description = "The full path to the backup agent for IBM COS kit. Mandatory only if HANA_KIT_FOR_BACKINT_COS is not provided. Make sure the version of the backint agent kit is at least aws-s3-backint-1.2.17-linuxx86_64"
}