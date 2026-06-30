# --------------------------------------------------------------- #
# Application - XYZ
# --------------------------------------------------------------- #
scope = "tenant1"
tag   = "application1"
# --------------------------------------------------------------- #
# Groups
# --------------------------------------------------------------- #
policy_groups = {
  tenant1_all_vms = {
    criteria = {
      criteria1 = {
        key         = "Tag"
        member_type = "VirtualMachine"
        operator    = "EQUALS"
        value       = "application1"
      },
    }
  }
}
# --------------------------------------------------------------- #
# Services
# --------------------------------------------------------------- #
services = {
  NTP = {
    ports = [123]
  }
  DNS = {
    ports = [53]
  }
  SSH = {
    ports = [22]
  }
  HTTP = {
    ports = [80, 8080]
  }
  HTTPS = {
    ports = [443]
  }
  CUSTOM = {
    ports = [1500]
  }
}

# --------------------------------------------------------------- #
# Policy
# --------------------------------------------------------------- #
security_policy = {
  "application1" = {
    rules = {
      rule1 = {
        name       = "https_traffic"
        src_groups = []
        dst_groups = ["tenant1_all_vms"]
        action     = "ALLOW"
        services   = ["HTTPS"]
      },
      rule2 = {
        name       = "ssh_traffic"
        src_groups = ["tenant1_all_vms"]
        dst_groups = ["tenant1_all_vms"]
        action     = "ALLOW"
        services   = ["SSH", "HTTPS"]
      }
    }
  }
}