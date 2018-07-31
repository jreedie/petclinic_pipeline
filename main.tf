provider "azurerm" {
	subscription_id = "${var.azure_subscription_id}"
	client_id 		= "${var.azure_client_id}"	
	client_secret 	= "${var.azure_client_secret}"
	tenant_id 		= "${var.azure_tenant_id}"
}

resource "azurerm_resource_group" "default" {
	name   	 = "${var.resource_group_name}"
	location = "${var.azure_location}"
}


# ACS Engine Config
data "template_file" "acs_engine_config" {
  template = "${file(var.acs_engine_config_file)}"

  vars {
    master_vm_count = "${var.master_vm_count}"
    dns_prefix = "${var.dns_prefix}"
    vm_size = "${var.vm_size}"
    worker_vm_count = "${var.worker_vm_count}"
    admin_user = "${var.admin_user}"
    ssh_key = "${var.ssh_key}"
    orchestrator_version = "${var.orchestrator_version}"
    service_principle_client_id = "${var.azure_client_id}"
    service_principle_client_secret = "${var.azure_client_secret}"
  }

  depends_on = ["azurerm_resource_group.default"]
}

# Locally, output the rendered ACS Engine Config (after substitution has been performed)
resource "null_resource" "render_acs_engine_config" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.acs_engine_config.rendered}' > ${var.acs_engine_config_file_rendered}"
  }

  depends_on = ["data.template_file.acs_engine_config"]
}

# Locally, run the ACS Engine to produce the Azure Resource Template for the K8s cluster
resource "null_resource" "run_acs_engine" {
  provisioner "local-exec" {
    command = "acs-engine generate ${var.acs_engine_config_file_rendered}"
  }

  depends_on = ["null_resource.render_acs_engine_config"]
}

# Locally, run the Azure 2.0 CLI to create the resource deployment
resource "null_resource" "deploy_acs" {
  provisioner "local-exec" {
    command = "az group deployment create --name ${var.cluster_name} --resource-group ${var.resource_group_name} --template-file ./$(find _output -name 'azuredeploy.json') --parameters @./$(find _output -name 'azuredeploy.parameters.json')"
  }

  depends_on = ["null_resource.run_acs_engine"]
}


