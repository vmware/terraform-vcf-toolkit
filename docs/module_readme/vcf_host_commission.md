# Host Commission

In this section we're going to cover Host Commission using the Terraform VCF module. We will go over the providers, variables, main, and output terraform files as well as execution and troubleshooting. If you don't have your IDE window open, please open it and go to the folder where you cloned the repository too. 

Create a new folder under **library**. We're going to call it **vmware_lab** in this example. Copy the **vcf_host_commission** folder under **library/vcf** to the **vmware_lab** folder that you just created above. Copy the **example_vcf_host_commission.tfvars** and save it under the **vmware_lab** folder as **vcf_host_commission.tfvars** It should look like the example below

![Host Commission Folder Structure](../images/host_commission_folder_structure.png)

--------------

## Host Commission Providers

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

- **terraform block**: This block is required for defining the Terraform configuration. It specifies the provider and version required for the deployment.
- **required_providers**: Defines the providers that are required to interact with external services. In this case, the `vcf` provider from VMware is used.
  - **source**: Specifies the source of the provider, which is `vmware/vcf` in this case. This is the official VCF provider from VMware on the Terraform Registry.
  - **version**: Defines the version of the provider. Here, it is specified as `0.8.5`.

### SDDC Manager Settings (Provider Configuration)

This section configures the VCF provider by providing authentication details and settings needed to connect to the VMware Cloud Foundation SDDC Manager.

```bash
provider "vcf" {
  sddc_manager_host     = var.sddc_manager_host
  sddc_manager_username = var.sddc_manager_username
  sddc_manager_password = var.sddc_manager_password
  allow_unverified_tls  = true
}
```

- **provider "vcf"**: This block configures the vcf provider, which is responsible for connecting to the SDDC Manager and interacting with VMware Cloud Foundation resources.
  - **sddc_manager_host**: Specifies the host address of the SDDC Manager. It is fetched from the variable `var.sddc_manager_host`.
  - **sddc_manager_username**: The username used to authenticate to the SDDC Manager. This value is fetched from the `var.sddc_manager_username` variable.
  - **sddc_manager_password**: The password associated with the provided username for authenticating to the SDDC Manager. It is fetched from the `var.sddc_manager_password` variable.
  - **allow_unverified_tls**: This boolean flag, set to `true`, allows the provider to communicate with the SDDC Manager over TLS even if the server’s SSL/TLS certificate is not verified. This may be useful in lab or testing environments where self-signed certificates are used.

--------------

## Host Commission Variables

Let's open the `.tfvars` file that we created from the example file. The `vcf_host_commission.tfvars` file is a Terraform variable definition file used for specifying input values during the automation of VMware Cloud Foundation (VCF) deployment. It focuses on authenticating to the SDDC Manager and providing host-specific configurations for the management and workload domains in the VCF environment.

>> **All of the below screenshots, code snippets, etc are just examples. Please replace the values with the information for your environment**

### SDDC Manager Authentication

This section provides the authentication credentials needed to access and interact with the SDDC Manager. These credentials are used to automate the management of VCF resources.

```bash
sddc_manager_host     = "sddc01.sddc.lab"
sddc_manager_username = "administrator@sddc.lab"
sddc_manager_password = "VMware1!VMware1!"
```

- **sddc_manager_host**: Specifies the hostname of the SDDC Manager (e.g., "sddc01.sddc.lab").
- **sddc_manager_username**: The username for logging into the SDDC Manager, typically an administrative account (e.g., "administrator@sddc.lab").
- **sddc_manager_password**: The password corresponding to the specified username (e.g., "VMware1!VMware1!").

>> *Important Note: The file contains sensitive authentication information, and best practices suggest securing these values through environment variables or a secrets management system to avoid hardcoding passwords.*

### VCF Management/Workload Domain - Host Commissioning

This section lists the ESXi hosts to be provisioned for the VCF management and workload domains. Each entry includes important host-specific details such as the ESXi UUID, root password, and storage configuration type.

