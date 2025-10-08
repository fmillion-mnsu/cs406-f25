# Group Assignment Phase 3 - Implementation & Testing

In this final phase of the SDN project, you will implement your designed network with security policies, quality of service considerations, and comprehensive testing. This phase brings together all the concepts from Phases 1 and 2 into a complete, functional SDN deployment.

## Learning Objectives

- Implement network segmentation and isolation using SDN flow rules
- Configure security policies appropriate to your scenario
- Apply quality of service (QoS) concepts to network traffic management
- Test and validate network behavior including failure scenarios
- Document a complete SDN deployment for reproducibility
- Reflect on SDN concepts and their application to real-world networking

## Phase 3 Overview

This is the culminating phase of your SDN project. You will take your Phase 2 topology and requirements, implement the necessary controller logic in Ryu, configure your policies, and thoroughly test your network. The deliverable is a complete, documented, working SDN deployment that fulfills the requirements you specified in Phase 2.

You may refine or adjust your Phase 2 design based on what you learn during implementation, as long as changes are well-reasoned and documented.

> [!IMPORTANT]
>
> A few important notes about this assignment:
>
> * You do NOT need to implement full-blown "routers" for your routers. OVS layer 3 (L3) switches are sufficient.
> * Organize all of your documentation into one place. You can submit one single large document if you prefer. If you submit multiple documents, make sure they are clearly labeled.

## Part 1: Controller Implementation

### Task 1: Basic Routing & Switching

Implement a Ryu controller application that handles basic network operations for your topology.

**Requirements**:

1. **Create a new controller file** `controllers/phase3_<scenario>.py`

2. **Implement basic L2/L3 forwarding** for your network segments:
   - MAC address learning for hosts within the same segment
   - Routing between different network segments/VLANs
   - ARP handling as appropriate

3. **Configure routing tables** to ensure connectivity between segments where appropriate:
   - Document which segments should be able to communicate
   - Install flow rules that implement your routing design
   - Verify routes are created correctly using `ovs-ofctl dump-flows`

**Example controller structure**:

```python
"""
Phase 3 Controller: Small Medical Clinic

This controller implements:
- Network segmentation (Clinical, Administrative, Guest)
- Access policies between segments
- QoS priorities for critical traffic
"""

from ryu.base import app_manager
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.ofproto import ofproto_v1_3
from ryu.lib.packet import packet, ethernet, ether_types

class ClinicController(app_manager.RyuApp):
    OFP_VERSIONS = [ofproto_v1_3.OFP_VERSION]

    def __init__(self, *args, **kwargs):
        super(ClinicController, self).__init__(*args, **kwargs)
        # Initialize your data structures
        self.mac_to_port = {}
        self.segment_policies = self._load_policies()
    
    def _load_policies(self):
        """Define access policies between network segments"""
        # Example: Clinical can access Admin, but Guest cannot
        return {
            'clinical_to_admin': 'allow',
            'guest_to_clinical': 'deny',
            # ... more policies
        }
    
    @set_ev_cls(ofp_event.EventOFPSwitchFeatures, CONFIG_DISPATCHER)
    def switch_features_handler(self, ev):
        """Handle switch connection"""
        # Install default flows
        pass
    
    @set_ev_cls(ofp_event.EventOFPPacketIn, MAIN_DISPATCHER)
    def packet_in_handler(self, ev):
        """Handle incoming packets"""
        # Implement your forwarding logic
        pass
```

### Task 2: Security & Access Policies

Implement **at least 2 different types of security or access control policies** from the following options. Choose the policies that make sense for your scenario:

**Policy Options**:

1. **Segment-to-segment isolation**: Block all traffic between certain network segments
   - Example: Guest network cannot reach administrative network

2. **Port-based filtering**: Allow/block specific TCP/UDP ports between segments
   - Example: Guests can access web server (ports 80/443) but not any other ports, such as SSH (port 22)

