variable "ID_RSA_FILE_PATH" {
    nullable = false
    description = "Input your id_rsa private key file path in OpenSSH format."
}

variable "private_ssh_key" {
    type = string
    description = "Private ssh key"
}