sddc_manager_host     = "sddc.sddc.lab"
sddc_manager_username = "administrator@mpc.lab1"
sddc_manager_password = "VMware1!VMware1!"

edge_cluster = {
  name       = "vcf-edge-tenant1"
  local_asn  = 65010
  mtu        = 1700
  tier0_name = "vcf_tier0"
  tier1_name = "vcf_tier1"
  tier1_type = "ACTIVE_ACTIVE"
  passwords = {
    root  = "VMware1!VMware1!"
    admin = "VMware1!VMware1!"
    audit = "VMware1!VMware1!"
  }
}

edge_nodes = {
  vcf-edge-1 = {
    fqdn                 = "vcf-edge-1.sddc.lab"
    compute_cluster_name = "cl01"
    mgmt_ip              = "172.16.104.20/24"
    mgmt_gw              = "172.16.104.1"
    mgmt_pg              = "cl01-edges"
    mgmt_vlan            = 1004
    tep = {
      gateway = "172.16.105.1"
      vlan    = 1005
      ip1     = "172.16.105.11/24"
      ip2     = "172.16.105.12/24"
    }
    uplinks = [
      {
        vlan       = 1006
        ip         = "172.16.106.10/24"
        peer_ip    = "172.16.106.1/24"
        remote_asn = 65000
        password   = "VMware1!"
      },
      {
        vlan       = 1007
        ip         = "172.16.107.10/24"
        peer_ip    = "172.16.107.1/24"
        remote_asn = 65000
        password   = "VMware1!"
      }
    ]
  }
  vcf-edge-2 = {
    fqdn                 = "vcf-edge-2.sddc.lab"
    compute_cluster_name = "cl01"
    mgmt_ip              = "172.16.104.21/24"
    mgmt_gw              = "172.16.104.1"
    mgmt_pg              = "cl01-edges"
    mgmt_vlan            = 1004
    tep = {
      gateway = "172.16.105.1"
      vlan    = 1005
      ip1     = "172.16.105.13/24"
      ip2     = "172.16.105.14/24"
    }
    uplinks = [
      {
        vlan       = 1006
        ip         = "172.16.106.11/24"
        peer_ip    = "172.16.106.1/24"
        remote_asn = 65000
        password   = "VMware1!"
      },
      {
        vlan       = 1007
        ip         = "172.16.107.11/24"
        peer_ip    = "172.16.107.1/24"
        remote_asn = 65000
        password   = "VMware1!"
      }
    ]
  }
}