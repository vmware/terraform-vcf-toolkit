# Workload Domain

In this section we're going to cover the Workload Domain using the Terraform vSphere module. We will go over the providers, variables, and the main terraform file as well as execution and troubleshooting. If you don't have your IDE window open, please open it and go to the folder where you cloned the repository too. 

Create a new folder under **library**. We're going to call it **vmware_lab** in this example. Copy the **vcf_workload_domain_single_rack** folder under **library/vcf** to the **vmware_lab** folder that you just created above and rename it to **vcf_workload_domain**. Copy the **example_vcf_wld.tfvars** and save it under the **vmware_lab** folder as **vcf_wld.tfvars** It should look like the example below

![Workload Domain Folder Structure](../images/workload_domain_folder_structure.png)

--------------

## Workload Domain Providers

Now that we have a copy of the files, we're going to open the `providers.tf` file and take a look at it. The `providers.tf` file in Terraform specifies the external providers that Terraform will interact with. In this case, the file configures the VMware Cloud Foundation (VCF) provider, which is used for managing and deploying VMware Cloud Foundation resources such as SDDC Manager, ESXi hosts, and other VCF components.

### Terraform Block for Required Providers

This section specifies the required providers for the Terraform configuration, ensuring that the appropriate versions of the providers are used for the deployment.

```bash
terraform {
  required_providers {
    vcf = {
      source  = "vmware/vcf"
      version = "0.8.5"
    }
  }
}
```

- **terraform**: This block is a core component of Terraform configurations. It is used to define the necessary providers for the configuration and to specify the versions of the providers required for the setup.
- **required_providers**: Inside the `terraform` block, the `required_providers` block specifies which providers are required to manage resources. Here, it indicates that the `vcf` provider is necessary.
  - **source**: The `source` attribute defines where the provider can be obtained from. In this case, it is sourced from `"vmware/vcf"`, which refers to the official VMware Cloud Foundation provider available on the Terraform Registry.
  - **version**: The `version` attribute ensures that Terraform uses version `0.8.5` of the `vcf` provider. This helps maintain compatibility with the features and functionality expected in the deployment.

--------------

## Workload Domain Variables

Let's open the `vcf_wld.tfvars` file that we created from the example file. This `vcf_wld.tfvars` file is a Terraform variable configuration file that defines various settings related to the VMware Cloud Foundation (VCF) Workload Domain (WLD) environment. It includes authentication details, workload domain configuration, appliance settings, network pool configurations, and host commissioning data for the deployment. The key sections include:

- **SDDC Manager Authentication**: Credentials for accessing the SDDC Manager appliance, including its hostname, username, and password. These are necessary for authenticating and interacting with the VMware Cloud Foundation environment.
- **VCF Authentication Variables**: Sensitive passwords for various VMware Cloud Foundation components, such as vCenter, NSX Admin, and NSX Audit. These credentials are critical for secure deployment and ongoing management.
- **Workload Domain Environment Variables**: General configuration for the workload domain environment, including license keys (for NSX, vCenter, VSAN, and ESXi), and domain suffix for Fully Qualified Domain Names (FQDN) used within the workload domain.
- **VCF Workload Domain - Appliances**: Settings for critical appliances within the workload domain, such as vCenter and NSX-T. This includes VM sizes, storage sizes, names, FQDNs, IP addresses, and network configurations for high availability (HA).
- **VCF Workload Domain - Network Pools**: Configuration of network pools required for various network services in the workload domain. This includes subnet CIDRs, gateways, VLANs, MTUs, and port group names for management networks, vMotion, VSAN, and TEP (Tunnel End Point).
- **VCF Workload Domain - Host Commissioning**: Configuration for commissioning ESXi hosts into the workload domain. This includes the host names, UUIDs, and associated network interfaces (vmnic) used for host setup and management within the domain.

>> **All of the below screenshots, code snippets, etc are just examples. Please replace the values with the information for your environment**

### SDDC Manager Authentication

This section provides the credentials for authenticating with the VMware Cloud Foundation (VCF) SDDC Manager.

```bash
sddc_manager_host     = "sddc01.sddc.lab"
sddc_manager_username = "administrator@sddc.lab"
sddc_manager_password = "VMware1!VMware1!"
```

- **sddc_manager_host**: The hostname or IP address of the SDDC Manager.
- **sddc_manager_username**: The username used for authentication with the SDDC Manager (typically the administrator account).
- **sddc_manager_password**: The password for the SDDC Manager administrator account.


### VCF Authentication Variables - Sensitive/Redacted

