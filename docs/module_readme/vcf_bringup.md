# Management Domain Bringup

In this section we're going to cover the Management Domain Bringup using the Terraform VCF module. We will go over the variables and the main terraform file as well as execution and troubleshooting. If you don't have your IDE window open, please open it and go to the folder where you cloned the repository too. 

Create a new folder under **library**. We're going to call it **vmware_lab** in this example. Copy the **vcf_bringup** folder under **library/vcf** to the **vmware_lab** folder that you just created above. Copy the **example_vcf_bringup.tfvars** and save it under the **vmware_lab** folder as **vcf_bringup.tfvars** It should look like the example below

![Bringup Folder Structure](../images/bringup_folder_structure.png)

--------------

## Management Domain Bringup Variables

Let's open the `vcf_bringup.tfvars` file that we created from the example file. This `vcf_bringup.tfvars` file contains configuration values for deploying and setting up the VMware Cloud Foundation (VCF) environment. It includes authentication details, VCF environment settings, appliance configurations, network pools, and host configurations for the VCF management domain. The key sections include:

- **Cloud Builder Authentication**: Credentials for accessing the Cloud Builder appliance, including its hostname, username, and password.
- **VCF Authentication Variables**: Sensitive passwords for various VMware Cloud Foundation (VCF) components, including vCenter Management, NSX-T Management, SSO, and SDDC Manager. These are critical for authentication and secure deployment.
- **VCF Environment Variables**: General configuration for the VCF environment, including license keys (for NSX, vCenter, vSAN, and ESXi), CEIP (Customer Experience Improvement Program) participation, DNS servers, and NTP servers.
- **VCF Management Domain - Appliances**: Settings for key VCF appliances such as vCenter, NSX-T, and SDDC Manager. These include appliance sizes, names, IPs, and configurations for high availability and clustering (e.g., NSX-T).
- **VCF Management Domain - Network Pools**: Configuration for network pools used by VCF management appliances, including subnets, gateways, VLANs, MTUs, and port group names for different traffic types (management, ESXi, vMotion, vSAN, TEP).
- **VCF Management Domain - vCenter/Cluster**: vCenter and cluster-related settings for managing the VCF infrastructure, including names for the vCenter datacenter, cluster, and distributed virtual switch (DVS), as well as network adapter configurations.
- **VCF Management Domain - Host Commissioning**: Configuration for commissioning ESXi hosts, including their IP addresses, network settings (subnet, gateway), and standard switch names.

>> **All of the below screenshots, code snippets, etc are just examples. Please replace the values with the information for your environment**

### Cloud Builder Authentication

```bash
cloud_builder_host     = "cloudbuilder.sddc.lab"
cloud_builder_username = "admin"
cloud_builder_password = "VMware1!VMware1!"
```

These variables define the authentication details for the Cloud Builder appliance:

- **cloud_builder_host**: The FQDN (Fully Qualified Domain Name) or IP address of the Cloud Builder VM.
- **cloud_builder_username**: The username used to authenticate to the Cloud Builder appliance (e.g., `admin`).
- **cloud_builder_password**: The password for the Cloud Builder appliance.

### VCF Authentication Variables - Sensitive/Redacted

```bash
sso_passwords = {
  vcenter_mgmt = "VMware1!VMware1!"
  psc          = "VMware1!VMware1!"
}

mgmt_nsxt_passwords = {
  admin = "VMware1!VMware1!"
  root  = "VMware1!VMware1!"
  audit = "VMware1!VMware1!"
}

sddc_passwords = {
  root = "VMware1!VMware1!"
  vcf  = "VMware1!VMware1!"
}
```

These blocks contain the passwords for sensitive management and infrastructure components within the VCF environment:

- **sso_passwords**: Passwords for SSO components such as vCenter Management (`vcenter_mgmt`) and Platform Services Controller (`psc`).
- **mgmt_nsxt_passwords**: Passwords for management NSX-T components, including admin, root, and audit accounts.
- **sddc_passwords**: Passwords for the root and VCF admin accounts on the SDDC Manager appliance.
  
>> *Note: These variables contain sensitive information and should be protected and handled carefully.*

### VCF Environment Variables

```bash
ceip = "false"
license_keys = {
  nsx     = ""
  vcenter = ""
  vsan    = ""
  esxi    = ""
}
domain_suffix = "sddc.lab"
dns           = ["10.0.1.2", "10.0.1.3"]
ntp           = ["10.0.1.2", "10.0.1.3"]
```

This section defines general environment-wide settings:

