provider "azurerm" {
  subscription_id = "${var.azure_subscription_id}"
  client_id     = "${var.azure_client_id}"  
  client_secret   = "${var.azure_client_secret}"
  tenant_id     = "${var.azure_tenant_id}"
}

provider "kubernetes" {
  host = "${azurerm_kubernetes_cluster.test.kube_config.0.host}"
  client_certificate = "${base64decode(azurerm_kubernetes_cluster.test.kube_config.0.client_certificate)}"
  client_key = "${base64decode(azurerm_kubernetes_cluster.test.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.test.kube_config.0.cluster_ca_certificate)}"


}

resource "azurerm_resource_group" "test" {
  name     = "${var.resource_group_name}"
  location = "${var.azure_location}"
}

resource "azurerm_kubernetes_cluster" "test" {
  name                = "${var.cluster_name}"
  location            = "${var.azure_location}"
  resource_group_name = "${var.resource_group_name}"
  dns_prefix          = "${var.dns_prefix}"

  linux_profile {
    admin_username = "${var.admin_user}"

    ssh_key {
      key_data = "${var.ssh_key}"
    }
  }

  agent_pool_profile {
    name            = "default"
    count           = "${var.worker_vm_count}"
    vm_size         = "${var.vm_size}"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${var.azure_client_id}"
    client_secret = "${var.azure_client_secret}"
  }

  tags {
    Environment = "Development"
  }
}

resource "kubernetes_replication_controller" "default" {
   metadata {
    name = "rep-controller"
    labels {
      app = "MyExampleApp"
    }
  }

  spec {
    replicas = 2
    selector {
      app = "MyExampleApp"
    }
    template {
      container {
        image = "${var.image}"
        name  = "example"

     
      }
    }
  }

  depends_on = ["azurerm_kubernetes_cluster.test"]
}

resource "kubernetes_service" "default" {
  metadata {
    name = "clinic"
  }
  spec{
    selector {
      app = "MyExampleApp"
    }
    session_affinity = "ClientIP"
    port {
      port = "${var.expose_port}"
    }
    
    type = "LoadBalancer"
  }
}


output "id" {
    value = "${azurerm_kubernetes_cluster.test.id}"
}

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.test.kube_config_raw}"
}

output "client_key" {
  value = "${azurerm_kubernetes_cluster.test.kube_config.0.client_key}"
  sensitive = true
}

output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.test.kube_config.0.client_certificate}"
  sensitive = true
}

output "cluster_ca_certificate" {
  value = "${azurerm_kubernetes_cluster.test.kube_config.0.cluster_ca_certificate}"
  sensitive = true
}

output "host" {
  value = "${azurerm_kubernetes_cluster.test.kube_config.0.host}"
}
