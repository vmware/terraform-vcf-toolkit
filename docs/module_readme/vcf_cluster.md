# VCF Cluster

In this section we're going to cover the Cluster creation using the Terraform VCF module. We will go over the providers, variables, and the main terraform file as well as execution and troubleshooting. If you don't have your IDE window open, please open it and go to the folder where you cloned the repository too. 

Create a new folder under **library**. We're going to call it **vmware_lab** in this example. Copy the **vcf_cluster** folder under **library/vcf** to the **vmware_lab** folder that you just created above. Copy the **example_vcf_cluster.tfvars** and save it under the **vmware_lab** folder as **vcf_cluster.tfvars** It should look like the example below

![VCF Cluster Folder Structure](../images/cluster_folder_structure.png)

--------------

## VCF Cluster Providers

Now that we have a copy of the files, we're going to open the `providers.tf` file and take a look at it. The `providers.tf` file in Terraform is used to configure and specify the providers necessary for interacting with external systems and services. In this case, the file configures the VMware Cloud Foundation (VCF) provider, which is used for deploying and managing VCF Cloud Builder VMs and other VCF resources.

### Terraform Block for Required Providers

This section specifies the required providers for the Terraform configuration. In this case, the file defines the VCF provider, which is responsible for managing VMware Cloud Foundation resources.

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

- **Purpose**: Specifies the required Terraform provider to interact with VMware Cloud Foundation (VCF).
- **Explanation**:
  - **source**: Defines the source of the VCF provider, which is from the `vmware/vcf` namespace in the Terraform registry.
  - **version**: Specifies the version of the VCF provider to be used, in this case, version `0.8.5`.

### Provider Configuration for VCF

```bash
provider "vcf" {
  sddc_manager_host     = var.sddc_manager_host
  sddc_manager_username = var.sddc_manager_username
  sddc_manager_password = var.sddc_manager_password
  allow_unverified_tls  = true
}
```

- **Purpose**: Configures the authentication details for the VCF provider, allowing Terraform to communicate with the VMware Cloud Foundation's SDDC Manager.
- **Explanation**:
  - **sddc_manager_host**: The hostname or IP address of the SDDC Manager, provided from a variable `var.sddc_manager_host`.
  - **sddc_manager_username**: The username for logging into the SDDC Manager, provided from a variable `var.sddc_manager_username`.
  - **sddc_manager_password**: The password for the SDDC Manager, provided from a variable `var.sddc_manager_password`.
  - **allow_unverified_tls**: A boolean flag set to `true` to allow unverified TLS connections. This may be useful in environments where SSL/TLS certificates are not validated by default.

--------------

## VCF Cluster Variables

Let's open the `vcf_cluster.tfvars` file that we created from the example file. The `vcf_cluster.tfvars` file is used to define various configuration parameters related to VMware Cloud Foundation (VCF) deployment, particularly focusing on the SDDC Manager, license keys, workload domain configuration, and cluster/host settings. This file serves as a source of variables for Terraform during the configuration and provisioning of VCF workloads. The key sections include:

- **SDDC Manager Authentication**: Credentials for accessing the SDDC Manager appliance, including the hostname, username, and password. These are required to authenticate and interact with the SDDC Manager, which is crucial for managing the VMware Cloud Foundation (VCF) environment.
- **Workload Domain Environment Variables**: Configuration related to the workload domain, including the necessary license keys for NSX, vCenter, vSAN, and ESXi, which are required for enabling key features of the VCF deployment. The workload domain's unique name and UUID are also specified here.
- **VCF Workload Domain - Appliances**: Defines the settings for critical appliances within the workload domain, such as vCenter, NSX-T, and Lifecycle Manager (VLCM). This includes appliance names, FQDNs, image IDs, and other details for configuring and deploying these appliances.
- **VCF Workload Domain - Cluster/Hosts**: Specifies the configuration for ESXi hosts and their network interfaces within a workload domain cluster. It includes the host names, unique UUIDs, and associated network adapters (e.g., `vmnic0`, `vmnic1`) for each host in the domain.
- **VCF Workload Domain - Cluster Settings**: Configuration details for the workload domain's cluster, including the cluster's name, VSAN fault tolerance settings (`vsan_ftt`), and TEP VLAN. These settings are critical for configuring cluster-wide options such as fault tolerance and network settings related to NSX-T.

