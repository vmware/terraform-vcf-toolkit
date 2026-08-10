# <span style="color:lightgreen">Version 1.4</span> - In Progress

This release focuses on VCF 9.0:

## What's New? 🔥

- VCF
  - **/modules/vcf_bringup_9.0.1**
    - Overall rework of base logic for new VCF deployment workflow.

- NSX
  - **/modules/appliances/vdefend_ssp/**
    - Module for vDefend SSP Installer OVA (via Content Library).
  - **/modules/dfw/tags**
    - Module for discovering VM vSphere ID, creation of tags and application of Tag to NSX VM.
  - **/modules/dfw/services**
    - Module to define custom services.
  - **/modules/dfw/groups**
    - Module to define NSX Groups with Tags or IP based criteria.
  - **/modules/dfw/policy**
    - Module to define an NSX Securiy Policy with a comprehensive set of firewall rules with misc. attributes.
  - Library Item - **/library/vcf/secure_vcf_demo.tf**
    - Structural representation of VCF Management Domain implementation defined as a template for customers to build from.
    - MVP component, but not complete (at this time).

- LAB

## Integrations 🤖

**Terraform Providers:**

- [VCF](https://registry.terraform.io/providers/vmware/vcf/latest) for Cloud Builder deployment, SDDC Manager, Management Domain creation and Workload Domain creation.
  - *developed and testing against version `0.17.0`*
- [NSX](https://registry.terraform.io/providers/vmware/nsxt/latest) for NSX Edge-Cluster deployment, Logical Routing and Firewall configuration(s).
  - *developed and tested against version `3.9.0`*
- [vSphere](https://registry.terraform.io/providers/vmware/vsphere/latest) for meta data management, DRS and administration (Folders, Resource-Pools and Port-Groups).
  - *developed and tested against version `2.15.0`*

## Improvements 🛠️

- Lab modules updates for nested deployment workflows.
  
## In Development 🏗️

- vDefend Modules for Security Services Platform (SSP) and Distributed Firewall Groups, Services, Policies and Rules.

## Known Issues 🐞

## Bug Fixes 🪲

# <span style="color:lightblue">Previous Releases</span>

| Version | Type | Notes |
|---|---|---|
| [v1.0](/docs/changelog/v1.0.md) | MAJOR | Initial release of Terraform Toolkit |
| [v1.01](/docs/changelog/v1.0.1.md) | MINOR | Misc fixes, typos, etc. |
| [v1.1](/docs/changelog/v1.1.md) | MAJOR | VCF modules and templates. |
| [v1.2](/docs/changelog/v1.2.md) | MAJOR | VCF 5.2.1 Certification.|
| [v1.3](/docs/changelog/v1.3.md) | MAJOR | VCF 5.2.1 Release.|