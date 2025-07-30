sddc_manager_host     = "sddc01.sddc.lab"
sddc_manager_username = "administrator@sddc.lab"
sddc_manager_password = "VMware1!VMware1!"
#
license_keys = {
  nsx     = "3M2U7-8A2DJ-78970-0H20M-94K6Q"
  vcenter = "5H60K-0CH95-18RNR-0L000-884N4"
  vsan    = "EJ29H-0D0DP-N8HN8-0PA0H-0XP64"
  esxi    = "X1092-2E1EP-58TN1-048HM-8NPH0"
}
#
workload_domain_name = "sddc01"
workload_domain_uuid = "1cb58b31-0d88-445e-b5c1-82a19b93300f"
vlcm_image_id        = "260751cc-f802-45e0-bc3f-cc701b86cdc1"
#
wld_hosts = {
  cluster1 = {
    "iaas-esxi05.sddc.lab" = ["9f8f64af-ea83-4ca1-ac7c-9f6240034305", "vmnic0", "vmnic1"],
    "iaas-esxi06.sddc.lab" = ["f45120cb-e9f3-4bb8-8b90-42afbff55dd3", "vmnic0", "vmnic1"],
    "iaas-esxi07.sddc.lab" = ["5947c63d-9f5e-4b40-ad17-a38ce2bacb35", "vmnic0", "vmnic1"],
    "iaas-esxi08.sddc.lab" = ["9435437a-28fa-48c5-b120-504dc91f0772", "vmnic0", "vmnic1"]
  },
  cluster2 = {
    "iaas-esxi05.sddc.lab" = ["9f8f64af-ea83-4ca1-ac7c-9f6240034305", "vmnic0", "vmnic1"],
    "iaas-esxi06.sddc.lab" = ["f45120cb-e9f3-4bb8-8b90-42afbff55dd3", "vmnic0", "vmnic1"],
    "iaas-esxi07.sddc.lab" = ["5947c63d-9f5e-4b40-ad17-a38ce2bacb35", "vmnic0", "vmnic1"],
    "iaas-esxi08.sddc.lab" = ["9435437a-28fa-48c5-b120-504dc91f0772", "vmnic0", "vmnic1"]
  }
}
#
wld_cluster_settings = {
  cluster1 = {
    name     = "wld1"
    vsan_ftt = "1"
    tep_vlan = "2018"
  },
  cluster2 = {
    name     = "wld2"
    vsan_ftt = "1"
    tep_vlan = "2023"
  }
}