```bash
hosts = {
  "esxi05.sddc.lab" = ["852ee093-e26f-490a-9250-f3320f5066aa", "VMware1!VMware1!", "VSAN"],
  "esxi06.sddc.lab" = ["852ee093-e26f-490a-9250-f3320f5066aa", "VMware1!VMware1!", "VSAN"],
}
```

- **Key**: The hostname of the ESXi server (e.g., `"esxi05.sddc.lab"`).
- **Value**: A list containing:
  - **UUID**: A unique identifier for the ESXi host (e.g., `"852ee093-e26f-490a-9250-f3320f5066aa"`).
  - **Password**: The root password for the ESXi host (e.g., `"VMware1!VMware1!"`).
  - **Storage** Type: Specifies the storage configuration to be used by the host (e.g., `"VSAN"`), which represents a VMware vSAN storage solution.
  
- Considerations:
  - **Sensitive Data**: As with the SDDC Manager section, this file contains sensitive information like passwords and host identifiers, which should be handled securely.
  - **Host Commissioning**: The provided host details (UUID, password, and storage configuration) are critical for onboarding and configuring ESXi hosts in the VCF environment.

--------------

## Host Commission Main

Let's open the `vcf_host_commission.tf` file. The `vcf_host_commission.tf` file is a Terraform configuration file that references a module designed to commission ESXi hosts within a VMware Cloud Foundation (VCF) environment. This file acts as a bridge, passing variables to a module that performs the actual host commissioning tasks.

### Module Declaration

This section defines a Terraform module that is sourced from a relative path, which contains the logic for host commissioning within a VCF environment.

```bash
module "host_commission" {
  source = "../../../modules/vcf/vcf_host_commission"

  # --------------------------------------------------------------- #
  # Module Configuration
  # --------------------------------------------------------------- #

  hosts = var.hosts
}
```

- **module "host_commission"**: This block declares a module named `host_commission`. The module encapsulates the logic and resources needed to commission hosts in VCF.
- **source**: The source attribute specifies the location of the module. In this case, the module is located at the relative path `../../../modules/vcf/vcf_host_commission`. This path indicates that the module is located three directories above the current one, inside a `modules/vcf` directory.
- **hosts**: This is an input variable passed to the module. It is set to `var.hosts`, which is likely defined elsewhere in the configuration, such as in a `terraform.tfvars` file or as environment variables. The `hosts` variable holds the details of the ESXi hosts that need to be commissioned (`e.g., hostnames, credentials, UUIDs`).

--------------

## Host Commission Output

The `outputs.tf` file in Terraform is used to define output variables, which expose the results of your Terraform configuration after it has been applied. These outputs can be used for further processing, debugging, or integration with other systems. In this case, the file is used to output the result of the host commissioning module.

### Output Declaration

This section defines a single output variable, `host_ids`, which exposes the result from the `host_commission` module.

```bash
output "host_ids" {
  value = module.host_commission
}
```

- **output "host_ids"**: This block defines an output variable named `host_ids`. The name `host_ids` suggests that this output will contain identifiers (such as UUIDs) of the commissioned hosts.
- **value**: The `value` attribute specifies what data will be exposed through the output variable. In this case, it is set to `module.host_commission`, which means that the output will include the result or value returned by the `host_commission` module.

>> **Insert screenshot of successful output**

--------------

## Host Commission Execution

