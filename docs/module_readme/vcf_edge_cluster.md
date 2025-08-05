# VCF Edge Cluster

In this section we're going to cover the VCF Edge Cluster creation using the Terraform VCF module. We will go over the variables and the main terraform file as well as execution and troubleshooting. If you don't have your IDE window open, please open it and go to the folder where you cloned the repository too. 

Create a new folder under **library**. We're going to call it **vmware_lab** in this example. Copy the **vcf_edge_cluster** folder under **library/vcf** to the **vmware_lab** folder that you just created above. Copy the **example_vcf_edge_cluster.tfvars** and save it under the **vmware_lab** folder as **vcf_edge_cluster.tfvars** It should look like the example below

![VCF Edge Cluster Folder Structure](../images/edge_cluster_folder_structure.png)

--------------

## VCF Edge Cluster Variables

Let's open the `vcf_cluster_cluster.tfvars` file that we created from the example file. This `vcf_cluster_cluster.tfvars` file is a Terraform variable configuration file that defines various settings related to the VMware Cloud Foundation (VCF) Edge Cluster and Nodes. It includes authentication details, and VCF Edge Cluster and Edge Node configurations used for the deployment. The key sections include:

- **SDDC Manager Authentication**: Credentials for accessing the SDDC Manager appliance, including its hostname, username, and password. These are necessary for authenticating and interacting with the VMware Cloud Foundation environment.
- **VCF Edge Cluster**: Configuration for the VCF Edge Cluster, including its name, routing settings (ASNs, MTU), and tier 0/1 router names. Also includes root, admin, and audit passwords for secure access to the cluster.
- **VCF Edge Node 1**: Configuration details for the first edge node (`vcf-edge-1`), including FQDN, management IP, TEP settings (gateway, VLANs, IPs), and uplink configurations (IP, peer IP, remote ASN, passwords).
- **VCF Edge Node 2**: Configuration details for the second edge node (`vcf-edge-2`), with similar settings to Node 1 but with different IPs, VLANs, and uplink configurations.

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

### VCF Edge Cluster

This section defines the configuration for the edge cluster within the VCF environment.

```bash
edge_cluster = {
  name       = "tenant1"
  local_asn  = 65010
  mtu        = 1700
  tier0_name = "vcf_tier0"
  tier1_name = "vcf_tier1"
  tier1_type = "ACTIVE_STANDBY"
  passwords = {
    root  = "VMware1!VMware1!"
    admin = "VMware1!VMware1!"
    audit = "VMware1!VMware1!"
  }
}
```

- **name**: Name of the edge cluster, in this case, "tenant1."
- **local_asn**: Local Autonomous System Number (ASN) for BGP configuration.
- **mtu**: Maximum Transmission Unit for network packets, set to 1700.
- **tier0_name**: Name of the Tier 0 router.
- **tier1_name**: Name of the Tier 1 router.
- **tier1_type**: The type of Tier 1 router, set to "ACTIVE_STANDBY."
- **passwords**: Contains passwords for various user accounts, including:
  - **root**: The password for the root user
  - **admin**: The password for the admin user
  - **audit**: The password for the audit user

>> *Note: These variables contain sensitive information and should be protected and handled carefully.*

### VCF Edge Node 1

This section defines the configuration for the first edge node, vcf-edge-1, with details such as FQDN, management IP, TEP (Tunnel Endpoint) configuration, and uplink settings.

```bash
edge_nodes = {
  vcf-edge-1 = {
    fqdn                 = "vcf-edge-1.mpc.lab1"
    compute_cluster_name = "mgmt_cluster"
    mgmt_ip              = "172.16.104.20/24"
    mgmt_gw              = "172.16.104.1"
    tep = {
      gateway = "172.16.105.1"
      vlan    = 1005
      ip1     = "172.16.105.10/24"
      ip2     = "172.16.105.11/24"
    }
    uplinks = [
      {
        vlan       = 1006
        ip         = "172.16.106.10/24"
        peer_ip    = "172.16.106.1/24"
        remote_asn = 65000
        password   = "VMware1!"
      },
      {
        vlan       = 1007
        ip         = "172.16.107.10/24"
        peer_ip    = "172.16.107.1/24"
        remote_asn = 65000
        password   = "VMware1!"
      }
    ]
  }
}
```

- **fqdn**: Fully Qualified Domain Name of the first edge node.
- **compute_cluster_name**: Name of the compute cluster, in this case, `mgmt_cluster`.
- **mgmt_ip**: Management IP address for the node.
- **mgmt_gw**: Management gateway address.
- **tep**: Tunnel Endpoint configuration, including:
  - **gateway**: TEP gateway IP address.
  - **vlan**: VLAN ID (1005).
  - **ip1** and **ip2**: IP addresses for the Tunnel Endpoint.
