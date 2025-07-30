vcenter_server   = "lvn-mgc1-vc1.lvn.broadcom.net"
vcenter_username = "administrator@vsphere.local"
vcenter_password = "Vmware@234##"

tag_category = {
  name         = "tanzu_k8s"
  object_types = ["Datastore"]
}

tags = {
  name     = "tanzu"
  category = "tanzu_k8s"
}

storage_policy = {
  tag_category_name = "tanzu_k8s"
  tag_name          = "tanzu"
  name              = "tanzu_storage_policy"
  datastore = {
    name       = "lvn-lm2-m1c1-vsan"
    datacenter = "lvn-lm2-dc"
  }
}