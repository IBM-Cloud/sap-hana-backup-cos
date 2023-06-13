resource "ibm_resource_key" "resource_key" {
  depends_on = [null_resource.delete_cos_objects]
  name                 = "${var.HANA_SID}"
  role                 = "Manager"
  resource_instance_id = var.INSTANCE_ID
  # parameters           = { "HMAC" = true }

  //User can increase timeouts
  timeouts {
    create = "15m"
    delete = "15m"
  }
}

resource "local_file" "service_credentials" {
  content  = ibm_resource_key.resource_key.credentials_json
  filename = "modules/cos/credentials.json"
  file_permission = "0644"
}

resource "null_resource" "cos_apikey" {
  depends_on = [ local_file.service_credentials ]
  provisioner "local-exec" {
    command = "jq .apikey modules/cos/credentials.json > modules/cos/cos_apykey.tmpl"
  }
}

resource "null_resource" "delete_cos_objects" {
  
  triggers = {
    REGION   = var.REGION
    BUCKET_NAME = var.BUCKET_NAME
    IBM_CLOUD_API_KEY=  var.IBM_CLOUD_API_KEY
  }

  provisioner "local-exec" {
    when    = destroy
    command = "export BUCKET_NAME=${self.triggers.BUCKET_NAME};export REGION=${self.triggers.REGION};export IBM_CLOUD_API_KEY=${self.triggers.IBM_CLOUD_API_KEY};dos2unix ${path.module}/delete_cos_objects.sh; chmod +x ${path.module}/delete_cos_objects.sh;/bin/bash ${path.module}/delete_cos_objects.sh"
  interpreter = ["/bin/bash", "-c"]
      }
}
