# --------------------------------------------------------------- #
# Edge-Node Deployment - One (1) Rack Model
# [] Creates NSX Edge-VMs across one (1) fault-domains
# [] Creates Distributed Port-Groups (trunks)
# [] Creates one (1) Edge-Cluster / Membership
# [] Creates one (1) Static IP Pool with ranges
# [] Creates one (1) Uplink-Profile
# [] Leverages Standard Host-Switches
#
# Steven Tumolo - VMW by Broadcom
# Version | 1.0
# --------------------------------------------------------------- #
terraform {
  required_providers {
    nsxt = {
      source  = "vmware/nsxt"
      version = "3.6.2"
    }
    vsphere = {
      source = "hashicorp/vsphere"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.11.1"
    }
  }
}
# --------------------------------------------------------------- #
# vCenter Configuration Discovery Data
# --------------------------------------------------------------- #
// Discover the Compute Managers(vCenter)
data "nsxt_compute_manager" "compute_manager" {
  display_name = var.compute_manager
}

// Discover the vSphere Datacenter
data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

// Discover the vSphere Cluster(s)
data "vsphere_compute_cluster" "clusters" {
  for_each      = var.vsphere_clusters
  name          = each.key
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

// Discover the vSphere Cluster's Datastore
data "vsphere_datastore" "datastores" {
  for_each      = var.vsphere_clusters
  name          = each.value["datastore"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

// Store the ID of the VDS by name
data "vsphere_distributed_virtual_switch" "dvs" {
  for_each      = tomap(var.vsphere_dvs)
  name          = each.key
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# --------------------------------------------------------------- #
# vCenter Distributed Port-Groups - Move this to Module - 'edge_vm_infrastructure'
# --------------------------------------------------------------- #
resource "vsphere_distributed_port_group" "mgmt" {
  name                            = var.pg_edge_mgmt
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvs.id
  active_uplinks                  = [var.pg_edge_mgmt["uplink"]["active"]]
  standby_uplinks                 = [var.pg_edge_mgmt["uplink"]["standby"]]
  vlan_id                         = var.pg_edge_mgmt["vlan"]
}

resource "vsphere_distributed_port_group" "trunk_tor_a" {
  for_each                        = var.pg_trunk
  name                            = each.key
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.vsphere_dvs.id
  active_uplinks                  = [each.value["tor_b"]["uplinks"]["active"]]
  standby_uplinks                 = [each.value["tor_b"]["uplinks"]["standby"]]

  vlan_range {
    min_vlan = each.value["start"]
    max_vlan = each.value["end"]
  }
}

# --------------------------------------------------------------- #
# vCenter Folder
# --------------------------------------------------------------- #
/*
resource "vsphere_folder" "folders" {
  path          = var.fd1_edge_vms_folder
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.edge_vcenter_datacenter.id
}
*/
# --------------------------------------------------------------- #
# NSX-T Configuration - Transport Zone
# --------------------------------------------------------------- #
data "nsxt_policy_transport_zone" "tz_overlay" {
  display_name = (var.transport_zones["overlay"])
}

data "nsxt_policy_transport_zone" "tz-vlan" {
  display_name = (var.transport_zones["vlan"])
}

# --------------------------------------------------------------- #
# NSX-T Configuration - IP Pool
# --------------------------------------------------------------- #
#Rack1
resource "nsxt_policy_ip_pool" "ip_pool" {
  for_each     = var.ip_pool_names
  display_name = each.value
}

data "nsxt_policy_realization_info" "ip_pool" {
  for_each = nsxt_policy_ip_pool.ip_pool
  path     = nsxt_policy_ip_pool.ip_pool[each.key].path
}

resource "nsxt_policy_ip_pool_static_subnet" "ip_pool_ranges" {
  for_each     = var.ip_pool_ranges
  display_name = each.key
  pool_path    = nsxt_policy_ip_pool.ip_pool[each.key].path
  cidr         = each.value[0]
  gateway      = each.value[1]

  allocation_range {
    start = each.value[2]
    end   = each.value[3]
  }
}

# --------------------------------------------------------------- #
# NSX-T Configuration - Host Switch Profile
# --------------------------------------------------------------- #
resource "nsxt_policy_uplink_host_switch_profile" "edge_uplink_profile" {
  description  = "${var.edge_cluster_name}_edge_uplink_profile"
  display_name = "${var.edge_cluster_name}_edge_uplink_profile"

  mtu            = var.edge_uplink_profile_mtu
  transport_vlan = var.edge_uplink_profile_tep_vlan
  overlay_encap  = "GENEVE"

  teaming {
    active {
      uplink_name = "uplink1"
      uplink_type = "PNIC"
    }
    active {
      uplink_name = "uplink2"
      uplink_type = "PNIC"
    }
    policy = "LOADBALANCE_SRCID"
  }

  named_teaming {
    active {
      uplink_name = "uplink1"
      uplink_type = "PNIC"
    }
    policy = "FAILOVER_ORDER"
    name   = "TOR-1"
  }

  named_teaming {
    active {
      uplink_name = "uplink2"
      uplink_type = "PNIC"
    }
    policy = "FAILOVER_ORDER"
    name   = "TOR-2"
  }
}

# --------------------------------------------------------------- #
# NSX-T Configuration - Edge-Cluster
# --------------------------------------------------------------- #

data "nsxt_transport_node_realization" "edge_node_vms_fd1" {
  depends_on = [nsxt_edge_transport_node.edge_node_vms_fd1]

  for_each = nsxt_edge_transport_node.edge_node_vms_fd1
  id       = nsxt_edge_transport_node.edge_node_vms_fd1[each.key].id
  delay    = 5
}

resource "nsxt_edge_cluster" "vcn_edge_cluster" {
  depends_on   = [data.nsxt_transport_node_realization.edge_node_vms_fd1, ]
  display_name = var.edge_cluster_name

  dynamic "member" {
    for_each = nsxt_edge_transport_node.edge_node_vms_fd1
    content {
      display_name      = member.key
      transport_node_id = nsxt_edge_transport_node.edge_node_vms_fd1[member.key].id
    }
  }
}
# --------------------------------------------------------------- #
# NSX-T Configuration - Edge-Node VMs
# --------------------------------------------------------------- #

resource "nsxt_edge_transport_node" "edge_vms" {
  #depends_on = [vsphere_resource_pool.fd1_edge_vsphere_rp, nsxt_policy_ip_pool.ip_pool, nsxt_policy_uplink_host_switch_profile.edge_uplink_profile, data.nsxt_policy_transport_zone.tz_overlay]
  for_each = var.edge_vms

  description  = each.key
  display_name = each.key

  standard_host_switch {
    host_switch_profile = [nsxt_policy_uplink_host_switch_profile.edge_uplink_profile.path]

    ip_assignment {
      assigned_by_dhcp = false
      static_ip_pool   = data.nsxt_policy_realization_info.ip_pool["rack1"].realized_id
    }

    transport_zone_endpoint {
      transport_zone = data.nsxt_policy_transport_zone.tz_overlay.path
    }
    transport_zone_endpoint {
      transport_zone = nsxt_policy_transport_zone.tz_uplinks.realized_id
    }

    pnic {
      device_name = "fp-eth0"
      uplink_name = "uplink1"
    }
    pnic {
      device_name = "fp-eth1"
      uplink_name = "uplink2"
    }
  }

  deployment_config {
    form_factor = var.edge_vms["size"]

    node_user_settings {
      cli_username  = "admin"
      cli_password  = var.edge_vm_passwords["admin"]
      root_password = var.edge_vm_passwords["root"]
    }

    vm_deployment_config {
      management_network_id   = vsphere_distributed_port_group.fd1_port_group_mgmt.id
      data_network_ids        = [vsphere_distributed_port_group.fd1_port_group_tor_a.id, vsphere_distributed_port_group.fd1_port_group_tor_b.id]
      compute_id              = vsphere_resource_pool.fd1_edge_vsphere_rp.id
      storage_id              = data.vsphere_datastore.fd1_edge_vsphere_cluster_datastore.id
      vc_id                   = data.nsxt_compute_manager.edge_compute_manager.id
      default_gateway_address = [var.edge_vm_mgmt_gateways["rack1"][0]]

      management_port_subnet {
        ip_addresses  = [each.value[0]]
        prefix_length = var.edge_vm_mgmt_gateways["rack1"][1]
      }
    }
  }

  node_settings {
    hostname             = each.key
    allow_ssh_root_login = true
    enable_ssh           = true
    dns_servers          = var.dns
    ntp_servers          = var.ntp
    search_domains       = var.search_domains
  }

  tag {
    scope = "fault-domain 1"
    tag   = "rack 1"
  }
}