1. Initialize Terraform and install the required Providers and Modules by running:
```terraform init```
1. Plan the deployment and validate configuration.
```terraform plan -out vmware_lab -var-file="vcf_host_commission.tfvars"```
1. Apply the configuration
```terraform apply vmware_lab```
1. If the apply worked successfully, you should see something that looks like the screenshot below. If you have a failure, please check the [Host Commission Troubleshooting](#host-commission-troubleshooting) section for more information.

>> **Insert screenshot for successful execution**

--------------

## Host Commission Troubleshooting

This section provides guidance on troubleshooting common issues when working with the `vcf_host_commission` Terraform configuration and associated files. Below are some potential issues that you may encounter during execution, along with recommendations on what to check and how to resolve them.

### Invalid or Missing hosts Variable

```bash
Error: Missing required argument

  on vcf_host_commission.tf line 6, in module "host_commission":
   6:   hosts = var.hosts

The argument "hosts" is required, but no definition was found.
```

- **Cause**: The `hosts` variable is either not defined or not correctly passed to the module.
- **What to Check**:
  - Ensure that the `hosts` variable is defined in a `*.tfvars` file or as an environment variable. For example:
    ```bash
    hosts = {
    "esxi01.sddc.lab" = ["UUID-1", "password123", "VSAN"],
    "esxi02.sddc.lab" = ["UUID-2", "password123", "VSAN"]
    }
    ```
  - Verify that the `hosts` variable is correctly referenced in the `vcf_host_commission.tf` file:
    ```bash
    hosts = var.hosts
    ```
- **Solution**:
  - Define the `hosts` variable in the `terraform.tfvars` file or through environment variables to ensure the module receives the correct input.

### Authentication Failure with SDDC Manager

```bash
Error: Invalid credentials

  on providers.tf line 10, in provider "vcf":
  10:   sddc_manager_username = var.sddc_manager_username
```

- **Cause**: The credentials for the SDDC Manager are either incorrect or not properly defined.
- **What to Check**:
  - Double-check the values of `sddc_manager_host`, `sddc_manager_username`, and `sddc_manager_password` in your `*.tfvars` file or environment variables.
  - Ensure that the credentials provided are correct for the SDDC Manager.
  - If you are using self-signed certificates, check that the `allow_unverified_tls` flag is set to `true`.
- **Solution**:
  - Verify the credentials and ensure they are correctly set in the Terraform configuration files.
  - If using a custom SSL certificate, confirm that `allow_unverified_tls = true` is set.

### Host Commissioning Failure

```bash
Error: Host Commissioning Failed

  on vcf_host_commission.tf line 15, in module "host_commission":
  15:   hosts = var.hosts

Invalid host details or ESXi configuration error.
```

- **Cause**: There may be an issue with the host configuration passed to the module, such as incorrect UUIDs, incorrect passwords, or invalid storage configuration.
- **What to Check**:
  - Validate that each host entry in the `hosts` variable is correctly formatted. For example:
    - The UUID should be valid and correctly associated with the host.
    - Ensure that the password follows the required format (e.g., no special characters that could break parsing).
    - The storage configuration (`VSAN`) should match what is expected for the given hosts.
- **Solution**:
  - Review and verify each host's configuration. If using a large number of hosts, ensure that the format is consistent across all entries.
  - Check the logs or error messages for specific details about which host caused the failure.

### TLS/SSL Certificate Issues

```bash
Error: SSL Certificate Verification Failed

  on providers.tf line 10, in provider "vcf":
  10:   sddc_manager_host = var.sddc_manager_host
```

- **Cause**: SSL certificate validation failed, typically due to using a self-signed certificate on the SDDC Manager.
- **What to Check**:
  - Ensure that the `allow_unverified_tls` flag is set to `true` in the provider block if you're using self-signed certificates.
  - If using a valid certificate, ensure that the SDDC Manager’s certificate is properly installed and trusted by the system running Terraform.
- **Solution**:
  - If using a self-signed certificate, ensure `allow_unverified_tls = true` is set in the provider configuration.
  - For valid certificates, verify that the certificate is correctly trusted on the machine running Terraform.

### Module Source Not Found

```bash
Error: Module not found

  on vcf_host_commission.tf line 3, in module "host_commission":
   3:   source = "../../../modules/vcf/vcf_host_commission"

Module "vcf_host_commission" could not be found at "../../../modules/vcf/vcf_host_commission".
```

- **Cause**: The module source path is incorrect or the module is missing.
- **What to Check**:
  - Verify that the module path (`../../../modules/vcf/vcf_host_commission`) is correct relative to the current directory where Terraform is being executed.
  - Ensure that the module is located at the specified path and that it contains valid Terraform files (`main.tf`, `outputs.tf`, etc.).
- **Solution**:
  - Double-check the module source path. Ensure that the module exists in the specified location and contains the necessary files.
