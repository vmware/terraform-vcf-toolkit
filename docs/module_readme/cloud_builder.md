# Cloud Builder Deployment

In this section we're going to cover the Cloud Builder deployment using the Terraform vSphere module. We will go over the providers, variables, and the main terraform file as well as execution and troubleshooting. If you don't have your IDE window open, please open it and go to the folder where you cloned the repository too. 

Create a new folder under **library**. We're going to call it **vmware_lab** in this example. Copy the **vcf_cloud_builder** folder under **library/vcf** to the **vmware_lab** folder that you just created above. Copy the **example_cloud_builder.tfvars** and save it under the **vmware_lab** folder as **cloud_builder.tfvars** It should look like the example below

![CB Folder Structure](../images/cb_folder_structure.png)

--------------

## Cloud Builder Providers

Now that we have a copy of the files, we're going to open the `providers.tf` file and take a look at it. This `providers.tf` file contains the necessary configuration to use the vSphere provider in Terraform, specifically for deploying Cloud Foundation (VCF) Virtual Machines (VMs).

### Cloud Builder Terraform Block

```bash
terraform {
  required_providers {
    vsphere = {
      source  = "vmware/vsphere"
      version = "~>2.6.1"
    }
  }
}
```

- **terraform { ... }**: This block specifies the Terraform settings and provider configurations.
  - **required_providers**: Defines the external providers required by this Terraform configuration.
  - **vsphere**: Specifies that the `vsphere` provider is needed, which allows Terraform to interact with VMware vSphere resources.
    - **source**: The source for the provider, in this case, `vmware/vsphere`, which pulls the official vSphere provider from HashiCorp’s registry.
    - **version**: Defines the required version of the provider, with `~>2.6.1` meaning any version starting from `2.6.1` and less than `3.0.0`.

### vSphere Provider Configuration

```bash
provider "vsphere" {
  user                 = var.vcenter_username
  password             = var.vcenter_password
  vsphere_server       = var.vcenter_server
  allow_unverified_ssl = true # Required for self-signed
}
```

- **provider "vsphere" { ... }**: This block defines the configuration for the vSphere provider.
  - **user**: Specifies the vCenter username used to authenticate against the vSphere server. The value is pulled from a variable `var.vcenter_username`.
  - **password**: Specifies the vCenter password, also pulled from a variable `var.vcenter_password`.
  - **vsphere_server**: Specifies the address of the vCenter server (typically in the form of `vcenter.example.com`), sourced from the variable `var.vcenter_server`.
  - **allow_unverified_ssl**: When set to `true`, this allows connections to vSphere even if the SSL certificate is self-signed or not verified. This is especially useful when connecting to internal vSphere servers with self-signed certificates.

--------------

## Cloud Builder Variables

Let's open the `cloud_builder.tfvars` file that we created from the example file. This `cloud_builder.tfvars` file contains variable values required by the Terraform configuration, such as vCenter connection details, Cloud Builder VM settings, and associated credentials. The key sections include:

- **vCenter Configuration**: Credentials and server information for connecting Terraform to the vCenter server.
- **Cloud Builder VM Settings**: Specifications for deploying the Cloud Builder VM, including datacenter, cluster, host, datastore, and networking.
- **Network Configuration**: The network settings for the Cloud Builder VM, including IP, subnet, gateway, and DNS.
- **User Credentials**: Administrative and root passwords for the Cloud Builder VM.
  
These variables help define the parameters for the deployment and configuration of the Cloud Builder VM in a VMware vSphere environment using Terraform.

>> **All of the below screenshots, code snippets, etc are just examples. Please replace the values with the information for your environment**

### vCenter Configuration

```bash
# --------------------------------------------------------------- #
# vCenter Variables
# --------------------------------------------------------------- #
vcenter_server   = "ip_address"
vcenter_username = "administrator@vsphere.local"
vcenter_password = "VMware1!"
```

- **vcenter_server**: The IP address or hostname of the vCenter server where the Cloud Builder VM will be deployed.
- **vcenter_username**: The username used to authenticate with vCenter, typically an administrative user like `administrator@vsphere.local`.
- **vcenter_password**: The password associated with the `vcenter_username`.
  
These variables are essential for authenticating Terraform with the vCenter server to deploy resources.

### Cloud Builder VM Configuration

