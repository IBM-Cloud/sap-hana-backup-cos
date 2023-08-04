# Export Terraform variable values to a temp id_rsa file
resource "local_file" "tf_id_rsa" {
  content = <<-DOC
${var.private_ssh_key}
    DOC
  filename = "${var.ID_RSA_FILE_PATH}"
  file_permission = "0600"
}