3. **Protocol-based rules**: Allow/deny specific types of traffic
   - Example: Block all ICMP from guest network, or allow only specific protocols

4. **Directional policies**: Different rules for traffic going each direction
   - Example: Admin can initiate connections to IoT devices, but IoT devices cannot initiate connections the other way (one-way isolation)

**Implementation Notes**:

- Use OpenFlow match fields: `in_port`, `eth_type`, `ip_proto`, `tcp_dst`, `udp_dst`, `ipv4_src`, `ipv4_dst`
- Actions can include: `output:port`, `drop`, or modify packet fields
- Consider using priority values to ensure correct rule ordering

**Documentation Requirements**:

For each policy type you implement, document:
- **Justification**: Why this policy is needed for your scenario
- **Threat/concern addressed**: What problem does it solve?
- **Implementation details**: How you implemented it (flow rules, match conditions, actions)
- **Testing approach**: How you verified it works

### Task 3: Quality of Service (QoS)

Implement basic traffic prioritization appropriate to your scenario.

**Requirements**:

1. **Identify at least 2 different traffic priority classes** in your scenario:
   - High priority: Critical operations (medical devices, security systems, etc.)
   - Normal priority: Standard business traffic
   - Low priority: Guest traffic, non-essential services

2. **Document your QoS policy**:
   - Which traffic gets what priority and why
   - How this relates to your scenario's needs

3. **Implement basic prioritization**:
   - You may use OpenFlow queues if you're comfortable with them
   - OR implement simple drop/rate-limiting for low-priority traffic
   - OR use flow rule priorities to prefer certain traffic types

> [!NOTE]
> The focus here is on understanding QoS concepts and making scenario-appropriate decisions. A simple implementation with good justification is better than a complex implementation without clear reasoning.

**Example documentation**:

```
QoS Policy - Medical Clinic

High Priority (Queue 0):
- Medical device traffic (IoT VLAN)
- Electronic health record access
Justification: Patient safety depends on timely device readings

Normal Priority (Queue 1):
- Administrative systems
- Staff workstations
Justification: Standard business operations

Low Priority (Queue 2):
- Guest WiFi traffic
- Staff personal devices
Justification: Non-critical, can tolerate delays
```

## Part 2: Testing & Validation

### Task 4: Connectivity Testing

Verify that your network segments work as designed.

**Required Tests**:

1. **Basic connectivity within segments**:
   ```
   mininet> h1 ping -c 3 h2
   ```
   Test that hosts in the same segment can communicate.

2. **Cross-segment connectivity**:
   - Test allowed paths: Verify segments that should communicate can do so
   - Test blocked paths: Verify isolation policies work

3. **Create a test matrix** showing expected vs actual results:

    For example:

   | Source Segment | Destination Segment | Expected | Actual | Notes |
   |----------------|---------------------|----------|--------|-------|
   | Clinical       | Admin               | Allow    | ✓      | Ping successful |
   | Guest          | Clinical            | Deny     | ✓      | Ping blocked |
   | ...            | ...                 | ...      | ...    | ... |

**Documentation**: Include screenshots or command outputs showing your tests.

### Task 5: Security Policy Validation

Test that your security policies are enforced correctly.

**Required Tests**:

1. **For segment isolation policies**:
   - Attempt communication that should be blocked
   - Verify pings/connections fail as expected

2. **For port-based filtering** (if implemented):
   - Test allowed ports work
   - Test blocked ports fail
   - Example: `h1 nc -l 80` (start listener), `h2 nc h1_ip 80` (connect)

3. **For each policy type**, document:
   - The test command(s) used
   - Expected behavior
   - Actual behavior
   - Screenshot or output capture

**Tip**: Use `tcpdump` to see if packets are arriving:
```
mininet> h1 tcpdump -i h1-eth0 -n
```

### Task 6: Failure Scenarios & STP

Test your network's resilience and spanning tree protocol implementation.