This section defines the credentials for various VCF components such as vCenter and NSX, which are used to manage the VMware Cloud Foundation environment.

```bash
wld_passwords = {
  vcenter   = "VMware1!VMware1!"
  nsx_admin = "VMware1!VMware1!"
  nsx_audit = "VMware1!VMware1!"
}
```

- **vcenter**: The password for the vCenter administrator.
- **nsx_admin**: The password for the NSX administrator.
- **nsx_audit**: The password for the NSX audit user.

>> *Note: These variables contain sensitive information and should be protected and handled carefully.*

### VCF Environment Variables

This section defines the environment-specific configuration for the VCF workload domain.

```bash
license_keys = {
  nsx     = ""
  vcenter = ""
  vsan    = ""
  esxi    = ""
}
domain_suffix = "sddc.lab"
```

- **license_keys**: Placeholder for the product license keys required for NSX, vCenter, vSAN, and ESXi. These need to be filled with valid keys for the respective components.
- **domain_suffix**: The suffix used for the domain (e.g., `sddc.lab`).

### VCF Workload Domain - Appliances

This section provides configuration details for the vCenter and NSX appliances within the workload domain.

```bash
workload_domain_name = "wld1"
vcenter_configuration = {
  vm_size      = "tiny"
  storage_size = "lstorage"
  name         = "wld1-vcenter"
  fqdn         = "wld1-vcenter.sddc.lab"
  ip           = "10.0.1.21"
  subnet_mask  = "255.255.255.0"
  gateway      = "10.0.1.1"
}
```

- **workload_domain_name**: The name of the workload domain, in this case, `wld1`.
- **vcenter_configuration**: Configuration for the vCenter appliance, including:
  - **vm_size**: Size of the VM (e.g., `tiny`).
  - **storage_size**: Storage configuration (e.g., `lstorage`).
  - **name**: The name of the vCenter appliance.
  - **fqdn**: Fully Qualified Domain Name for the vCenter appliance.
  - **ip**, **subnet_mask**, **gateway**: IP configuration for the vCenter appliance.

```bash
nsx_settings = {
  size            = "small"
  vip_fqdn        = "wld1-nsxt.sddc.lab"
  vip             = "10.0.1.22"
  appliance1_name = "wld1-nsx01"
  appliance1_ip   = "10.0.1.23"
  appliance2_name = "wld1-nsx02"
  appliance2_ip   = "10.0.1.24"
  appliance3_name = "wld1-nsx03"
  appliance3_ip   = "10.0.1.25"
  subnet_mask     = "255.255.255.0"
  gateway         = "10.0.1.1"
}
```

- **nsx_settings**: Configuration for the NSX appliances, including:
  - **size**: Size of the NSX deployment (e.g., `small`).
  - **vip_fqdn**: Fully Qualified Domain Name for the NSX VIP (Virtual IP).
  - **appliance1_name**, **appliance1_ip**: Names and IPs for the NSX appliances (3 total).
  - **subnet_mask** and **gateway**: Network settings for NSX appliances.

### VCF Workload Domain - Network Pools

This section defines network pool configurations for the workload domain, detailing subnets, VLANs, MTU sizes, and IP ranges for various network services.

```bash
network_pool_mgmt_esxi = {
  subnet_cidr     = "10.0.2.0/24"
  gateway         = "10.0.2.1"
  vlan            = "2002"
  mtu             = 1500
  port_group_name = "sddc_esxi"
}
```

- **network_pool_mgmt_esxi**: Configuration for the ESXi management network, including:
  - **subnet_cidr**: Subnet for the network.
  - **gateway**: Gateway for the network.
  - **vlan**: VLAN ID for the network.
  - **mtu**: Maximum Transmission Unit (MTU) for the network.
  - **port_group_name**: Name of the port group in the network.

The same structure is followed for additional network pools: network_pool_mgmt_vmotion, network_pool_mgmt_vsan, and network_pool_mgmt_tep, each with their own specific network configurations.

### VCF Management Domain - Host Commissioning

This section defines settings related to the host commissioning process within the workload domain, such as the cluster configuration.

```bash
wld_cluster_settings = {
  name     = "wld1"
  vsan_ftt = "1"
  tep_vlan = "2005"
}
```

- **wld_cluster_settings**: Defines the cluster name and settings related to the VSAN Fault Tolerance (FTT) level and TEP VLAN for the workload domain.

### VCF Management Domain - Host Commissioning

This section provides the host information for the workload domain, specifying ESXi host configurations for deployment.

