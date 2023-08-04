resource "null_resource" "check-bastion-resources" {
  
        depends_on = [ ibm_is_security_group_rule.inbound-sg-sch-ssh-rule ]

        connection {
            type = "ssh"
            user = "root"
            host = var.BASTION_FLOATING_IP
            private_key = var.private_ssh_key
            timeout = "1m"
         }

         provisioner "file" {
           source      = "modules/precheck-ssh-exec/check_file.sh"
           destination = "/tmp/check_file-${var.HOSTNAME}.sh"
         }

         provisioner "remote-exec" {
           inline = [
             "chmod +x /tmp/check_file-${var.HOSTNAME}.sh",
             "dos2unix /tmp/check_file-${var.HOSTNAME}.sh",
           ]
         }


         provisioner "file" {
           source      = "modules/precheck-ssh-exec/error.sh"
           destination = "/tmp/${var.HOSTNAME}.error.sh"
         }

         provisioner "remote-exec" {
           inline = [
             "chmod +x /tmp/${var.HOSTNAME}.error.sh",
             "dos2unix /tmp/${var.HOSTNAME}.error.sh",
           ]
         }

         provisioner "file" {
           source      = "modules/precheck-ssh-exec/sap-cos-kit-paths-${var.HOSTNAME}"
           destination = "/tmp/sap-cos-kit-paths-${var.HOSTNAME}"
         }
         
         provisioner "remote-exec" {
             inline = [
              "for i in `cat /tmp/sap-cos-kit-paths-${var.HOSTNAME}`; do  /tmp/check_file-${var.HOSTNAME}.sh $i; done > /tmp/${var.HOSTNAME}.precheck.log",
            ]
         }

    }


  resource "null_resource" "check-path-errors" {

         depends_on	= [ null_resource.check-bastion-resources ]

         provisioner "local-exec" {
             command = "export ID_RSA_FILE_PATH=${var.ID_RSA_FILE_PATH}; ssh -o 'StrictHostKeyChecking no' -i $ID_RSA_FILE_PATH root@${var.BASTION_FLOATING_IP} 'export HOSTNAME=${var.HOSTNAME}; timeout 5s /tmp/${var.HOSTNAME}.error.sh'"
             on_failure = fail
         }

     }