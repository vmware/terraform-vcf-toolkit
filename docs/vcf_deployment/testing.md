# Testing Overview

Measure network traffic throughput characteristics on hosts running clients and server. This example will require configuration of three (3) ***client*** VMs and one (1) ***server*** VM

* Throughput can be measured using ```esxtop```. The values in focus are PNIC and vNIC attributes.
* Packet drops and packet errors can be noted down at periodic intervals using ```vsish```
* Storage throughput can be noted down at periodic intervals for vsan cluster using vcenter inbuilt monitoring such as the default performance UI statistics.
  * *Optionally, Aria Operations can be leveraged to monitor from the same metrics.*

## ESXCLI Troubleshooting

For general connectivity and pathing, use ```ping```, ```vmkping```, and ```traceroute```

For overall performance metrics leverage ```esxtop``` network view (**n** key).

For in-depth details on what ***worldlets*** (or CPU threads, listed as “sys”) are spun up for handling network IO information can be parsed with ```net-stats```

**Examples:**

  1. To determine the switch port numbers and MAC addresses for all VMkernel interfaces, vmnic uplinks and vNIC ports:
  
      ~~~ cli
      esxcli> net-stats -l 
      ~~~

  2. Verifying if NetQueue or Receive Side Scaling (RSS) is active for vmnic’s by mapping the “sys” output to the worldlet name using i.e. the vsi shell (vsish -e cat /world<world id>/name).
  
      ~~~ sh
      esxcli> net-stats -A -t vW
      ~~~

**Additional ESXCLI tools:**

* ```pktcap-uw``` - capture frames at the uplink(s), vSwitch or, virtual-port levels
* ```tcpdump-uw``` - capture packets at the VMkernel interface level.
* ```nc``` - NetCat to verify port reachability.
  * iSCSI port on a storage array is reachable

      ~~~ cli
      esxcli> nc -z <destination IP> 3260
      ~~~

## ESXi

Run basic network speed Bandwidth throughput test between ESXi Hosts, port mirroring, netflow, packet capture investigations, Storage network IO monitoring, NSX trace flow.

**Traffic Types:**

* Management network
* Virtual Machine network
* vMotion network
* vSAN network

### Measuring provisioned VMs Rx/Tx/Bandwidth  

**VSISH:**

1. Discover the vmknics on each hosts, ensure NIOC (Network IO Control) is enabled on DVS.
2. Send traffic between vNICs using **netperf**, with random duration and sleep time.
3. Send traffic between vmknics using **netperf**, with random duration and sleep time.
4. Verify traffic is flowing and verify NetQueue Tx Rx counter increasing via **vsish**.

**Port Mirroring:**

1. Create four (4) VMs and attach each VM to a separate port-group.
2. Create port-mirror session

    ~~~ cli
    esxcli> RSPAN source, src: vm1, dst: vm3, dstuplink: uplink0,allow Normal I/O traffic
    ~~~

3. Send traffic from VM1 to VM2.  Verify VM3 can receive the traffic.
4. Send traffic from VM1 to VM3.  Verify VM4 can receive the traffic.

**NetFlow:**

1. Add two VMs to the host
2. Enable netflow for IPv4 on the portgroup, set active flow timeout to 60, set idle flow timeout to 200
3. Send traffic for 70 seconds, the IPv4 traffic can generate flow records
4. Verify the IPv4 traffic between vnic generate flow records

**Packet Capture:**

1. Attach two (2) VMs to Segments/Overlay backed DVPG and monitor traffic flow with **pktcap-uw** tool using '--vni' option , save pcapng file and check if the packet comment has field ENCAPCSUMVFD
2. Send traffic from a VM vnic port to vmknic port
    * Trace traffic flow with pktcap-uw tool
    * Test the 'trace' option of pktcap-uw tool
  
      ```pktcap-uw --switchport xxxxxx --rcf "src host VM1"``` - dump packet with src ip of VM1

      ```pktcap-uw --switchport xxxxxx --rcf "src host VM1 and dst host VM3"``` - dump packet with src ip of VM1 and dst ip of VM3.

      ```pktcap-uw --switchport xxxxxx --rcf "src host VM1 or src host VM3"``` - dump packet with src ip of VM1 or src ip of VM3.

      ```pktcap-uw --switchport xxxxxx --rcf "not src host VM1 and dst host VM3"``` - dump packet src ip not of VM1 and dst ip of VM3.
  