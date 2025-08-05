# Task List

Generic task list for building out the VCF lab environment.

## Lab Preparation

- [ ] Rack and stack, burn-in servers.
- [ ] Configure ```Staging Server``` for tools deployment, hosting VMW Content Library and various infrastructure seed tools such as the VCF Cloud Builder appliance.  The software versions should align with the VCF BOM for the racks of servers.
  - This server can configured with a local datastore and/or NFS.
    - [ ] Host Image - ```8.0.x-###```
    - [ ] Deploy vCenter appliance  ```8.0.x-###```
      - Create vSphere Cluster and add staging host.
      - Create Content Library with local or NFS storage backing.
- [ ] Configure infrastructure networking for Top-of-Rack switching, routing and trunking (standard VCF infrastructure networks).
  - **VM Management** (TOR 1/2)
  - **ESXi Management** (TOR 1/2)
  - **vMotion** (TOR 1/2)
  - **vSAN** (TOR 1/2)
  - **ESXi Tunnel-Endpoint** (TOR 1/2)
  - **Edge-VM Tunnel-Endpoint** (TOR 1/2)
  - **BGP**
    - BGP 1 (TOR 1)
    - BGP 2 (TOR 2)
    - Define BGP ASN per TOR pair/Rack
  - *Untagged VLAN with DHCP - for ESXi imaging?*
- [ ] Configure DNS server and define forward and reverse lookup for networks.
  - Zone - **sddc.lab**
  - **Management** infrastructure networks.
    - [ ] Add DNS entries [Reference Table](dns.md)
- [ ] Deploy and configure DHCP server for host imagine/PXE boot.

## ESXi Preparation

Defined tasks for install, configure and preparation for VMware Cloud Foundation usage.

- [ ] Install ESXi OS using host image ```8.0.x-###``` - or vendor specific ISO image.
  - PXE boot imaging
    - Align drivers and firmware.
- [ ] Generate self-signed certificate per host.
  ~~~
  /sbin/generate-certificate
  /etc/init.d/hostd restart
  /etc/init.d/vpxa restart
  ~~~