# Generate SAP COS KIT PATHS
resource "local_file" "sap_paths" {
  content = <<-DOC
${var.HANA_KIT_FOR_BACKINT_COS}
${var.BACKINT_COS_KIT}
${var.CREATE_HDBBACKINT_SCRIPT}
    DOC
  filename = "modules/precheck-ssh-exec/sap-cos-kit-paths-${var.DB_HOSTNAME_1}"
}