- **ceip**: The Customer Experience Improvement Program setting (whether or not to participate in telemetry collection). Set to `false` in this case.
- **license_keys**: Placeholder for the product license keys required for NSX, vCenter, vSAN, and ESXi. These should be filled in with appropriate license values.
- **domain_suffix**: The suffix used for the domain (e.g., `sddc.lab`).
- **dns**: A list of DNS servers for the VCF environment.
- **ntp**: A list of NTP servers for time synchronization within the VCF environment.

### VCF Management Domain - Appliances

```bash
vcenter_mgmt = {
  size = "small"
  name = "mgmt-vcenter"
  ip   = "10.0.1.11"
}

nsx_mgmt = {
  size            = "medium"
  name            = "mgmt-nsxt"
  vip             = "10.0.1.12"
  appliance1_name = "mgmt-nsx01"
  appliance1_ip   = "10.0.1.13"
  appliance2_name = "mgmt-nsx02"
  appliance2_ip   = "10.0.1.14"
  appliance3_name = "mgmt-nsx03"
  appliance3_ip   = "10.0.1.15"
}

sddc_manager = {
  name = "sddc01"
  ip   = "10.0.1.10"
}
```

This section contains the configuration for the management appliances in the VCF environment:

- **vcenter_mgmt**: Configuration for the vCenter appliance (`mgmt-vcenter`), including the size and IP address.
- **nsx_mgmt**: Configuration for the NSX-T management appliances, including the size, VIP, and the names and IP addresses of the individual appliances (e.g., `mgmt-nsx01`, `mgmt-nsx02`, `mgmt-nsx03`).
- **sddc_manager**: Configuration for the SDDC Manager appliance (`sddc01`), including its IP address.

### VCF Management Domain - Network Pools

```bash
network_pool_mgmt_appliances = {
  subnet_cidr     = "10.0.1.0/24"
  gateway         = "10.0.1.1"
  vlan            = "0"
  mtu             = 1500
  port_group_name = "mgmt_appliances"
}

network_pool_mgmt_esxi = {
  subnet_cidr     = "10.0.2.0/24"
  gateway         = "10.0.2.1"
  vlan            = "2002"
  mtu             = 1500
  port_group_name = "esxi"
}

network_pool_mgmt_vmotion = {
  subnet_cidr     = "10.0.3.0/24"
  gateway         = "10.0.3.1"
  vlan            = "2003"
  mtu             = 9000
  port_group_name = "vmotion"
  range_start     = "10.0.3.10"
  range_end       = "10.0.3.99"
}

network_pool_mgmt_vsan = {
  subnet_cidr     = "10.0.4.0/24"
  gateway         = "10.0.4.1"
  vlan            = "2004"
  mtu             = 9000
  port_group_name = "vsan"
  range_start     = "10.0.4.10"
  range_end       = "10.0.4.99"
}

network_pool_mgmt_tep = {
  subnet_cidr     = "10.0.5.0/24"
  gateway         = "10.0.5.1"
  vlan            = "2005"
  mtu             = 9000
  port_group_name = "host_tep"
  range_start     = "10.0.5.10"
  range_end       = "10.0.5.99"
  tz_overlay_name = "tz-overlay"
}
```

This section defines network pool configurations for the VCF management domain:

- **network_pool_mgmt_appliances**: The network settings for management appliances, including the subnet, gateway, VLAN, MTU, and port group.
- **network_pool_mgmt_esxi**: Network pool configuration for ESXi hosts.
- **network_pool_mgmt_vmotion**: Network pool for vMotion traffic, with a specific IP range for vMotion.
- **network_pool_mgmt_vsan**: Network pool for vSAN traffic, with a defined IP range.
- **network_pool_mgmt_tep**: Network pool for Tunnel Endpoints (TEPs), including an IP range and the overlay transport zone name.

### VCF Management Domain - vCenter/Cluster

```bash
psc_domain              = "sddc.lab"
mgmt_vc_datacenter_name = "mgmt_dc"
mgmt_vc_cluster_name    = "mgmt_cluster"
mgmt_cluster_vsan_name  = "mgmt_vsan"
mgmt_vc_dvs = {
  name    = "mgmt_dvs"
  version = "8.0.0"
  mtu     = "9000"
  uplinks = ["vmnic0", "vmnic1", "vmnic2", "vmnic3"]
}
```

This section contains the configuration for vCenter and cluster settings:

