vcenter_server   = "mgmt-vc.sddc.lab"
vcenter_username = "administrator@sddc.lab"
vcenter_password = "VMware1!VMware1!"
#
datacenter          = "mgmt_dc"
cluster             = "mgmt_cluster"
storage_policy_name = "k8s_policy"
content_library     = "vcf_library"
dvs                 = "mgmt_dvs"
#
edge_cluster = "tenant1" #tenant1
#
management_network = {
  name      = "mgmt_appliances"
  mask      = "255.255.255.0"
  gateway   = "172.16.104.1"
  start_ip  = "172.16.104.100"
  pool_size = 10
}
#
dns = {
  environment = "172.16.100.5"
  worker      = "172.16.100.5"
}
#
search_domains = ["mpc.lab1", ]
k8s_api_size   = "MEDIUM"
k8s_networks_ext = {
  ingress_net = "192.168.100.0/24"
  egress_net  = "192.168.101.0/24"
  service_net = "192.168.102.0/24"
}
pod_net = {
  network = "172.16.116.0/22"
}