terraform {
  required_providers {
    nsxt = {
      source  = "vmware/nsxt"
      version = "3.8.0"
    }
    vsphere = {
      source  = "vmware/vsphere"
      version = "2.16.1"
    }
  }
}

### NSX Domains
provider "nsxt" {
  alias                = "mgmt"
  username             = "admin"
  password             = "VMware1!VMware1!"
  host                 = ""
  allow_unverified_ssl = true
}

provider "nsxt" {
  alias                = "workload1"
  username             = "admin"
  password             = "VMware1!VMware1!"
  host                 = ""
  allow_unverified_ssl = true
}

###  vCenter Domains

provider "vsphere" {
  alias          = "mgmt"
  user           = "administrator@vsphere.local"
  password       = "VMware1!VMware1!"
  vsphere_server = ""

  allow_unverified_ssl = true
}


module "VCF_Management_Tags" {
  source = "./tags"
  # --------------------------------------------------------------- #
  # This module creates and associates NSX tags to the discovered VMs.
  # --------------------------------------------------------------- #
  providers = {
    vsphere = vsphere.mgmt
    nsxt    = nsxt.mgmt
  }

  datacenter = "mgmt-dc01"
  cluster    = "mgmt-cl01"

  vm_tag_mapping = {
    sddc = {
      tags = [
        {
          tag   = "sddc"
          scope = "mgmt"
        }
      ]
    },
    vcenter-mgmt = {
      tags = [
        {
          tag   = "vcenter"
          scope = "mgmt"
        }
      ]
    },
    nsx01-mgmt = {
      tags = [
        {
          tag   = "nsx"
          scope = "mgmt"
        }
      ]
    },
  }
}

module "VCF_Management_Grouping" {
  depends_on = [module.VCF_Management_Tags]
  source     = "./groups"
  # --------------------------------------------------------------- #
  # This module creates NSX Object grouping 
  # --------------------------------------------------------------- # 
  providers = {
    nsxt = nsxt.mgmt
  }

  policy_groups = {
    # Appliances
    vcf_mgmt_sddc = {
      expression = [
        {
          key         = "Tag"
          member_type = "VirtualMachine"
          operator    = "EQUALS"
          value       = "mgmt|sddc"
        },
      ]
    },
    vcf_mgmt_vcenter = {
      expression = [
        {
          key         = "Tag"
          member_type = "VirtualMachine"
          operator    = "EQUALS"
          value       = "mgmt|vcenter"
        },
      ]
    },
    vcf_mgmt_nsx = {
      expression = [
        {
          key         = "Tag"
          member_type = "VirtualMachine"
          operator    = "EQUALS"
          value       = "mgmt|nsx"
        },
      ]
    },

    # ESX hosts Rack 1
    rack1_esx_hosts = {
      expression = [
        {
          ip_addresses = ["10.192.192.11-10.192.192.254", "10.192.192.10"]
        },
      ]
    },
  }
}

module "VCF_Management_Components" {
  depends_on = [module.VCF_Management_Grouping]
  source     = "./policy"
  # --------------------------------------------------------------- #
  # This module implements the defined VCF Management Components Policy
  # for microsegmentation of the VCF core appliances.
  # --------------------------------------------------------------- #
  providers = {
    nsxt = nsxt.mgmt
  }

  policy = {

    "VCF_Management_Components" = {
      category    = "Infrastructure"
      description = "VCF Management Domain - Default VCF Communications."
      stateful    = true
      tcp_strict  = false
      locked      = true

      rules = {
        # --------------------------------
        # vCenter Rules
        # --------------------------------
        "vCenter to SDDC" = {
          src_groups = ["vcf_mgmt_vcenter"]
          dst_groups = ["vcf_mgmt_sddc"]
          action     = "ALLOW"
          services   = []
          scope      = ["vcf_mgmt_vcenter", "vcf_mgmt_sddc"] # example of good practice
          log    = true
          log_label = "vcf_mgmt_vms" # example of good practice for SYSLOG
        },
        "vCenter to Hosts" = {
          src_groups = ["vcf_mgmt_vcenter"]
          dst_groups = ["rack1_esx_hosts"]
          action     = "ALLOW"
          services   = []
          log    = true
        },
        "vCenter to NSX" = {
          src_groups = ["vcf_mgmt_vcenter"]
          dst_groups = ["vcf_mgmt_nsx"]
          action     = "ALLOW"
          services   = []
          log    = true
        },
        # --------------------------------
        # NSX Rules
        # --------------------------------
        "NSX to vCenter" = {
          src_groups = ["vcf_mgmt_nsx"]
          dst_groups = ["vcf_mgmt_vcenter"]
          action     = "ALLOW"
          services   = []
          log    = true
        },
        "NSX to ESX Hosts" = {
          src_groups = ["vcf_mgmt_nsx"]
          dst_groups = ["rack1_esx_hosts"]
          action     = "ALLOW"
          services   = []
          log    = true
        },
        # --------------------------------
        # SDDC Rules
        # --------------------------------
        "SDDC to vCenter" = {
          src_groups = ["vcf_mgmt_sddc"]
          dst_groups = ["vcf_mgmt_vcenter"]
          action     = "ALLOW"
          services   = []
          log    = true
        },
        "SDDC to NSX" = {
          src_groups = ["vcf_mgmt_sddc"]
          dst_groups = ["vcf_mgmt_nsx"]
          action     = "ALLOW"
          services   = []
          log    = true
        },
        "SDDC to ESX" = {
          src_groups = ["vcf_mgmt_sddc"]
          dst_groups = ["rack1_esx_hosts"]
          action     = "ALLOW"
          services   = []
          log    = true
        },
      }
    }
  }
}