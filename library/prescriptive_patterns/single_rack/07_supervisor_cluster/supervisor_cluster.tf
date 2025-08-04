# --------------------------------------------------------------- #
# Create Storage Policy
# --------------------------------------------------------------- #
module "storage_policy" {
  source = "../../../../modules/vsphere/storage_policy"

  # Redunant authentication. Leveraged in GOVC script
  vcenter_server   = var.vcenter_server
  vcenter_username = var.vcenter_username
  vcenter_password = var.vcenter_password

  tag_category = {
    name         = "tanzu_k8s"
    object_types = ["Datastore"]
  }

  tags = {
    name     = "tanzu"
    category = "tanzu_k8s"
  }

  storage_policy = {
    tag_category_name = "tanzu_k8s"
    tag_name          = "tanzu"
    name              = "tanzu_storage_policy"
    datastore = {
      name       = "vsan01"
      datacenter = "dc01"
    }
  }
}
# --------------------------------------------------------------- #
# Enable Supervisor Cluster
# --------------------------------------------------------------- #
module "supervisor_cluster" {
  depends_on = [module.storage_policy]
  source     = "../../../../modules/vsphere/supervisor_cluster"

  datacenter          = "mgmt_dc"
  cluster             = "mgmt_cluster"
  storage_policy_name = "k8s_policy"
  content_library     = "vcf_library"
  dvs                 = "mgmt_dvs"
  edge_cluster        = "vcf_tenant1"
  #
  management_network = {
    name      = "mgmt_appliances"
    mask      = "255.255.255.0"
    gateway   = "172.16.104.1"
    start_ip  = "172.16.104.100"
    pool_size = 5
  }
  #
  dns = {
    environment = "172.16.100.5"
    worker      = "172.16.100.5"
  }
  #
  search_domains = ["sddc.lab"]
  k8s_api_size   = "MEDIUM"
  k8s_networks_ext = {
    ingress_net = "192.168.100.0/24"
    egress_net  = "192.168.101.0/24"
    service_net = "192.168.102.0/24"
  }
  pod_net = "172.16.112.0/22"
}

# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "WCP" {
  value = [
    module.storage_policy,
    module.supervisor_cluster
  ]
}