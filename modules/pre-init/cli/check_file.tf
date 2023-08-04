resource "null_resource" "fail_if_hdbbackint_script_not_found" {
  provisioner "local-exec" {
        command     = "if [ ! -f ${var.CREATE_HDBBACKINT_SCRIPT} ]; then echo \"${var.CREATE_HDBBACKINT_SCRIPT} not found \"; exit 1; fi"
        on_failure = fail
  }
}

resource "null_resource" "fail_if_backint_cos_kit_not_found" {
  count = length(var.BACKINT_COS_KIT) > 0 ? 1 : 0
  

    provisioner "local-exec" {
      command = "if [ ! -f ${var.BACKINT_COS_KIT} ]; then echo \"${var.BACKINT_COS_KIT} not found \"; exit 1; fi"
      on_failure = fail
  }

}

resource "null_resource" "fail_if_hana_kit_backint_cos_not_found" {
  count = length(var.HANA_KIT_FOR_BACKINT_COS) > 0 ? 1 : 0
   

    provisioner "local-exec" {
      command = "if [ ! -f ${var.HANA_KIT_FOR_BACKINT_COS} ]; then echo \"${var.HANA_KIT_FOR_BACKINT_COS} not found \"; exit 1; fi"
      on_failure = fail
  }

}