```bash
wld_hosts = {
  "esxi05.sddc.lab" = ["UUID", "vmnic0", "vmnic1"]
  "esxi06.sddc.lab" = ["UUID", "vmnic0", "vmnic1"]
  "esxi07.sddc.lab" = ["UUID", "vmnic0", "vmnic1"]
  "esxi08.sddc.lab" = ["UUID", "vmnic0", "vmnic1"]
}
```

- **wld_hosts**: Defines the ESXi hosts to be used in the workload domain, including the hostnames and associated details like UUIDs and network interfaces (e.g., `vmnic0`, `vmnic1`).

--------------

## Workload Domain Main

Let's open the `vcf_wld.tf` file. The `vcf_wld.tf` main file is used to configure and deploy a VMware Cloud Foundation (VCF) Workload Domain (WLD) using a Terraform module. This file leverages a module located in the `../../../modules/vcf/workload_domain` path, which encapsulates the logic and resources necessary to create a workload domain in a VCF environment.

### Module Block

The file defines a Terraform `module` block, which sources the configuration from the specified module directory and passes input variables into the module to configure the VCF workload domain.

```bash
module "vcf_workload_domain" {
  source = "../../../modules/vcf/workload_domain"
```

- **source**: The module is sourced from the relative path `../../../modules/vcf/workload_domain`. This path points to the location of the module that defines the resources and logic for deploying a workload domain in VCF.

### Module Configuration

The following variables are passed into the `vcf_workload_domain` module to customize the configuration for the workload domain:

```bash
workload_domain_name = var.workload_domain_name
domain_suffix        = var.domain_suffix
license_keys         = var.license_keys
```

- **workload_domain_name**: The name of the workload domain to be created (e.g., `wld1`).
- **domain_suffix**: The domain suffix used in Fully Qualified Domain Names (FQDN) within the workload domain (e.g., `sddc.lab`).
- **license_keys**: License keys for essential VCF components, such as NSX, vCenter, VSAN, and ESXi.

```bash
wld_passwords         = var.wld_passwords
vcenter_configuration = var.vcenter_configuration
nsx_settings          = var.nsx_settings
```

- **wld_passwords**: Passwords for critical VCF components, including vCenter, NSX Admin, and NSX Audit.
- **vcenter_configuration**: Configuration settings for the vCenter appliance within the workload domain, including its size, FQDN, and network settings.
- **nsx_settings**: Configuration for the NSX appliance, including its size, VIP FQDN, appliance names, IP addresses, and network settings.

```bash
wld_cluster_settings  = var.wld_cluster_settings
network_pool_host_tep = var.network_pool_host_tep
wld_hosts             = var.wld_hosts
```

- **wld_cluster_settings**: Settings related to the workload domain cluster, such as the cluster name, VSAN Fault Tolerance (FTT) level, and TEP VLAN configuration.
- **network_pool_host_tep**: Configuration for the TEP (Tunnel End Point) network pool, including its subnet CIDR, gateway, VLAN, and other network settings.
- **wld_hosts**: List of ESXi hosts that will be included in the workload domain. This includes hostnames, UUIDs, and network interface configurations.

--------------

## Workload Domain Execution