**Required Tests**:

1. **Verify STP is handling your redundant link**:
   ```
   mininet> sh ovs-ofctl show s1
   mininet> sh ovs-ofctl show s2
   ```
   Identify which redundant link is blocked.

2. **Simulate link failure**:
   ```
   mininet> link s1 s2 down
   ```
   - Verify traffic still flows (STP activates backup path)
   - Time how long it takes for connectivity to restore
   - Document the behavior

3. **Restore the link**:
   ```
   mininet> link s1 s2 up
   ```
   - Observe STP reconfiguration
   - Verify network returns to stable state

**Documentation**: Include before/after flow tables and connectivity test results.

> [!IMPORTANT]
> Note on STP:
> For failure scenario testing, **you do not need to implement STP logic in your Ryu controller**. Instead, continue to use OVS’s built-in STP (as you did in Phase 2). Make sure you enable it in your topology:
> 
>     sudo ovs-vsctl set Bridge s1 stp_enable=true
>     sudo ovs-vsctl set Bridge s2 stp_enable=true
> 
> Run your failure tests (link down / link up) while STP is enabled, and document how OVS automatically reconfigures the paths. Your Ryu controller does not need to handle loop prevention.
>
> Additionally, remember that STP must be enabled on **every switch participating in the loop**, not just `s1` and `s2`.

### Task 7: Troubleshooting Documentation

Document at least one configuration problem and its resolution.

**Options**:

1. **If you encountered a problem during implementation**: Document it!
   - What was the problem?
   - What symptoms did you observe?
   - How did you diagnose it?
   - What was the fix?

2. **If you didn't encounter problems**: Introduce one of the following deliberately: 
   - Create a misconfiguration (wrong port, conflicting rules, missing route, etc.)
   - Show the symptoms
   - Demonstrate your diagnostic process
   - Show the fix and verification

**Example issues to consider**:
- Flow rule priority conflicts causing unexpected behavior
- Missing ARP handling causing connectivity failures
- Incorrect VLAN tagging or port configuration
- Policy rule that's too broad or too narrow

> [!IMPORTANT]
> The documented issue must involve at least one of: flow rules, ARP, VLANs, or policy conflicts.

### Task 8: Setup Guide (README)

Create a README that would allow someone else to deploy and understand your network given your code and commands.

Include at a minimum:

* Step-by-step commands to start Ryu and Mininet with their topology
* Instructions to reproduce their tests (sample commands)
* A short "Known Issues / Limitations" section

**Format**: Create this as `README.md` (or any other standard format) in your project directory.

## Deliverables

Your final submission should include all artifacts (including sprint journal) from previous phases as well as:

- `topologies/phase2_<scenario>.py` - Your Mininet topology (updated if needed)
- `controllers/phase3_<scenario>.py` - Your Ryu controller implementation
- Setup and deployment guide
- Any additional configuration files or helper scripts
- Scenario requirements (if changed/updated from Phase 2)
- Topology diagrams (if changed/updated from Phase 2)
- Test documentation with screenshots

## Grading Rubric

