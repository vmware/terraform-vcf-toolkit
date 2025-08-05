# Release Version #.# | DD.MM.YYYY

Description

## What's New? 🔥

Description

## Integrations 🤖

Description
**Terraform Providers:**

- [VCF](https://registry.terraform.io/providers/vmware/vcf/latest) for Cloud Builder deployment, SDDC Manager, Management Domain creation and Workload Domain creation.
  - *developed and tested against version `0.8.1`*
- [NSX](https://registry.terraform.io/providers/vmware/nsxt/latest) for NSX Edge-Cluster deployment, Logical Routing and Firewall configuration(s).
  - *developed and tested against version `3.6.0`*
- [vSphere](https://registry.terraform.io/providers/hashicorp/vsphere/latest) for meta data management, DRS and administration (Folders, Resource-Pools and Port-Groups).
  - *developed and tested against version `2.6.1`*

## Improvements 🛠️

Description

## In Development 🏗️

Description

## Known Issues 🐞

Description

- **NSX** | `terraform destroy` can be particular with object depedencies/number of actions and may need to run multiple times to clean up.state
- **VCF** | The provider currently is focused on VCF 4.5, but majority of functions work with 5.0 and 5.1.  Use at own risk and development for other versions.

## Bug Fixes 🪲
