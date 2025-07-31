vcenter_server   = "vcenter.example.com"
vcenter_username = "administrator@vsphere.local"
vcenter_password = "P@ssword1"

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
    name       = "example-vsan"
    datacenter = "example-dc"
  }
}