|Category|4 - Exemplary|3 - Sufficient|2 - Weak|1 - Insufficient|
|-|-|-|-|-|
| Scenario & Requirements Documentation (25%) | Scenario is realistic, internally consistent, and well-justified. All network segments clearly defined with specific requirements. Security and QoS needs are scenario-appropriate and well-reasoned. | Scenario makes sense, requirements are clear. Some minor inconsistencies or gaps in justification. | Scenario is generic or poorly justified. Requirements are vague or incomplete. | Scenario is unrealistic or requirements are missing/incoherent. |
| Implementation - Topology & Controller Code (30%) | Code fully implements documented design. Clean, well-commented code. Meaningful naming conventions. All required components present (3+ switches, 2+ routers, redundant paths, 8+ hosts, 3+ segments). | Code implements design with minor discrepancies. Adequate comments. Meets minimum component requirements. | Code partially implements design or has significant gaps. Poor code quality or missing components. | Code doesn't match design, missing major components, or non-functional. |
| Security & Access Policies (20%) | Implements 2+ appropriate policy types with clear justification. Policies demonstrably work as documented. Scenario-driven choices. | Implements 2 policy types that work. Adequate justification. | Implements only one policy type or policies are arbitrary/poorly justified. | Missing policies or non-functional implementation. |
| Testing & Validation (15%) | Comprehensive testing covering connectivity, security (isolation verification), failure scenarios, and basic performance. Clear documentation of test procedures and results with screenshots/evidence. | Tests cover connectivity and security. Adequate documentation. | Limited testing or poor documentation of results. |  Minimal or no testing documentation. |
| Technical Documentation & Consistency (10%) | Documentation is clear, complete, and matches implementation perfectly. Includes topology diagrams, configuration details, README/setup instructions, and troubleshooting notes. | Good documentation with minor inconsistencies between docs and code. | Documentation is incomplete or has significant inconsistencies. | Poor or missing documentation.

## Tips and Best Practices

### Controller Development

**Start simple and iterate**:
```python
# First: Get basic L2 switching working
# Then: Add routing between segments
# Finally: Layer in security policies
```

**Use logging to debug**:
```python
self.logger.info("Packet from %s to %s", src, dst)
self.logger.debug("Installing flow for %s", match_fields)
```

**Test incrementally**:
- Verify each feature works before adding the next
- Keep backups of working versions

### Flow Rule Tips

**Check installed flows**:
```bash
# See all flows on a switch
sudo ovs-ofctl dump-flows s1 -O OpenFlow13

# Watch flows update in real-time
watch -n 1 'sudo ovs-ofctl dump-flows s1 -O OpenFlow13'
```

**Clear flows to start fresh**:
```bash
sudo ovs-ofctl del-flows s1 -O OpenFlow13
```

**Flow rule priority matters**:
- Higher priority (larger number) = checked first
- Specific rules should have higher priority than general rules
- Example: Drop rule for specific port (priority 100), Allow-all rule (priority 1)

### Testing Tips

**Verify packets are arriving**:
```bash
# On source host
mininet> h1 ping -c 1 10.0.0.2

# On destination host (in another terminal)
mininet> h2 tcpdump -i h2-eth0 -n icmp
```

**Test specific ports**:
```bash
# Start a listener
mininet> h1 python3 -m http.server 8080

# Try to connect
mininet> h2 curl http://10.0.0.1:8080
```

**Check ARP tables**:
```bash
mininet> h1 arp -n
```

### Common Issues

**"Cannot find topology"**:
- Ensure your topology file defines a `topos` dictionary
- Check the class name matches

**"Controller not connecting"**:
- Verify Ryu is running first
- Check OpenFlow version compatibility (use OpenFlow13)
- Ensure controller IP/port match

**"Flows not installing"**:
- Check controller logs for errors
- Verify match fields are valid
- Check flow priority ordering

**"STP not working"**:
- Ensure switches are OpenFlow13 capable
- Verify redundant links are properly configured
- Check for physical topology issues

## Looking Back

This project has taken you through the complete SDN lifecycle:

- **Phase 1**: Understanding SDN fundamentals and control/data plane separation
- **Phase 2**: Planning and designing a network topology for a specific scenario
- **Phase 3**: Implementing security policies, testing, and deploying a complete SDN solution

You've learned concepts that transfer to any SDN platform:

- Centralized control plane logic
- Flow-based packet forwarding
- Dynamic network programmability
- Policy enforcement through software
- Network virtualization and segmentation

These concepts apply whether you're using Ryu with Mininet, configuring AWS VPC networks, setting up Azure Virtual Networks, or working with enterprise SDN controllers.

**Questions or Issues?** Reach out to me during class or via E-mail or Teams. 

Good luck with your final implementation!