- **uplinks**: List of uplink configurations, with each uplink having:
  - **vlan**: VLAN ID.
  - **ip**: IP address of the uplink.
  - **peer_ip**: IP address of the peer router.
  - **remote_asn**: ASN for the remote peer.
  - **password**: Password for the uplink connection.

### VCF Edge Node 2

This section is similar to Edge Node 1 but for the second node, `vcf-edge-2`.

```bash
  vcf-edge-2 = {
    fqdn                 = "vcf-edge-2.mpc.lab1"
    compute_cluster_name = "mgmt_cluster"
    mgmt_ip              = "172.16.104.21/24"
    mgmt_gw              = "172.16.104.1"
    tep = {
      gateway = "172.16.105.1"
      vlan    = 1005
      ip1     = "172.16.105.12/24"
      ip2     = "172.16.105.13/24"
    }
    uplinks = [
      {
        vlan       = 1006
        ip         = "172.16.106.11/24"
        peer_ip    = "172.16.106.1/24"
        remote_asn = 65000
        password   = "VMware1!"
      },
      {
        vlan       = 1007
        ip         = "172.16.107.11/24"
        peer_ip    = "172.16.107.1/24"
        remote_asn = 65000
        password   = "VMware1!"
      }
    ]
  }
}
```

The configuration is largely identical to `vcf-edge-1`, with differences in the FQDN, management IP addresses, TEP IPs, and uplink IP addresses.

- **fqdn**: Fully Qualified Domain Name of the first edge node.
- **compute_cluster_name**: Name of the compute cluster, in this case, `mgmt_cluster`.
- **mgmt_ip**: Management IP address for the node.
- **mgmt_gw**: Management gateway address.
- **tep**: Tunnel Endpoint configuration, including:
  - **gateway**: TEP gateway IP address.
  - **vlan**: VLAN ID (1005).
  - **ip1** and **ip2**: IP addresses for the Tunnel Endpoint.
- **uplinks**: List of uplink configurations, with each uplink having:
  - **vlan**: VLAN ID.
  - **ip**: IP address of the uplink.
  - **peer_ip**: IP address of the peer router.
  - **remote_asn**: ASN for the remote peer.
  - **password**: Password for the uplink connection.

--------------

## VCF Edge Cluster Main

Let's open the `vcf_edge_cluster.tf` file. The `vcf_edge_cluster.tf` main file is used to configure and deploy a VMware Cloud Foundation (VCF) edge cluster using a module. This file leverages a module located in the `../../../../modules/vcf/nsx_edge_cluster` path, which encapsulates the logic and resources necessary to create an edge cluster in a VCF environment.

### Module Definition

The file defines a Terraform `module` block, which sources the configuration from the specified module directory and passes input variables into the module for provisioning and managing the edge cluster within the VMware Cloud Foundation environment.

```bash
module "vcf_edge_cluster" {
  source = "../../../../modules/vcf/nsx_edge_cluster"
```

- **source**: The module is sourced from the relative path `../../../../modules/vcf/nsx_edge_cluster`. This path points to the location of the module that defines the resources and logic for provisioning and managing the edge cluster in VCF.

### SDDC Manager Authentication

```bash
sddc_manager_host     = var.sddc_manager_host
sddc_manager_username = var.sddc_manager_username
sddc_manager_password = var.sddc_manager_password
```

The authentication details for the SDDC Manager are provided using variables.
- **sddc_manager_host**: Hostname of the SDDC Manager.
- **sddc_manager_username**: Username for authenticating with the SDDC Manager.
- **sddc_manager_password**: Password for authenticating with the SDDC Manager.

These values are passed as inputs to the module to facilitate communication with the SDDC Manager.

### Edge Cluster Configuration

```bash
edge_cluster = var.edge_cluster
```

The configuration for the **edge cluster** is passed as a variable `edge_cluster`. This variable includes details such as the cluster name, routing settings, MTU, and other networking configurations.

### Edge Node Configuration

```bash
edge_nodes   = var.edge_nodes
```

The configuration for **edge nodes** is passed as a variable `edge_nodes`. This variable contains the details for each edge node in the cluster, including node names, IP addresses, VLAN configurations, TEP settings, and uplink settings.

--------------

## VCF Edge Cluster Execution