```bash
# --------------------------------------------------------------- #
# Cloudbuilder Variables
# --------------------------------------------------------------- #
datacenter      = "datacenter01"
cluster         = "cluster01"
deployment_host = "host-25"
datastore       = "cluster01-vsan01"
vds             = "cluster01-vds01"
port_group      = "mgmt-vms"
local_ovf_path  = "E:\\VMware-Cloud-Builder-5.2.ova"
```

- **datacenter**: The name of the vSphere datacenter where the Cloud Builder VM will be deployed (e.g., `datacenter01`).
- **cluster**: The name of the vSphere cluster in which the Cloud Builder VM will reside (e.g., `cluster01`).
- **deployment_host**: The host where the Cloud Builder VM will be deployed, identified by its name (e.g., `host-25`).
- **datastore**: The datastore where the Cloud Builder VM will store its files (e.g., `cluster01-vsan01`)`.
- **vds**: The name of the vSphere Distributed Switch (VDS) used for networking (e.g., `cluster01-vds01`).
- **port_group**: The name of the port group for Cloud Builder VM's network interface (e.g., `mgmt-vms`).
- **local_ovf_path**: The local file path to the Cloud Builder OVA file on the machine running Terraform (e.g., `E:\\VMware-Cloud-Builder-5.2.ova`).

These variables are required for configuring the infrastructure where the Cloud Builder VM will be deployed in the vSphere environment.

### Cloud Builder Network Configuration

```bash
cloud_builder_settings = {
  hostname   = "cloudbuilder.sddc.lab"
  ip         = "10.0.1.9"
  netmask    = "255.255.255.0"
  gateway    = "10.0.1.1"
  domain     = "sddc.lab"
  searchpath = "sddc.lab"
  ntp        = "10.0.1.2"
  dns        = "10.0.1.2"
}
```

- **hostname**: The hostname of the Cloud Builder VM (e.g., `cloudbuilder.sddc.lab`).
- **ip**: The static IP address assigned to the Cloud Builder VM (e.g., `10.0.1.9`).
- **netmask**: The subnet mask for the Cloud Builder VM’s network (e.g., `255.255.255.0`).
- **gateway**: The default gateway for the Cloud Builder VM (e.g., `10.0.1.1`).
- **domain**: The DNS domain name for the Cloud Builder VM (e.g., `sddc.lab`).
- **searchpath**: The DNS search path for the Cloud Builder VM (e.g., `sddc.lab`).
- **ntp**: The NTP server used to sync time (e.g., `10.0.1.2`).
- **dns**: The DNS server for the Cloud Builder VM (e.g., `10.0.1.2`).

These settings configure the network and domain parameters for the Cloud Builder VM once it is deployed.

### Cloud Builder VM User Credentials

```bash
cloud_builder_passwords = {
  admin_user = "admin"
  admin_pass = "VMware1!VMware1!"
  root_pass  = "VMware1!VMware1!"
}
```

- **admin_user**: The username for the Cloud Builder VM's administrative account (e.g., `admin`).
- **admin_pass**: The password for the `admin_user` account.
- **root_pass**: The password for the `root` account on the Cloud Builder VM.

These are the user credentials for logging into the Cloud Builder VM.

--------------

## Cloud Builder Main

Let's open the `vcf_cloud_builder.tf` file that we created from the example file. This `vcf_cloud_builder.tf` file uses a Terraform module to deploy the Cloud Builder VM. It pulls in variables defined elsewhere (likely in `.tfvars` files) to configure the deployment of the Cloud Builder VM in a VMware vSphere environment.

### Module Declaration

```bash
module "cloud_builder" {
  source = "../../../modules/appliances/cloud_builder"
```

- **module "cloud_builder"**: This block declares a Terraform module named `cloud_builder`. A module is a container for multiple resources, and in this case, it will deploy the Cloud Builder appliance.
  - **source**: Points to the location of the module. In this case, it refers to a relative path `../../../modules/appliances/cloud_builder`, which contains the necessary Terraform code to deploy the Cloud Builder VM.

### vCenter Target Cluster Configuration

```bash
datacenter      = var.datacenter
cluster         = var.cluster
deployment_host = var.deployment_host
datastore       = var.datastore
vds             = var.vds
port_group      = var.port_group
```

These variables define the target vSphere environment for deploying the Cloud Builder VM:

- **datacenter**: The name of the vSphere datacenter where the Cloud Builder VM will be deployed (e.g., `datacenter01`).
- **cluster**: The cluster within the datacenter where the Cloud Builder VM will reside (e.g., `cluster01`).
- **deployment_host**: The specific host in the cluster where the Cloud Builder VM will be placed (e.g., `host-25`).
- **datastore**: The datastore where the Cloud Builder VM's disk will be stored (e.g., `cluster01-vsan01`).
- **vds**: The vSphere Distributed Switch (VDS) that the Cloud Builder VM will use for networking (e.g., `cluster01-vds01`).
- **port_group**: The network port group for the Cloud Builder VM’s virtual NIC (e.g., `mgmt-vms`).

These variables ensure that the Cloud Builder appliance is deployed into the correct cluster, datastore, and network in the vSphere environment

### Cloud Builder Appliance Configuration

```bash
local_ovf_path          = var.local_ovf_path
cloud_builder_settings  = var.cloud_builder_settings
cloud_builder_passwords = var.cloud_builder_passwords
```

These variables define the settings specific to the Cloud Builder appliance itself:

- **local_ovf_path**: The file path to the Cloud Builder OVA (Open Virtualization Archive) file, which contains the appliance image that will be deployed (e.g., `E:\\VMware-Cloud-Builder-5.2.ova`).
- **cloud_builder_settings**: A map or dictionary containing the configuration settings for the Cloud Builder VM (e.g., hostname, IP address, netmask, gateway, domain, DNS, etc.).
- **cloud_builder_passwords**: A map containing the passwords for the Cloud Builder VM, including the admin and root user passwords, which will be set during deployment.

These variables are used to configure the Cloud Builder appliance itself, including the network settings and credentials for administrative access.

--------------

## Cloud Builder Execution

1. Initialize Terraform and install the required Providers and Modules by running:
```terraform init```
1. Plan the deployment and validate configuration.
```terraform plan -out vmware_lab -var-file="cloud_builder.tfvars"```
1. Apply the configuration
```terraform apply vmware_lab```
1. If the apply worked successfully, you should see something that looks like the screenshot below. If you have a failure, please check the [Cloud Builder Troubleshooting](#cloud-builder-troubleshooting) section for more information.

>> **Insert screenshot for successful execution**

--------------

## Cloud Builder Troubleshooting

When deploying the Cloud Builder VM using the provided Terraform configuration files, you may encounter various issues. Below are some common errors and troubleshooting steps to help resolve them.

### vSphere Provider Authentication Failure

```bash
Error: Unable to authenticate with vSphere
  on vcf_cloud_builder.tf line 2:
  2: provider "vsphere" {
  ...
  msg: "Authentication failed: User or password incorrect"
```

1. **Check vCenter Credentials**: Verify that the credentials (username and password) in the `cloud_builder.tfvars` file are correct. Ensure the username (`vcenter_username`) and password (`vcenter_password`) are valid for your vSphere environment.
1. **Check vSphere Server**: Ensure the correct vCenter server address is specified in vcenter_server. This should be a valid IP address or FQDN of the vCenter server.
1. **Ensure Network Accessibility**: Ensure that the machine running Terraform can access the vCenter server. Try pinging the vCenter server from your Terraform host.
1. **Verify Permissions**: Ensure that the user specified (`vcenter_username`) has sufficient privileges to create resources (e.g., deploying VMs) in the target datacenter and cluster.

### Missing or Incorrect Provider Version

```bash
Error: Failed to install provider
  on vcf_cloud_builder.tf line 2:
  2: provider "vsphere" {
  ...
  msg: "Provider 'vsphere' not found. Please check the 'required_providers' block"
```

1. **Check Provider Version:** Verify that the version specified in the `terraform { required_providers { vsphere { version = "~>2.6.1" } } }` block is correct and available in the Terraform registry.
1. **Run** `terraform init`: Ensure that you have initialized your Terraform project with `terraform init`. This command installs the required providers and sets up the working environment.
1. **Check Compatibility**: Make sure the version of the `vsphere` provider specified is compatible with your version of Terraform.

### Invalid Datacenter, Cluster, or Datastore

```bash
Error: Resource not found
  on vcf_cloud_builder.tf line 18:
  18: cluster         = var.cluster
  ...
  msg: "Datacenter 'datacenter01' not found or accessible"
```

1. **Check Datacenter Name**: Verify that the `datacenter` value in `cloud_builder.tfvars` matches the exact name of your vSphere datacenter.
1. **Check Cluster Name**: Ensure that the cluster (`cluster`) value is correct and that the specified cluster exists within the vCenter server.
1. **Check Datastore**: Verify that the datastore (`datastore`) exists and is accessible in the specified cluster.
1. **Check Permissions**: Ensure that the vCenter user has sufficient permissions to access the datacenter, cluster, and datastore.

### OVF File Not Found or Incorrect Path

```bash
Error: File not found
  on vcf_cloud_builder.tf line 23:
  23: local_ovf_path          = var.local_ovf_path
  ...
  msg: "The OVA file at 'E:\\VMware-Cloud-Builder-5.2.ova' does not exist"
```

1. **Check OVF File Path**: Ensure that the path to the OVA file (`local_ovf_path`) in `cloud_builder.tfvars` is correct and points to an existing file. Double-check the file location and ensure it is accessible.
1. **Check Permissions**: Make sure that the Terraform process has permission to access the path specified (especially if running in a restricted environment or as a different user).

### Network Configuration Issues

```bash
Error: Invalid network configuration
  on vcf_cloud_builder.tf line 27:
  27: cloud_builder_settings  = var.cloud_builder_settings
  ...
  msg: "Invalid IP or DNS configuration"
```

1. **Check IP Configuration**: Verify that the IP address, netmask, gateway, and DNS settings in `cloud_builder_settings` are valid and do not conflict with existing network configurations.
1. **Check DNS and NTP**: Ensure that the DNS and NTP servers are accessible and correctly configured. You can test DNS resolution and NTP synchronization outside of Terraform to ensure they are working properly.
1. **Check Port Group and VDS**: Verify that the `port_group` and `vds` values in `cloud_builder.tfvars` are correct and exist in the specified vSphere environment.

### Cloud Builder VM Deployment Failures

```bash
Error: Failed to deploy Cloud Builder
  on vcf_cloud_builder.tf line 18:
  18: source = "../../../modules/appliances/cloud_builder"
  ...
  msg: "The Cloud Builder appliance could not be deployed"
```

1. **Check OVF Compatibility**: Ensure that the Cloud Builder OVA file is compatible with your vSphere version. Some OVA files may not be supported on older versions of vSphere.
1. **Check Host Resources**: Ensure the target deployment host (`deployment_host`) has sufficient resources (CPU, memory, storage) to deploy the Cloud Builder VM.
1. **Check for Existing Resources**: If the Cloud Builder VM was previously deployed, ensure that there are no conflicts with existing VMs (e.g., same hostname or IP address).
1. **Check for VM Constraints**: Verify that any VM constraints (e.g., CPU, memory, disk size) specified in the `cloud_builder_settings` are valid and can be accommodated by the selected cluster and host.

### Self-Signed SSL Certificate Errors

```bash
Error: SSL verification failed
  on vcf_cloud_builder.tf line 5:
  5: allow_unverified_ssl = true
  ...
  msg: "SSL certificate is not trusted"
```

1. **Check SSL Settings**: If you're using a self-signed SSL certificate for vCenter, ensure that `allow_unverified_ssl = true` is set in the `provider "vsphere"` block. This bypasses SSL certificate verification for self-signed certificates.
1. **Verify Certificate**: If you want to avoid using `allow_unverified_ssl = true`, you could install a trusted SSL certificate or add the self-signed certificate to the trusted certificate store.

### Insufficient Permissions for VM Deployment

```bash
Error: Insufficient privileges to create VM
  on vcf_cloud_builder.tf line 18:
  18: cluster         = var.cluster
  ...
  msg: "User does not have permissions to create VM in the specified cluster"
```

1. **Check vCenter User Permissions**: Ensure that the `vcenter_username` specified has sufficient permissions to deploy VMs within the specified datacenter and cluster. The user must have permissions to create virtual machines, assign networks, and provision storage.
1. **Check Resource Allocation Permissions**: Verify that the user has permissions to allocate resources like CPU, memory, and storage within the cluster and datastore.

### Module Path Issues

```bash
Error: Module source not found
  on vcf_cloud_builder.tf line 2:
  2: source = "../../../modules/appliances/cloud_builder"
  ...
  msg: "Module source path is incorrect or missing"
```

1. **Check Module Path**: Ensure the path to the `cloud_builder` module (`../../../modules/appliances/cloud_builder`) is correct relative to the location of the `vcf_cloud_builder.tf` file. Double-check that the module directory exists and contains the necessary Terraform code.
1. **Use Absolute Path**: If you're still having issues, try using the absolute path to the module to rule out relative path errors.