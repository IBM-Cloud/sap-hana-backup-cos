resource "null_resource" "sch-server-deployment-ip" {
    depends_on = [local_file.tf_id_rsa]
    provisioner "local-exec" {
        command = "chmod +x ${path.module}/get.sch.ip.sh"
    }

    provisioner "local-exec" {
        command = "${path.module}/get.sch.ip.sh | uniq | tee ${path.module}/found.ip.tmpl"
        on_failure = fail
    }
}