- **psc_domain**: The domain for the Platform Services Controller (PSC) (e.g., `sddc.lab`).
- **mgmt_vc_datacenter_name**: The name of the vCenter datacenter.
- **mgmt_vc_cluster_name**: The name of the vCenter cluster.
- **mgmt_cluster_vsan_name**: The name of the vSAN datastore.
- **mgmt_vc_dvs**: Configuration for the vSphere Distributed Switch (DVS), including the name, version, MTU, and uplink network adapters.

### VCF Management Domain - Host Commissioning

```bash
standard_switch_name = "vSwitch0"

hosts = {
  "esxi01.sddc.lab" = ["10.0.2.11", "255.255.255.0", "10.0.2.1", "VMware1!"]
  "esxi02.sddc.lab" = ["10.0.2.12", "255.255.255.0", "10.0.2.1", "VMware1!"]
  "esxi03.sddc.lab" = ["10.0.2.13", "255.255.255.0", "10.0.2.1", "VMware1!"]
  "esxi04.sddc.lab" = ["10.0.2.14", "255.255.255.0", "10.0.2.1", "VMware1!"]
}
```

This section contains configurations for host commissioning:

- **standard_switch_name**: The name of the standard vSwitch used for networking (e.g., `vSwitch0`).
- **hosts**: A dictionary containing the ESXi hosts in the VCF environment, with each host's FQDN, IP address, subnet mask, gateway, and password.

--------------

## Management Domain Bringup Main

Let's open the `vcf_bringup.tf` file. This `vcf_bringup.tf` file is a Terraform module that is responsible for provisioning and configuring a VMware Cloud Foundation (VCF) instance. It references a series of variables that provide detailed configuration for:

- Cloud Builder appliance deployment and authentication.
- Network settings, including DNS, NTP, and network pools for management, vMotion, and vSAN traffic.
- The setup of critical VCF appliances such as SDDC Manager, vCenter, and NSX-T.
- Authentication details for various VCF components, including SSO and root passwords.
- vCenter cluster settings and host commissioning for ESXi hosts.

This file integrates with other Terraform files, like the `vcf_bringup.tfvars`, and defines the exact parameters to be used during VCF instance provisioning. It provides a comprehensive and automated approach to deploying the VCF management domain and related infrastructure.

### Module Configuration

```bash
module "vcf_instance" {
  source = "../../../modules/vcf/bringup"
```

This section declares the use of a reusable Terraform module located at `../../../modules/vcf/bringup`. The module will be responsible for bringing up the VCF instance by provisioning all required resources.

### Cloud Builder Appliance Settings

```bash
cloud_builder_host     = var.cloud_builder_host
cloud_builder_username = "admin"
cloud_builder_password = var.cloud_builder_password
```

- **cloud_builder_host**: The FQDN or IP address of the Cloud Builder appliance.
- **cloud_builder_username**: The username for authenticating to the Cloud Builder appliance (fixed as `admin`).
- **cloud_builder_password**: The password for the Cloud Builder appliance, provided via a variable.

### Environment Variables

```bash
vcf_dns       = var.vcf_dns
vcf_ntp       = var.vcf_ntp
domain_suffix = var.domain_suffix
```

- **vcf_dns**: The DNS servers for the VCF environment.
- **vcf_ntp**: The NTP servers for time synchronization within the VCF environment.
- **domain_suffix**: The domain suffix (e.g., `sddc.lab`).

### Licensing & CEIP

```bash
license_keys = var.license_keys
ceip         = var.ceip
```

- **license_keys**: A map of license keys for VCF components such as NSX, vCenter, vSAN, and ESXi.
- **ceip**: Customer Experience Improvement Program (CEIP) setting (whether to participate in telemetry).

### SDDC Manager Configuration - Network Pools

```bash
network_pool_mgmt_appliances = var.network_pool_mgmt_appliances
network_pool_mgmt_esxi       = var.network_pool_mgmt_esxi
network_pool_mgmt_vmotion    = var.network_pool_mgmt_vmotion
network_pool_mgmt_vsan       = var.network_pool_mgmt_vsan
network_pool_mgmt_tep        = var.network_pool_mgmt_tep
```

- **network_pool_mgmt_appliances**: Network configuration for management appliances (e.g., vCenter, NSX).
- **network_pool_mgmt_esxi**: Network pool for ESXi hosts.
- **network_pool_mgmt_vmotion**: Network pool for vMotion traffic.
- **network_pool_mgmt_vsan**: Network pool for vSAN traffic.
- **network_pool_mgmt_tep**: Network pool for Tunnel Endpoint (TEP) traffic in NSX.

### Management Domain Configuration - Appliances

```bash
sddc_manager = var.sddc_manager
vcenter_mgmt = var.vcenter_mgmt
nsx_mgmt     = var.nsx_mgmt
```

