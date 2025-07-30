# Infrastructure Subnetting

## Physical Lab Networking

- VDI VM Network: 10.20.32.0/24
- SHI Hosted VM Management: 10.20.33.0/24
  - DNS, NTP, DHCP
- SHI Customer Edge Peering: 10.20.35.0/26
- Customer Supernet: 10.232.0.0/16 (start from 10.232.128.0/17)
  - VCF will be subnetted from this

## Subnets by Rack

| <code style="Yellow">Scope</code> | <code style="Yellow">VLAN</code> | <code style="Yellow">Function</code> | <code style="Yellow">IP Subnet</code> | <code style="Yellow">Notes</code> |
| --------------------------------- | -------------------------------- | ------------------------------------ | ------------------------------------- | --------------------------------- |
| Rack 1                            | untagged                         | PXE/DHCP                             | 10.232.129.0/24                       |                                   |
| Rack 1                            | 3701                             | OOB Management                       | 10.232.130.0/24                       |                                   |
| Rack 1                            | 3702                             | ESXi Management                      | 10.232.131.0/24                       | VCF Appliances (5.0)              |
| Rack 1                            | 3703                             | VM Management                        | 10.232.132.0/24                       | Edges, VCF Appliances (5.1)       |
| Rack 1                            | 3704                             | vSAN                                 | 10.232.133.0/24                       |                                   |
| Rack 1                            | 3705                             | vMotion                              | 10.232.134.0/24                       |                                   |
| Rack 1                            | 3706                             | Host TEP                             | 10.232.135.0/24                       | Must support jumbo frames         |
| Rack 1                            | 3707                             | Edge-VM TEP                          | 10.232.136.0.24                       | Must support jumbo frames         |
| Rack 1                            | 3708                             | BGP 1                                | 10.232.137.0/24                       | TOR-A only                        |
| Rack 1                            | 3709                             | BGP 2                                | 10.232.138.0/24                       | TOR-B only                        |

| <code style="Yellow">Scope</code> | <code style="Yellow">VLAN</code> | <code style="Yellow">Function</code> | <code style="Yellow">IP Subnet</code> | <code style="Yellow">Notes</code> |
| --------------------------------- | -------------------------------- | ------------------------------------ | ------------------------------------- | --------------------------------- |
| Rack 2                            | untagged                         | PXE/DHCP                             | 10.232.129.0/24                       |                                   |
| Rack 2                            | 3701                             | OOB Management                       | 10.232.140.0/24                       |                                   |
| Rack 2                            | 3702                             | ESXi Management                      | 10.232.141.0/24                       |                                   |
| Rack 2                            | 3703                             | VM Management                        | 10.232.142.0/24                       | Edges                             |
| Rack 2                            | 3704                             | vSAN                                 | 10.232.143.0/24                       |                                   |
| Rack 2                            | 3705                             | vMotion                              | 10.232.144.0/24                       |                                   |
| Rack 2                            | 3706                             | Host TEP                             | 10.232.145.0/24                       | Must support jumbo frames         |
| Rack 2                            | 3707                             | Edge-VM TEP                          | 10.232.146.0.24                       | Must support jumbo frames         |
| Rack 2                            | 3708                             | BGP 1                                | 10.232.147.0/24                       | TOR-A only                        |
| Rack 2                            | 3709                             | BGP 2                                | 10.232.148.0/24                       | TOR-B only                        |

| <code style="Yellow">Scope</code> | <code style="Yellow">VLAN</code> | <code style="Yellow">Function</code> | <code style="Yellow">IP Subnet</code> | <code style="Yellow">Notes</code> |
| --------------------------------- | -------------------------------- | ------------------------------------ | ------------------------------------- | --------------------------------- |
| Rack 3                            | untagged                         | PXE/DHCP                             | 10.232.129.0/24                       |                                   |
| Rack 3                            | 3701                             | OOB Management                       | 10.232.150.0/24                       |                                   |
| Rack 3                            | 3702                             | ESXi Management                      | 10.232.151.0/24                       |                                   |
| Rack 3                            | 3703                             | VM Management                        | 10.232.152.0/24                       | Edges                             |
| Rack 3                            | 3704                             | vSAN                                 | 10.232.153.0/24                       |                                   |
| Rack 3                            | 3705                             | vMotion                              | 10.232.154.0/24                       |                                   |
| Rack 3                            | 3706                             | Host TEP                             | 10.232.155.0/24                       | Must support jumbo frames         |
| Rack 3                            | 3707                             | Edge-VM TEP                          | 10.232.156.0.24                       | Must support jumbo frames         |
| Rack 3                            | 3708                             | BGP 1                                | 10.232.157.0/24                       | TOR-A only                        |
| Rack 3                            | 3709                             | BGP 2                                | 10.232.158.0/24                       | TOR-B only                        |