1. Initialize Terraform and install the required Providers and Modules by running:
```terraform init```
1. Plan the deployment and validate configuration.
```terraform plan -out vmware_lab -var-file="vcf_wld.tfvars"```
1. Apply the configuration
```terraform apply vmware_lab```
1. If the apply worked successfully, you should see something that looks like the screenshot below. If you have a failure, please check the [Workload Domain Troubleshooting](#workload-domain-troubleshooting) section for more information.

>> **Insert screenshot for successful execution**

--------------

## Workload Domain Troubleshooting

When deploying or configuring a VMware Cloud Foundation (VCF) workload domain using the `vcf_wld.tf` files, there may be several common issues that can occur. Below are some sample failure scenarios and steps to troubleshoot.

### Authentication to SDDC Manager

```bash
Error: Failed to authenticate with SDDC Manager
```

- **Possible Causes**:
  - Incorrect SDDC Manager credentials.
  - Incorrect hostname for the SDDC Manager.
  - Network issues preventing communication with the SDDC Manager.
- **What to Check**:
  - Verify that the `sddc_manager_host`, `sddc_manager_username`, and `sddc_manager_password` variables are correct and match the credentials in your VCF environment.
  - Confirm that the SDDC Manager host is reachable by running a `ping` or `nslookup` to ensure DNS resolution and connectivity.
  - If using self-signed certificates, ensure that the `allow_unverified_tls` option is set to `true`.

### Invalid or Missing License Keys

```bash
Error: Invalid license key for vCenter or NSX
Error: Missing or invalid license keys for vCenter, NSX, or vSAN
```

- **Possible Causes**:
  - Missing or incorrect license keys for required VCF components (e.g., vCenter, NSX, VSAN, ESXi).
  - A typo or wrong format in the `license_keys` map.
- **What to Check**:
  - Ensure that the `license_keys` map in the `vcf_wld.tfvars` file contains valid keys for all required components (`vcenter`, `nsx`, `vsan`, `esxi`).
  - Double-check that there are no typographical errors or missing entries in the keys.
  - Confirm that the license keys are valid and are compatible with the version of VCF being deployed.

### Incorrect vCenter Configuration

```bash
Error: Invalid VM size specified for vCenter.
Error: Failed to deploy vCenter appliance.
```

- **Possible Causes**:
  - Incorrect `vcenter_configuration` settings such as an unsupported VM size or storage size.
  - Mismatch between the vCenter FQDN and DNS settings.
- **What to Check**:
  - Verify that the `vcenter_configuration` values in the `vcf_wld.tfvars` file, such as `vm_size`, `storage_size`, `name`, `fqdn`, and `ip`, are correct and supported.
  - Ensure that DNS resolution works for the `fqdn` specified for the vCenter appliance.
  - Confirm that the VM size and storage size align with the available resources in your environment.

### NSX-T Deployment Issues

```bash
Error: Failed to deploy NSX-T appliance.
Error: NSX-T appliance configuration failed.
```

- **Possible Causes**:
  - Invalid or incomplete `nsx_settings` (e.g., missing IP addresses or appliance names).
  - Network issues preventing NSX appliances from communicating with each other.
- **What to Check**:
  - Ensure the `nsx_settings` variables, such as `vip_fqdn`, `appliance1_name`, `appliance1_ip`, `appliance2_ip`, and `subnet_mask`, are correctly defined in the `vcf_wld.tfvars` file.
  - Verify that the IPs for the NSX appliances are correctly allocated and do not overlap with other appliances or systems.
  - Ensure that all necessary network routes are configured correctly for NSX appliances to communicate with each other and with other VCF components.

### Network Configuration Issues (ESXi Hosts)

```bash
Error: Network configuration failed on ESXi hosts.
Error: Invalid network pool settings for management, vMotion, or vSAN.
```

- **Possible Causes**:
  - Incorrect or missing network pool configurations for management, vMotion, VSAN, or TEP.
  - Network connectivity issues between the ESXi hosts and required services (e.g., vCenter, NSX).
- **What to Check**:
  - Verify that network pool settings for `network_pool_mgmt_esxi`, `network_pool_mgmt_vmotion`, `network_pool_mgmt_vsan`, and `network_pool_mgmt_tep` are correct, including subnet CIDRs, gateways, VLANs, and MTUs.
  - Confirm that the network interfaces (`vmnic0`, `vmnic1`) are correctly mapped and that the ESXi hosts can reach the necessary IPs.
  - Check for any IP address conflicts or incorrect subnet configurations that could prevent proper network communication.

### Missing or Incorrect ESXi Hosts

  ```bash
  Error: Host not found during ESXi commissioning.
  Error: Failed to commission ESXi hosts.
  ```

- **Possible Causes**:
  - Incorrect host details in the `wld_hosts` map (e.g., missing or invalid UUIDs, network interfaces).
  - Network issues preventing communication with the ESXi hosts.
- **What to Check**:
  - Ensure that the `wld_hosts` variable in the `vcf_wld.tfvars` file is populated with the correct ESXi host names, UUIDs, and associated network interfaces.
  - Verify that the ESXi hosts are powered on and reachable via the network.
  - Confirm that the correct network interfaces (`vmnic0`, `vmnic1`) are configured and that the host networking is working properly.

### Cluster Configuration Issues

```bash
Error: Cluster creation failed.
Error: Failed to apply VSAN settings during cluster setup.
```

- **Possible Causes**:
  - Incorrect `wld_cluster_settings`, such as a misconfigured `vsan_ftt` value or invalid TEP VLAN settings.
  - Missing or conflicting configurations in the cluster setup.
- **What to Check**:
  - Ensure that the `wld_cluster_settings` variable, including `vsan_ftt`, `tep_vlan`, and other cluster-specific settings, is correctly configured.
  - Check the network connectivity for the TEP VLAN to ensure that the Tunnel End Point (TEP) network is properly configured and accessible by all ESXi hosts in the cluster.