>> **All of the below screenshots, code snippets, etc are just examples. Please replace the values with the information for your environment**

### SDDC Manager Authentication

This section provides the credentials required to authenticate and access the SDDC Manager.

```bash
sddc_manager_host     = "sddc01.sddc.lab"
sddc_manager_username = "administrator@sddc.lab"
sddc_manager_password = "VMware1!VMware1!"
```

- **sddc_manager_host**: The hostname or IP address of the SDDC Manager.
- **sddc_manager_username**: The username used for authentication with the SDDC Manager (typically the administrator account).
- **sddc_manager_password**: The password for the SDDC Manager administrator account.

### Workload Domain Environment Variables

This section defines the license keys required for the various VMware products in the VCF workload domain.

```bash
license_keys = {
  nsx     = ""
  vcenter = ""
  vsan    = ""
  esxi    = ""
}
```

- **license_keys**: Placeholder for the product license keys required for NSX, vCenter, vSAN, and ESXi. These need to be filled with valid keys for the respective components.

### VCF Workload Domain - Appliances

This section specifies the identifiers and settings related to the VCF workload domain appliances.

```bash
workload_domain_name = "sddc01"
workload_domain_uuid = "1cb58b31-0d88-445e-b5c1-82a19b93300f"
vlcm_image_id        = "260751cc-f802-45e0-bc3f-cc701b86cdc1"
```

- **workload_domain_name**: The name assigned to the workload domain (e.g., `sddc01`).
- **workload_domain_uuid**: The unique identifier for the workload domain.
- **vlcm_image_id**: The identifier for the VMware Lifecycle Manager (VLCM) image used for deployment.

### VCF Workload Domain - Cluster/Hosts

This section defines the hosts and their associated configurations for the workload domain's cluster.

```bash
wld_hosts = {
  cluster1 = {
    "esxi05.sddc.lab" = ["9f8f64af-ea83-4ca1-ac7c-9f6240034305", "vmnic0", "vmnic1"],
    "esxi06.sddc.lab" = ["f45120cb-e9f3-4bb8-8b90-42afbff55dd3", "vmnic0", "vmnic1"],
    "esxi07.sddc.lab" = ["5947c63d-9f5e-4b40-ad17-a38ce2bacb35", "vmnic0", "vmnic1"],
    "esxi08.sddc.lab" = ["9435437a-28fa-48c5-b120-504dc91f0772", "vmnic0", "vmnic1"]
  }
}
```

- **wld_hosts**: A map specifying the ESXi hosts in a cluster. Each host entry consists of:
  - Hostname (e.g., `esxi05.sddc.lab`).
  - A list containing:
    - UUID (Universal Unique Identifier) for the host.
    - Network interfaces (e.g., `vmnic0`, `vmnic1`) for networking configuration.

### VCF Workload Domain - Cluster Settings

This section specifies the cluster-level settings for the VCF workload domain

```bash
wld_cluster_settings = {
  cluster1 = {
    name     = "wld1"
    vsan_ftt = "1"
    tep_vlan = "2018"
  }
}
```

- **wld_cluster_settings**: A map that contains configuration for each cluster in the workload domain. Each cluster configuration includes:
  - **name**: The name of the cluster (e.g., `wld1`).
  - **vsan_ftt**: The VSAN fault tolerance setting (e.g., `"1"` for fault tolerance).
  - **tep_vlan**: The VLAN ID for the Tunnel Endpoint (TEP) used for NSX.

--------------

## VCF Cluster Main