- **sddc_manager**: Configuration of the SDDC Manager appliance.
- **vcenter_mgmt**: Configuration of the vCenter management appliance.
- **nsx_mgmt**: Configuration of the NSX-T management appliances.

### Management Domain Configuration - Authentication

```bash
sso_passwords       = var.sso_passwords
mgmt_nsxt_passwords = var.mgmt_nsxt_passwords
sddc_passwords      = var.sddc_passwords
```

- **sso_passwords**: Authentication passwords for SSO-related services.
- **mgmt_nsxt_passwords**: Passwords for NSX-T management components.
- **sddc_passwords**: Passwords for the SDDC Manager and root accounts.

### Management Domain Configuration - vCenter Configuration

```bash
psc_domain              = var.psc_domain
mgmt_vc_datacenter_name = var.mgmt_vc_datacenter_name
mgmt_vc_cluster_name    = var.mgmt_vc_cluster_name
mgmt_vc_dvs             = var.mgmt_vc_dvs
mgmt_cluster_vsan_name  = var.mgmt_cluster_vsan_name
```

- **psc_domain**: The domain for the Platform Services Controller (PSC).
- **mgmt_vc_datacenter_name**: Name of the vCenter datacenter.
- **mgmt_vc_cluster_name**: Name of the vCenter cluster.
- **mgmt_vc_dvs**: Configuration of the Distributed Virtual Switch (DVS), including name, version, MTU, and uplinks.
- **mgmt_cluster_vsan_name**: Name of the vSAN datastore for the management cluster

### Host Commissioning

```bash
standard_switch_name = var.standard_switch_name
hosts                = var.hosts
```

- **standard_switch_name**: The name of the standard vSwitch used for ESXi host networking.
- **hosts**: A map of ESXi host configurations, including their IP addresses, network settings, and credentials.

--------------

## Management Domain Bringup Execution

