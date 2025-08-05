# --------------------------------------------------------------- #
# Nested ESXi host deployment for VMW Pro Cloud Services Lab
# [] Leverages Content Library for ESXi Template ISO
# [] Deploys # of ESXi VMs
#
# Steven Tumolo - VMW by Broadcom
# Version | 1.0
# --------------------------------------------------------------- #

# --------------------------------------------------------------- #
# vCenter Configuration
# --------------------------------------------------------------- #
// Root Datacenter
data "vsphere_datacenter" "root_datacenter" {
  name = var.root_datacenter
}

// Root Cluster
data "vsphere_compute_cluster" "root_cluster" {
  name          = var.root_cluster
  datacenter_id = data.vsphere_datacenter.root_datacenter.id
}

// Root Datastore
data "vsphere_datastore" "root_datastore" {
  name          = var.root_datastore
  datacenter_id = data.vsphere_datacenter.root_datacenter.id
}

// Resource Pool
data "vsphere_resource_pool" "root_rp" {
  name          = var.root_rp
  datacenter_id = data.vsphere_datacenter.root_datacenter.id
}

// Folder
data "vsphere_folder" "root_folder" {
  path = "${var.root_datacenter}/vm/${var.root_folder}"
}

// Root Port-Group(s)
data "vsphere_network" "nested_lab_pg" {
  name          = var.nested_lab_pg
  datacenter_id = data.vsphere_datacenter.root_datacenter.id
}

data "vsphere_network" "root_pg_trunk_a" {
  name          = var.root_pgs["trunk_a"][0]
  datacenter_id = data.vsphere_datacenter.root_datacenter.id
}

data "vsphere_network" "root_pg_trunk_b" {
  name          = var.root_pgs["trunk_b"][0]
  datacenter_id = data.vsphere_datacenter.root_datacenter.id
}

data "vsphere_host" "root_host" {
  name          = var.root_host
  datacenter_id = data.vsphere_datacenter.root_datacenter.id
}
# --------------------------------------------------------------- #
# Content Library Configuration - under development
# --------------------------------------------------------------- #
data "vsphere_content_library" "content_library" {
  name = var.vmw_content_library_name
}

#data "vsphere_content_library_item" "esxi_template" {
#  name       = var.esxi_template
#  type       = "ovf"
#  library_id = data.vsphere_content_library.content_library.id
#}

# --------------------------------------------------------------- #
# Nested ESXi VM Configuration
# --------------------------------------------------------------- #
data "vsphere_virtual_machine" "root_template" {
  name          = var.esxi_template
  datacenter_id = data.vsphere_datacenter.root_datacenter.id
}

## Remote OVF/OVA Source
data "vsphere_ovf_vm_template" "ovfRemote" {
  name              = "esxi_80u2_template"
  disk_provisioning = "thin"
  resource_pool_id  = data.vsphere_resource_pool.root_rp.id
  datastore_id      = data.vsphere_datastore.root_datastore.id
  host_system_id    = data.vsphere_host.root_host.id
  remote_ovf_url    = var.remote_ovf_url
  ovf_network_map = {
    "VM Network" : data.vsphere_network.nested_lab_pg.id
  }
}

resource "vsphere_virtual_machine" "nested_iaas_host" {
  depends_on = [data.vsphere_network.root_pg_trunk_a, data.vsphere_network.root_pg_trunk_b, data.vsphere_folder.root_folder, data.vsphere_resource_pool.root_rp]

  for_each         = var.nested_hosts
  name             = each.key
  datastore_id     = data.vsphere_datastore.root_datastore.id
  datacenter_id    = data.vsphere_datacenter.root_datacenter.id
  resource_pool_id = data.vsphere_resource_pool.root_rp.id
  folder           = data.vsphere_folder.root_folder.path

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 5

  #enable_disk_uuid    = true
  sync_time_with_host = true
  enable_logging      = true
  nested_hv_enabled   = true

  ovf_deploy {
    remote_ovf_url    = var.remote_ovf_url
    disk_provisioning = "thin"
    ovf_network_map = {
      "VM Network" = data.vsphere_network.nested_lab_pg.id
    }
  }

  # Compute Configuration
  guest_id             = "vmkernel8Guest"
  num_cpus             = var.host_cpus  #16
  num_cores_per_socket = var.host_cores #8
  memory               = var.host_mem   #131076

  # Network Configuration
  network_interface {
    network_id = data.vsphere_network.nested_lab_pg.id
  }
  network_interface {
    network_id = data.vsphere_network.nested_lab_pg.id
  }
  network_interface {
    network_id = data.vsphere_network.nested_lab_pg.id
  }
  network_interface {
    network_id = data.vsphere_network.nested_lab_pg.id
  }

  # Datastore Configuration
  disk {
    label            = "os"
    size             = 32
    thin_provisioned = true
    unit_number      = 0
  }
  disk {
    label            = "cache"
    size             = 16
    thin_provisioned = true
    unit_number      = 1
  }
  disk {
    label            = "data1"
    size             = var.data_disk_size
    thin_provisioned = true
    unit_number      = 2
  }

  # OVF Tempalte (deployed to destination vCenter)
  clone {
    template_uuid = data.vsphere_virtual_machine.root_template.id
    #template_uuid = data.vsphere_content_library_item.esxi_template.id
  }

  # OVF Template / vApp Properties
  vapp {
    properties = {
      "guestinfo.hostname"  = each.key,
      "guestinfo.ipaddress" = each.value,
      "guestinfo.netmask"   = var.management_network_info["subnetmask"],
      "guestinfo.gateway"   = var.management_network_info["gateway"],
      "guestinfo.vlan"      = var.management_network_info["vlan"],
      "guestinfo.dns"       = var.dns,
      "guestinfo.domain"    = var.search_domain,
      "guestinfo.ntp"       = var.ntp,
      "guestinfo.password"  = "${var.passwords["root"]}",
      "guestinfo.ssh"       = "True",
      "guestinfo.followmac" = "True"
    }
  }

  lifecycle {
    ignore_changes = [
      vapp[0]
    ]
  }

  # ESXi Customizations
  provisioner "remote-exec" {
    inline = [
      # vSAN Configuration - SSD
      "esxcli storage nmp satp rule add --satp=VMW_SATP_LOCAL --device mpx.vmhba0:C0:T1:L0 --option \"enable_ssd\"",
      "esxcli storage nmp satp rule add --satp=VMW_SATP_LOCAL --device mpx.vmhba0:C0:T2:L0 --option \"enable_ssd\"",
      "esxcli storage hpp device set -d mpx.vmhba0:C0:T1:L0 -M 1",
      "esxcli storage hpp device set -d mpx.vmhba0:C0:T2:L0 -M 1",
      "esxcli storage core claiming reclaim -d mpx.vmhba0:C0:T1:L0",
      "esxcli storage core claiming reclaim -d mpx.vmhba0:C0:T2:L0",
      # vSAN Configuration - Mark disk1 as "Capacity"
      "esxcli vsan storage tag add -t capacityFlash -d mpx.vmhba0:C0:T2:L0",
      # Regenerate Self-Signed Certificates
      #"/sbin/generate-certificates",
      # Restart Services
      #"/etc/init.d/hostd restart && /etc/init.d/vpxa restart"
    ]
    connection {
      type     = "ssh"
      user     = "root"
      password = var.passwords["root"]
      host     = each.key
    }
  }
}
# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "hosts" {
  value = values(vsphere_virtual_machine.nested_iaas_host).*.name
}