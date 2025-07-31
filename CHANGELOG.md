<img src = "./docs/images/bcom_header.png" width=100%>

# <span style="color:lightgreen">Version 1.3</span> - In Progress

This release focuses on VCF 5.2.1:

## What's New? 🔥

- PSO
  - **/library/pso/mpc_single_rack**
    - This is a single rack guided VCF and NSX topology deployment.

- VCF
  - **/modules/vcf_bringup_5.2.1**
    - Overall rework of base logic and variable structure to reduce variable size.
    - Cleaner **vcf_bringup.tfvars** template for guided end-user completion.

- NSX
  - **/modules/ha_tep**
    - Defines new Transport-Node Profile and HA TEP Profile to be applied during maintenance window or greenfield deployments.
  - **/modules/edge_cluster**
    - Complete rework of deployment logic and variables.  One module for single or dynamic fault-domain placement.
    - Uniform Uplink-Profile for now, will be fault-domain specific in next iteration.
  - **/modules/dfw/application**
    - Tenantized example of an 'Application' template.  Policy Groups, Services, Rules, etc.

- LAB

## Integrations 🤖

Initial release leverage the public Hashicorp providers for VCF, vSphere and NSX.
**Terraform Providers:**

- [VCF](https://registry.terraform.io/providers/vmware/vcf/latest) for Cloud Builder deployment, SDDC Manager, Management Domain creation and Workload Domain creation.
  - *developed and testing against version `0.14.0`*
- [NSX](https://registry.terraform.io/providers/vmware/nsxt/latest) for NSX Edge-Cluster deployment, Logical Routing and Firewall configuration(s).
  - *developed and tested against version `3.8`*
- [vSphere](https://registry.terraform.io/providers/hashicorp/vsphere/latest) for meta data management, DRS and administration (Folders, Resource-Pools and Port-Groups).
  - *developed and tested against version `2.10.0`*

## Improvements 🛠️

- Lab modules updates for nested deployment workflows.

- **/modules/vcf/network_pool**
  - Variable and logic improvement.
- **/modules/vcf/host_commission**
  - Variable and logic improvement.
  
## In Development 🏗️

Creating additional resources and templates for standardizing object/variable definitions to further develop the toolkit.  **/lab** modules are mostly in development/high churn.

## Known Issues 🐞

- **LAB** | Content Library and Nested ESXI appliances broken for now due to Broadcom/VMware transition.  
  - See https://community.broadcom.com/developer-portal/discussion/nested-esxi-appliance-template-images for offline reworking.
  - https://community.broadcom.com/flings/home 
- **VCF** | The provider currently is focused on VCF 5.2, but baseline functions work with 5.2.1.  Use at own risk and development for other versions.
  - See https://community.broadcom.com/flings/home for offline reworking.

## Bug Fixes 🪲

# <span style="color:lightblue">Previous Releases</span>

| Version | Type | Notes |
|---|---|---|
| [v1.0](/docs/changelog/v1.0.md) | MAJOR | Initial release of Terraform Toolkit |
| [v1.01](/docs/changelog/v1.0.1.md) | MINOR | Misc fixes, typos, etc. |
| [v1.1](/docs/changelog/v1.1.md) | MAJOR | VCF modules and templates. |
| [v1.2](/docs/changelog/v1.2.md) | MAJOR | VCF 5.2.1 Certification.|