1. Initialize Terraform and install the required Providers and Modules by running:
```terraform init```
1. Plan the deployment and validate configuration.
```terraform plan -out vmware_lab -var-file="vcf_bringup.tfvars"```
1. Apply the configuration
```terraform apply vmware_lab```
1. If the apply worked successfully, you should see something that looks like the screenshot below. If you have a failure, please check the [Management Domain Bringup Troubleshooting](#management-domain-bringup-troubleshooting) section for more information.

>> **Insert screenshot for successful execution**

--------------

## Management Domain Bringup Troubleshooting

When deploying VMware Cloud Foundation (VCF) using Terraform, various issues can arise during the configuration and provisioning process. Below is a list of common failures, their potential causes, and suggested checks to help resolve these issues.

### Cloud Builder Fails

```bash
Error: "cloud_builder_host" or "cloud_builder_password" is incorrect.
```

- **Possible Causes**:
  - Incorrect Cloud Builder appliance hostname or IP address.
  - Incorrect Cloud Builder password or username.
- **What to Check**:
  - Verify that the `cloud_builder_host` variable points to the correct Cloud Builder appliance hostname or IP address.
  - Double-check that the username (`admin`) and password for the Cloud Builder appliance are correct and match the credentials configured in `cloud_builder_password`.
  - Ensure that the Cloud Builder VM is accessible and running.

### SDDC Manager or vCenter Authentication Fails

```bash
Error: "sddc_manager" or "vcenter_mgmt" authentication failed.
```

- **Possible Causes**:
  - Incorrect `sddc_manager` or `vcenter_mgmt` credentials (username/password).
  - Network issues or connectivity problems to the SDDC Manager or vCenter.
- **What to Check**:
  - Confirm that the `sddc_manager` and `vcenter_mgmt` credentials are correct in the variables file (e.g., `sddc_passwords`, `mgmt_nsxt_passwords`).
  - Ensure the network configuration (DNS, IP, and NTP) is correct and that the SDDC Manager and vCenter are reachable.
  - Validate the firewall rules and security groups to ensure that no port is being blocked between the Cloud Builder and VCF appliances.

### Missing or Incorrect License Keys

```bash
Error: "License key for NSX, vCenter, or vSAN is missing."
```

- **Possible Causes**:
  - Missing or incorrectly specified license keys for the required components.
- **What to Check**:
  - Ensure that valid license keys are provided for NSX, vCenter, vSAN, and ESXi in the license_keys variable.
  - Confirm that the license key format is correct and not missing any required components.
  - Check whether the license keys need to be updated or are in the proper format.

### Network Configuration Errors (e.g., Incorrect Subnets)

```bash
Error: "Invalid subnet CIDR for network pool."
```

- **Possible Causes**:
  - Invalid or overlapping subnet CIDR values.
  - Incorrect gateway, VLAN, or MTU configuration for a specific network pool.
- **What to Check**:
  - Double-check the subnet CIDR, gateway, and port group names for each network pool (e.g., `network_pool_mgmt_appliances`, `network_pool_mgmt_esxi`, etc.).
  - Ensure that no two network pools are using the same IP range (check for subnet overlaps).
  - Ensure that the VLAN ID and MTU match the requirements for each specific network type (e.g., vMotion, VSAN).
  - Verify that all networking components (vSwitch, vDS) are configured correctly.

### vCenter or NSX-T Cluster Configuration Fails

```bash
Error: "vCenter or NSX-T cluster provisioning failed."
```

- **Possible Causes**:
  - Incorrect vCenter or NSX-T cluster configuration (e.g., wrong cluster names, or misconfigured   Distributed Virtual Switch).
  - Network misconfiguration or connectivity issues between ESXi hosts and vCenter.
- **What to Check**:
  - Ensure that the `mgmt_vc_datacenter_name`, `mgmt_vc_cluster_name`, and `mgmt_vc_dvs` are correctly specified in the variables file.
  - Verify that the vCenter and NSX-T clusters exist and are accessible via the Cloud Builder.
  - Confirm that the correct uplinks are specified for the Distributed Virtual Switch (DVS).
  - Check the connectivity between Cloud Builder, vCenter, and NSX-T components (ping or telnet).

### Host Commissioning Errors (e.g., ESXi Hosts Fail to Join Cluster)

```bash
Error: "Host commissioning failed for ESXi hosts."
```

- **Possible Causes**:
  - Incorrect ESXi host configuration (e.g., wrong IP, subnet, or password).
  - Issues with the standard vSwitch or vDS configuration.
- **What to Check**:
  - Verify the `hosts` variable in the `vcf_bringup.tfvars` file. Ensure the ESXi host IPs, netmasks, gateways, and passwords are correctly specified.
  - Ensure that the standard switch name (`vSwitch0`) or the vDS is correctly defined and configured.
  - Confirm that ESXi hosts are reachable from the Cloud Builder and can communicate with the vCenter.
  - Check whether ESXi hosts are already in use or not in the correct state for commissioning.

### Missing or Incorrect Passwords

```bash
Error: "Password for SSO or NSX management components is incorrect."
```

- **Possible Causes**:
  - Mismatch between the expected and provided passwords for management components (e.g., NSX-T, SDDC Manager, vCenter).
- **What to Check**:
  - Review the `sso_passwords`, `mgmt_nsxt_passwords`, and `sddc_passwords` variables to ensure that the passwords are correct.
  - Confirm that passwords are properly secured and do not contain any special characters that could interfere with parsing.
  - Ensure that the passwords provided are correctly used across all management components (SSO, vCenter, NSX-T, etc.).

### CEIP (Customer Experience Improvement Program) Configuration Issues

```bash
Error: "Invalid CEIP setting."
```

- **Possible Causes**:
  - The CEIP variable (`ceip`) is misconfigured or set incorrectly.
- **What to Check**:
  - Verify that the `ceip` variable is set to `true` or `false` as required. This is a Boolean variable, so ensure that no unexpected string values (e.g., `"false"`, `"yes"`) are used.
  - Check that CEIP is enabled or disabled based on your organization's policy or licensing agreement.

### General Network Connectivity Issues

```bash
Error: "Failed to establish network connection to vCenter, NSX, or SDDC Manager."
```

- **Possible Causes**:
  - Network misconfiguration, DNS resolution issues, or routing problems between Cloud Builder, vCenter, NSX-T, and ESXi hosts.
- **What to Check**:
  - Verify that the DNS servers (`vcf_dns`) are correctly configured and reachable.
  - Ensure that all appliances (Cloud Builder, vCenter, NSX, etc.) are correctly configured with static IPs or DNS entries that can be resolved.
  - Check routing and firewall configurations between all relevant components to ensure there are no blocking rules or security groups preventing communication.

### Module Source Path Issues 

```bash
Error: "Module source path is incorrect."
```

- **Possible Causes**:
  - Incorrect source path for the Terraform module (`../../../modules/vcf/bringup`).
- **What to Check**:
  - Ensure that the path to the module is correct relative to the current working directory.
  - Verify that the module exists at the specified path and is not missing or renamed.
  - Ensure that the required module files are correctly placed and accessible.
