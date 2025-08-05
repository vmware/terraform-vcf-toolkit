# --------------------------------------------------------------- #
# NSX-T Authentication Variables
# --------------------------------------------------------------- #
nsx_manager  = "172.16.104.13"
nsx_username = "admin"
nsx_password = "VMware1!VMware1!"

# --------------------------------------------------------------- #
# HA-TEP Module Variables
# --------------------------------------------------------------- #
host_switch_uuid = "50 14 59 f5 33 6f ff 94-96 d1 69 8d f4 9d a8 3a"
ip_pool          = "cl01_ip_pool"
uplink_profile   = "mgmt-vc-cl01-mgmt_dvs"
tz_overlay       = "cl01_tz_overlay"
#
ha_tep_profile = {
  name = "ha_tep_test"
}
#
host_tnp = {
  name = "cluster1_ha_tep"
  uplink_mapping = {
    uplink1 = "uplink-1"
    uplink2 = "uplink-2"
  }
}