# --------------------------------------------------------------- #
# Network Pool Configuration
# --------------------------------------------------------------- #
network_pool_name = "rack1_cl01"
network_pool_type = {
  VMOTION = {
    subnet  = "10.0.0.0"
    gateway = "10.0.0.1"
    mask    = "255.255.255.0"
    vlan    = 1222
    mtu     = 8000
  },
  VSAN = {
    subnet  = "10.0.1.0"
    gateway = "10.0.1.1"
    mask    = "255.255.255.0"
    vlan    = 1223
    mtu     = 8000
  }
}