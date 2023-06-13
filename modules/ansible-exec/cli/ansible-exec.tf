## For non HA HANA BACKUP
resource "null_resource" "ansible-exec-non-ha" {
    count   = (var.HA_CLUSTER == "no" && length(var.DB_HOSTNAME_1) <= 13 ? 1 : 0)
  provisioner "local-exec" {
    command = "export ID_RSA_FILE_PATH=${var.ID_RSA_FILE_PATH}; ansible-playbook --private-key $ID_RSA_FILE_PATH -i ansible/inventory.yml ansible/non_ha_hana_backup.yml"
  }
}

## For HA HANA BACKUP
resource "null_resource" "ansible-exec-ha" {
    count   = (var.HA_CLUSTER == "yes" && length(var.DB_HOSTNAME_2) <= 13  ? 1 : 0)
  provisioner "local-exec" {
    command = "export ID_RSA_FILE_PATH=${var.ID_RSA_FILE_PATH}; ansible-playbook --private-key $ID_RSA_FILE_PATH -i ansible/inventory.yml ansible/ha_hana_backup.yml"
  }
}

## Cleaning UP
## Can be comment it out for dev purposes
resource "null_resource" "cleaning-up" {
 depends_on = [null_resource.ansible-exec-ha, null_resource.ansible-exec-non-ha]
  provisioner "local-exec" {
     command = "sed -i  's/${var.HANA_MAIN_PASSWORD}/xxxxxxxx/' terraform.tfstate"
    }
  provisioner "local-exec" {
       command = "sleep 20; rm -rf  ansible/*-vars.yml modules/cos/credentials.json  modules/cos/cos_apykey.tmpl"
      }
}