Let's open the `vcf_cluster.tf` file. This `vcf_cluster.tf` main file is used to define the configuration for the VMware Cloud Foundation (VCF) workload domain cluster. It leverages a module located in the `../../../modules/vcf/workload_cluster` path, which encapsulates the logic and resources necessary to create a cluster within a workload domain in a VCF environment.

### Module Block

The file defines a Terraform `module` block, which sources the configuration from the specified module directory and passes input variables into the module to configure the VCF workload domain cluster.

```bash
module "vcf_cluster" {
  source = "../../../modules/vcf/workload_cluster"
}
```

- **source**: Points to the path of the module that contains the logic for provisioning a VCF workload domain cluster. In this case, it references the workload_cluster module located within the `../../../modules/vcf/` directory.

### Module Configuration

The following variables are passed into the `vcf_cluster` module to customize the configuration for the workload domain cluster:

```bash
workload_domain_name = var.workload_domain_name
workload_domain_uuid = var.workload_domain_uuid
license_keys         = var.license_keys
```

- **workload_domain_name**: The name of the workload domain, specified as a variable, which helps identify the workload domain in the VCF deployment (e.g., `sddc01`).
- **workload_domain_uuid**: A unique identifier (UUID) for the workload domain. This ensures that the resources are provisioned in the correct domain (e.g., `1cb58b31-0d88-445e-b5c1-82a19b93300f`).
- **license_keys**: License keys for essential VCF components, such as NSX, vCenter, VSAN, and ESXi.

### Optional Parameters

```bash
vlcm_image_id = var.vlcm_image_id
```

- **vlcm_image_id**: An optional variable referencing the image ID for the VMware Lifecycle Manager (VLCM). If provided, this image ID will be used for the deployment of VLCM in the workload domain cluster (e.g., `260751cc-f802-45e0-bc3f-cc701b86cdc1`).

### Cluster-Specific Settings

```bash
wld_cluster_settings = var.wld_cluster_settings["cluster1"]
wld_hosts            = var.wld_hosts["cluster1"]
```

- **wld_cluster_settings**: Specifies the settings for the cluster within the workload domain (e.g., `vsan_ftt`, `tep_vlan`). It uses the values defined in the `wld_cluster_settings` variable for a specific cluster (`cluster1`).
- **wld_hosts**: Defines the ESXi hosts that will be part of the cluster (`cluster1`). It references the `wld_hosts` variable and associates each host with its specific configurations, such as network interfaces (`vmnic0`, `vmnic1`) and UUIDs.

--------------

## VCF Cluster Execution

