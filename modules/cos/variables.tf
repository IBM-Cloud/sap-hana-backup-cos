variable "REGION" {
    type = string
    description = "Cloud REGION"
}

variable "IBM_CLOUD_API_KEY" {
    type = string
    description = "IBM_CLOUD_API_KEY"
}

variable "RESOURCE_GROUP" {
    type = string
    description = "Resource Group"
}

variable "HANA_SID" {
	type		= string
	description = "HANA SID"
}

variable "LIFECYCLE_POLICY" {
	type		= string
	description = "Lifecycle policy in days"
}


variable "BUCKET_NAME" {
	type		= string
	description = "BUCKET_NAME"
}


variable "ATR_NAME" {
  description = "Activity Tracker Enter the instance name "
  type        = string
}

variable "ATR_ENABLE" {
  description = "Enable Activity Tracker usage"
  type        = bool
}

