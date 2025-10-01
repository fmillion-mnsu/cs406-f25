# Group Assignment Phase 2 - SDN Scenario

In this section of the major assignment for this course, you'll plan out and begin developing the topology for a custom network using an SDN.

## Part 1: Requirements Analysis

### Task 1: Choose a scenario

**Select a scenario** for your network design. You may choose one of these examples, or you can come up with your own, as long as you are able to complete the following sections appropriately.

1. **Small Medical Clinic** (10-30 users)
   - Staff networks, patient systems, guest WiFi
   - Medical device network considerations

2. **Community College Campus Building** (100-200 users)
   - Faculty, student, administrative, and guest networks
   - Lab/classroom considerations

3. **Small Tech Startup Office** (20-50 users)
   - Development, operations, guest networks
   - IoT/smart office devices

4. **Public Library Branch** (50-100 users)
   - Staff network, public access, digital media stations (potentially with privileged access e.g. to online library databases)
   - Children's area considerations

5. **Boutique Hotel** (20-40 rooms + staff)
   - Guest room network, staff operations, back-office
   - IoT devices (smart locks, thermostats)

For your chosen scenario, identify and document:

1. **At least 3 distinct user populations** requiring network isolation.

    For example, in a small medical clinic, your populations might be Doctors/Nurses, Administrative Staff, and Patients/Guests.

2. **For each population, specify**:

   - Typical types of traffic (web browsing, database access, video streaming, etc.)
   - Security/isolation requirements
   - Any special performance needs (e.gg. medical IoT devices need priority over YouTube streaming)

3. **Identify any special device categories**:
   - IoT devices
   - Servers/infrastructure (either cloud or local - you can assume cloud since we're building an SDN)
   - Printers/shared resources

## Part 2: Topology Design

Your topology **must include**:

- **Minimum 3 switches** (to demonstrate multi-switch SDN coordination)
- **Minimum 2 routers/layer-3 devices** (can be switches with routing capability)
- **At least 3 distinct broadcast domains** (VLANs or separate subnets - implemented using routers and switches)
- **At least one redundant path** between critical network segments (to demonstrate loop handling)
- **Minimum 8 hosts** distributed across your network segments

Create a detailed network diagram showing:

1. **Physical topology**:
   - Switches, routers, and their interconnections
   - Host placement and grouping by network segment (you don't have to show many hosts, but you can include e.g. "guest devices" as one "host")

2. **Logical overlay**:
   - VLAN assignments or subnet boundaries
   - Your redundant paths

3. **Annotation**:
   - Label which devices belong to which user population
   - Note any special link requirements (trunk ports, access ports)
   - Mark your "critical path" (most important data flow) - this will typically be servers and/or IoT.

To make your diagrams, you can use [draw.io](https://draw.io), [Lucidchart](https://www.lucidchart.com/), [Mermaid.js](https://mermaid.js.org/) (if you like diagramming with code) or draw by hand (photographed or scanned).

We will have a short lecture session next week where we will look at diagramming tools for networking specifically.

## Part 3: Implementation - Topology Code

Create a new topology file `topologies/phase2_<scenario>.py` that implements your design.

**Requirements**:

- Include detailed comments explaining your design choices
- Use meaningful names (not just h1, h2, but `doctor_pc1`, `guest_wifi_ap`, etc.)
- Implement your redundant paths
- Configure link parameters if needed (bandwidth, delay)

**Example structure**:

```python
"""
Phase 2 Topology: Small Medical Clinic

Network Segments:
- Clinical Network (VLAN 10): Doctors, nurses, medical records
- Administrative Network (VLAN 20): Billing, scheduling
- Guest Network (VLAN 30): Patient WiFi, waiting room
"""

from mininet.topo import Topo

class ClinicTopo(Topo):
    def build(self):
        # Core switches with redundancy
        core_sw1 = self.addSwitch('s1', cls=OVSKernelSwitch, protocols='OpenFlow13')
        core_sw2 = self.addSwitch('s2', cls=OVSKernelSwitch, protocols='OpenFlow13')
        
        # Access switches per department
        clinical_sw = self.addSwitch('s3', cls=OVSKernelSwitch, protocols='OpenFlow13')
        admin_sw = self.addSwitch('s4', cls=OVSKernelSwitch, protocols='OpenFlow13')
        
        # Create redundant core
        self.addLink(core_sw1, core_sw2)  # This will be blocked by STP
        
        # ... rest of topology
```

## Part 4: Spanning Tree

Spanning Tree is the algorithm that allows *switches* to safely handle a loopback condition, by using the extra connection as a redundant link.

1. **Create a loop** in your topology (you already should have one for redundancy)

2. **Start your network** with the default controller:
   ```bash
   sudo mn --custom topologies/phase2_clinic.py --topo clinic --controller default
   ```

3. **Observe STP behavior**:
   ```bash
   # Check which ports are blocking
   mininet> sh ovs-vsctl list Port
   ```
   
   or
   
   ```bash
   mininet> sh ovs-ofctl show s1
   ```

4. Answer these questions in your journal:

    - Which link blocked when you introduced a loop? Why? (Screenshots may be helpful!)
    - If you were to drop a link in the network, how would STP reconfigure the network?

## Deliverables

Add these artifacts to your sprint journal:

### Technical Artifacts

- Your requirements document (1-2 pages) describing your scenario and justifying your network segmentation choices.
- Your network topology diagram(s) with annotations.
- Topology code file with comments

You will not submit anything until the end of the project, but please keep your deliverables in order and collected in one place!
