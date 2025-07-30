# --------------------------------------------------------------- #
# Application - XYZ
# --------------------------------------------------------------- #
scope = "steve"
tag   = "application1"
# --------------------------------------------------------------- #
# Groups
# --------------------------------------------------------------- #
policy_groups = {
  steve_vm_all = {
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
        dst_groups = ["steve_vm_all"]
        action     = "ALLOW"
        services   = ["HTTPS"]
      },
      rule2 = {
        name       = "ssh_traffic"
        src_groups = ["steve_vm_all"]
        dst_groups = ["steve_vm_all"]
        action     = "ALLOW"
        services   = ["SSH", "HTTPS"]
      }
    }
  }
}