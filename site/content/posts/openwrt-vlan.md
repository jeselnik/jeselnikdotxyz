---
title: "VLANs with an OpenWRT router and a TP-Link Easy Smart Switch"
date: 2023-01-20
draft: false
---

In this tutorial I will be making use of a few terms:

* **Tagged** - A switch port which carries traffic belonging to multiple VLANs
    (also known as a _trunk_ in Cisco nomenclature)
* **Untagged** - A switch port which only carries traffic belonging to a single VLAN
    (also known as an _access_ port)
* **Uplink** - The switch port which connects to your router

## OpenWRT Configuration

### Per Interface

1. Go to Network -> Interfaces -> Devices
2. Click on "Add device configuration" and choose a device type of 
802.1q VLAN with the base device being your LAN interface. 
3. Choose your desired VLAN ID and save the device.

![](/vlan/01-device.png)

4. Go back to Interfaces and click "Add new interface". 
Set protocol as "static address" and set its device as the VLAN you created in a previous step. 
* You are now free to set your desired IPv4 address (ideally with a number corresponding to the created VLAN
i.e VLAN 10 - 192.168.10.1/24 ).

![](/vlan/02-interface.png)

I also recommend going to the "Advanced Settings" tab and setting the IPv6 assignment hint to your desired value
(and make sure you're assigning a /64 prefix to the interface). 

![](/vlan/03-v6-interface.png)

5. Save the interface

## Switch Configuration

1. Log into the switch and go to VLAN -> 802.1Q. 
2. Enter your VLAN ID
*  Set your uplink port as tagged and the ports which you want to belong to the VLAN as untagged ports. 

* In the screenshot below I have a Wi-Fi access point on port 1 which has SSIDs belonging to two VLANs; 
as multiple VLANs will be carried on this port it is tagged.

* The other ports are just connected to devices which I want to belong to the VLAN, thus they are untagged. 
My uplink port is not pictured but it is also a tagged port. 

![](/vlan/05-es-vlan10.png)

3. For whatever reason, the firmware on TP-Link Easy Smart switches allow you to set a single port as 
untagged for multiple VLANs. For best practices* you must ensure that a port is untagged for a single VLAN only. 
Enter the undesired VLAN ID and set the port as "Not Member". 
4. Apply your changes
5. Go to VLAN -> 802.1Q VLAN PVID Setting. This setting sets the VLAN ID for incoming untagged frames. 
*  To put it simply, if you have an untagged port assigned to VLAN x the PVID of that port is also x. 
For my tagged ports, 1's PVID is 1 as I want the management interface of the AP (which I haven't assigned to a VLAN) to be on 1**.
My uplink's PVID is also 1 as it is the native VLAN. 

![](/vlan/06-es-pvid.png)

## Addendum: WAN Interface Tagging

Some ISPs require a VLAN tag to be added to your WAN interface in order to connect to the internet.
This is trivial with OpenWRT.

1. Create a new 802.1q VLAN device with the base device being your WAN port
2. Go back to Interfaces and click edit on your WAN interface
3. Change the device from your WAN port to the VLAN device created in the first step
4. Repeat the previous step with your WAN6 device

## Footnotes
\* - I've read some comments stating this line of switches allows for VLAN hopping,
I assume it derives from this quirk.

\** - On a corporate/professional network, don't use the default VLAN as management,
create a management VLAN