1. Initialize Terraform and install the required Providers and Modules by running:
```terraform init```
1. Plan the deployment and validate configuration.
```terraform plan -out vmware_lab -var-file="vcf_edge_cluster.tfvars"```
1. Apply the configuration
```terraform apply vmware_lab```
1. If the apply worked successfully, you should see something that looks like the screenshot below. If you have a failure, please check the [VCF Edge Cluster Troubleshooting](#vcf-edge-cluster-troubleshooting) section for more information.

>> **Insert screenshot for successful execution**

--------------

## VCF Edge Cluster Troubleshooting

When deploying VMware Cloud Foundation (VCF) using Terraform, various issues can arise during the deployment and provisioning process. Below is a list of common failures, their potential causes, and suggested checks to help resolve these issues.

### Authentication Issues with SDDC Manager

```bash
Error: Invalid credentials or connection issue with SDDC Manager.
Unable to authenticate to SDDC Manager at sddc.mpc.lab1 with username 'admin'.
```

- **What to Check**:
  - Ensure that the `sddc_manager_host`, `sddc_manager_username`, and `sddc_manager_password` are correct.
  - Verify network connectivity between the machine running Terraform and the SDDC Manager. Ensure that the `sddc_manager_host` is resolvable via DNS and that no firewall rules are blocking access.
  - If you're using a non-default port for the SDDC Manager, make sure to include it in the `sddc_manager_host` variable (e.g., `sddc.mpc.lab1:443`).

### Invalid Edge Cluster Configuration

```bash
Error: Invalid configuration for edge cluster.
The edge cluster 'tenant1' does not meet the required settings for Tier0 or Tier1 routers.
```

- **What to Check**:
  - Ensure that the `edge_cluster` variable is correctly defined. Specifically, verify that `tier0_name` and `tier1_name` are set correctly and that the routing type (`tier1_type`) is valid.
  - Double-check that the ASNs (`local_asn`) and MTU values are compatible with the network infrastructure.
  - Verify that the `tier1_type` is either `ACTIVE_STANDBY` or `HA` based on the edge cluster requirements.

### Missing or Incorrect Edge Node Configuration

```bash
Error: Missing configuration for edge node 'vcf-edge-1'.
The following parameters are required: mgmt_ip, uplinks.
```

- **What to Check**:
  - Ensure that the `edge_nodes` variable in `vcf_cluster_cluster.tfvars` contains the correct FQDN, management IP address (`mgmt_ip`), and uplink configurations for each edge node.
  - Verify that the uplinks are defined with valid VLAN IDs, IPs, peer IPs, remote ASNs, and passwords.
  - Confirm that `tep` settings (e.g., VLAN and IP addresses) are properly configured, especially ensuring no conflicts with other network segments.
  - Ensure that `compute_cluster_name` is correctly set to the target compute cluster where the edge nodes should reside.

### Network Configuration Failures (VLAN, IP Address Conflicts)

```bash
Error: Network configuration mismatch.
IP address 172.16.106.10/24 is already in use by another device in the network.
```

- **What to Check**:
  - Ensure that the IP addresses defined in the `tep` and `uplinks` sections are unique and do not conflict with existing devices on the network.
  - Check that the `vlan` IDs are properly configured and consistent across the network.
  - Verify that the `gateway` IP for the TEP and uplinks is reachable from the edge nodes and matches the network design.

### Module Source Path Issues

```bash
Error: Module not found.
The source module at '../../../../modules/vcf/nsx_edge_cluster' could not be located.
```

- **What to Check**:
  - Ensure that the module path (`../../../../modules/vcf/nsx_edge_cluster`) is correct relative to the location of your `vcf_edge_cluster.tf` file.
  - Verify that the module exists at the specified path and is accessible from the machine running Terraform.
  - If using version control or shared repositories, make sure the correct version of the module is being referenced.

### Terraform Initialization Errors

```bash
Error: Failed to initialize the Terraform workspace.
The provider configuration could not be loaded or initialized.
```

- **What to Check**:
  - Ensure that you have initialized Terraform in your working directory by running `terraform init`.
  - Check that the correct provider configurations are included in your Terraform setup, and ensure that your provider settings (e.g., for NSX-T or vSphere) are properly defined.
  - If using custom modules, ensure the necessary module dependencies are available and installed.

### Insufficient Permissions or Access Denied

```bash
Error: Permission denied.
User 'admin' does not have the necessary privileges to create the edge cluster in SDDC Manager.
```

- **What to Check**:
  - Verify that the user defined in the `sddc_manager_username` variable has sufficient permissions to perform edge cluster operations in the SDDC Manager. You may need to check user roles and permissions in the VMware Cloud Foundation environment.
  - Ensure the credentials passed are for an account that has the appropriate access rights to create, modify, or manage the edge cluster and edge nodes.

### Version Compatibility Issues

```bash
Error: Provider version mismatch.
The current provider version is incompatible with the Terraform configuration.
```

- **What to Check**:
  - Verify that the version of Terraform you're using is compatible with the version of the modules and providers in use.
  - Check the version constraints specified and ensure that the provider versions are aligned.
