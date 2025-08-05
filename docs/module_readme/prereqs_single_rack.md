# Pre-Requisites

This section lists the prerequisites for typical environment configuration and requirements to consume the "Single-Rack" topology model.

## IP Addressing per Fault-Domain

Networks should be sized accordingly, based on number of VMKernel interfaces and physical interfaces, with examples below.

* <span style="color:lightblue">**ESXi Management**</span>
  * **VLAN 10** - 10.0.10.0/24
* <span style="color:lightblue">**Management Appliances**</span>
  * **VLAN 11** - 10.0.11.0/24
    * this may be required only in one (1) rack depending on the deployment model
* <span style="color:lightblue">**vSAN**</span>
  * **VLAN 12** - 10.0.12.0/24
* <span style="color:lightblue">**vMotion**</span>
  * **VLAN 13** - 10.0.13.0/24
* <span style="color:lightblue">**NSX Tunnel End-Points (ESXi)**</span>
  * **VLAN 114** - 10.0.14.0/24
* <span style="color:lightblue">**NSX Tunnel End-Points (NSX Edge VMs)**</span>
  * **VLAN 15** - 10.0.15.0/24

## Network Underlay

1. **BGP configuration**
    * If running the NSX Logical-Routing module(s), valid BGP configuration is required.
        * ASN(s) - One (1) per local NSX Edge-Cluster, one (1) per remote TOR pair/fault-domain
        * Timers
        * Password
2. **MTU** - Network underlay MTU of at least 1700 bytes, with a maximum of 9000 bytes.

## Infrastructure

1. **FQDN** - Forward and Reverse lookup for all ESXi hosts and VCF appliances
2. **NTP server(s)**
3. **DNS server(s)**
4. **Certificates**
    * Self-Signed certificates are acceptable and should be added to the host machine executing the Terraform modules/plans.
        > **esxcli> /sbin/generate-certificates**
    * SSL validation/thumbprint validation is currently ignored, this can be changed via the module configuration directly.

## VCF Licensing

* vCenter
* vSAN
* ESXi
* NSX
* Aria Suite (Optional)