1. Initialize Terraform and install the required Providers and Modules by running:
```terraform init```
1. Plan the deployment and validate configuration.
```terraform plan -out vmware_lab -var-file="vcf_cluster.tfvars"```
1. Apply the configuration
```terraform apply vmware_lab```
1. If the apply worked successfully, you should see something that looks like the screenshot below. If you have a failure, please check the [VCF Cluster Troubleshooting](#vcf-cluster-troubleshooting) section for more information.

>> **Insert screenshot for successful execution**

--------------

## VCF Cluster Troubleshooting

When deploying a VCF workload domain cluster using Terraform, various issues can arise. Below are some common failure scenarios, their potential causes, and troubleshooting steps to resolve them.

### Failed to authenticate with SDDC Manager

```bash
Error: "Authentication to SDDC Manager failed"
```

- **Possible Causes**:
  - Incorrect credentials for the SDDC Manager (`sddc_manager_username` or `sddc_manager_password`).
  - Incorrect hostname for the SDDC Manager.
  - Network connectivity issues between the Terraform instance and the SDDC Manager.
- **What to Check**:
  - Ensure the `sddc_manager_host`, `sddc_manager_username`, and `sddc_manager_password` values in your variables are correct.
  - Verify that the SDDC Manager is up and accessible from your environment (ping or curl).
  - Check that there are no firewall rules or security groups blocking access to the SDDC Manager from the Terraform environment.
  - If using self-signed certificates, ensure that the `allow_unverified_tls` option is set to `true`.

### Workload Domain UUID is missing or incorrect

```bash
Error: "The Workload Domain UUID is not correctly defined"
```

- **Possible Causes**:
  - Missing or incorrect `workload_domain_uuid` in the `vcf_cluster.tfvars` file.
  - The UUID provided does not match any existing workload domain in the SDDC Manager.
- **What to Check**:
  - Double-check the `workload_domain_uuid` value in the `vcf_cluster.tfvars` file. It should be a valid UUID from the SDDC Manager.
  - Ensure that the workload domain exists in the SDDC Manager with the provided UUID.
  - If you’re unsure about the UUID, you can retrieve it from the SDDC Manager’s UI or API.

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

### Cluster provisioning failed

```bash
Error: "Failed to provision cluster or ESXi hosts"
```

- **Possible Causes**:
  - Incorrect configuration of the cluster settings, such as `vsan_ftt`, `tep_vlan`, or `wld_cluster_settings`.
  - Network issues or misconfigurations with the ESXi hosts (e.g., incorrect IP addresses, VLAN misconfigurations).
- **What to Check**:
  - Ensure that the cluster settings (`vsan_ftt`, `tep_vlan`, etc.) are correctly configured in the `wld_cluster_settings` variable.
  - Check that the network settings for each ESXi host (IP, subnet, gateway) in the `wld_hosts` variable are correct.
  - Verify that the ESXi hosts are accessible and have the necessary network connectivity to communicate with the SDDC Manager and vCenter.

### Invalid VM Network Configuration

```bash
Error: "Invalid network configuration for the VM or cluster"
```

- **Possible Causes**:
  - Incorrect network configuration for the VM or cluster (e.g., invalid VLAN ID, MTU size, or missing port group).
  - ESXi hosts are not configured correctly with the required network adapters (`vmnic0`, `vmnic1`).
- **What to Check**:
  - Ensure that each ESXi host has the appropriate network adapters configured (`vmnic0`, `vmnic1`) and they are correctly mapped in the `wld_hosts` variable.
  - Double-check the network configuration for each network pool in the workload domain, including VLAN IDs, MTU sizes, and subnet CIDR blocks.
  - Ensure that the necessary port groups (e.g., for ESXi, vMotion, vSAN, TEP) are defined and available on the ESXi hosts.

### VLCM Image ID Missing or Incorrect

```bash
Error: "The provided VLCM image ID is invalid or missing"
```

- **Possible Causes**:
  - The `vlcm_image_id` variable is not set or has an invalid value.
  - The specified VLCM image ID does not exist in the VMware Lifecycle Manager (VLCM) or is not accessible.
- **What to Check**:
  - Verify that the `vlcm_image_id` is correctly set in the `vcf_cluster.tfvars` file (if applicable).
  - Ensure that the specified image ID exists in your VLCM environment and is accessible for deployment.

### ESXi Host(s) Failed to Join Cluster

```bash
Error: "ESXi host(s) failed to join the cluster"
```

- **Possible Causes**:
  - Misconfigured ESXi hosts or networking issues between ESXi hosts and vCenter.
  - Incorrect host credentials or missing configuration for the ESXi host.
- **What to Check**:
  - Ensure that all ESXi host IPs, credentials, and configurations are correct in the `wld_hosts` variable.
  - Verify that the ESXi hosts are properly configured with the correct network settings and that they can communicate with vCenter and other hosts in the cluster.
  - Check the vCenter UI or logs for further details on why the host failed to join the cluster.

### Host Commissioning Failed

```bash
Error: "Host commissioning failed for the ESXi host"
```
- **Possible Causes**:
  - Incorrect ESXi host configuration, network interface issues, or host misconfiguration.
  - Network issues or firewall rules preventing the host from reaching required resources (e.g., vCenter, SDDC Manager).
- **What to Check**:
  - Double-check the network interfaces (`vmnic0`, `vmnic1`) and ensure they are properly configured on the ESXi hosts.
  - Verify the network connectivity between the ESXi hosts, vCenter, and SDDC Manager.
  - Check that the ESXi hosts are not already in use or in an invalid state.
