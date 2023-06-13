variable "HANA_MAIN_PASSWORD" {
    type = string
    description = "HANA_MAIN_PASSWORD"
}

variable "ID_RSA_FILE_PATH" {
    type = string
    description = "ID_RSA_FILE_PATH"
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