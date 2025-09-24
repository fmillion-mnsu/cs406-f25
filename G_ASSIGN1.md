# Group Assignment 1 - Introduction to SDN

In this assignment you will explore Software-Defined Networking (SDN) by building a simple network, observing how the control and data planes interact, and implementing your first programmable network behavior. This hands-on introduction will establish the foundation for more complex SDN applications in future phases.

## Learning Objectives

By completing this assignment, you will:

- Understand the separation between SDN control plane and data plane
- Create and modify network topologies using Mininet
- Observe and analyze OpenFlow protocol messages between switches and controllers
- Implement basic network control logic using the Ryu SDN framework
- Document and reflect on how programmable networks differ from traditional networking

## Phase 1 Overview

This is Phase 1 of a multi-week SDN project. In this phase, you'll establish a working SDN environment and implement basic control mechanisms. Future phases will build upon this foundation to explore dynamic routing, network slicing, and application-aware networking.

## Setup Steps

You will access your SDN lab environment through a web-based terminal:

1. Navigate to: `https://g<n>.cs406.campus-quest.com` (replace `<n>` with your **group number**) and log in using the username and password given to your group.

    You'll see a terminal with all necessary tools pre-installed. All work can be completed entirely through this web interface

> [!TIP]
> Use `tmux` to manage multiple terminal windows. Quick reference:
> - `tmux new -s sdn` - Create new session
> - `Ctrl-B, c` - New window
> - `Ctrl-B, [0-9]` - Switch between windows
> - `Ctrl-B, d` - Detach (your session continues running)
> - `tmux attach -t sdn` - Reattach to your session
>
> Using `tmux` is optional, as you can also simply open multiple browser windows to the server to get more terminals.

2. Verify your environment is properly configured:

```bash
./check_setup.sh
```

You should see all green checkmarks. If any component shows an error, contact me for assistance.

3. Access your **VS Code cloud instance** by visiting `https://code-g<n>.cs406.campus-quest.com` (replace `<n>` with your group number!). The password is the same as the admin password you were given in class.

> [!IMPORTANT]
> You **cannot** use the VS Code terminal to run commands for the SDN exercise. The VS Code's integrated terminal is in a different virtual environment than the actual SDN environment - the only thing that is shared between the two is your code directory. Changes you make in VS Code are immediately reflected in the SDN environment, but you must use the web terminal to actually execute commands. 
>
> If you do try to run any SDN commands in the VS Code terminal, they will fail.

## Part 1: Basic Topology Creation

1. **Examine the provided topology file**:
   ```bash
   cat topologies/basic.py
   ```

    or open the file in VS Code.

2. **Run Mininet with the basic topology**:
   ```bash
   sudo mn --custom topologies/basic.py --topo basic --switch user --controller none
   ```
   
   This creates a network with 3 hosts and 1 switch, but no controller. 

3. **Test connectivity** from the Mininet CLI:
   ```
   mininet> pingall
   ```
   
   Why do the pings fail?

   > Even though we've created a virtual switch, that switch needs to be told what to do - it needs instructions. 
   >
   > Your small switch at home, and any standard off-the-shelf consumer grade network switch, already has a program that implements the basic switching logic (i.e. use store-and-forward with MAC address tables to isolate traffic to only the destination ports). However, enterprise switches - while they may come with this setup as a default - rarely stay in this generic configuration. Open vSwitch, therefore, does not implement any logic by default - without any instructions, it's just a dead-end for packets.
   >
   > The switch needs to get those instructions from *somewhere*...

4. **Examine the switch's flow table**:
   ```
   mininet> sh ovs-ofctl dump-flows s1
   ```
   
   **Document**: What do you observe? Take a **screenshot**.

5. **Exit Mininet**:
   ```
   mininet> exit
   ```

### Task 2: Adding a Controller

1. **Run the same topology WITH a default controller**:
   ```bash
   sudo mn --custom topologies/basic.py --topo basic --switch user --controller default
   ```

2. **Test connectivity again**:
   ```
   mininet> pingall
   ```
   
   **Document**: What changed and why?

3. **Check the flow table again**:
   ```
   mininet> sh ovs-ofctl dump-flows s1
   ```
   
   **Document**: How many flow entries do you see now? What do they do?

### Exploration Challenge

Without exiting Mininet, can you manually add a flow rule that blocks traffic from h1 to h3, but allows all other traffic? 

> [!TIP]
> Hints:
> - Use `sh ovs-ofctl add-flow ...` from the Mininet prompt
> - Consider match fields: `in_port`, `nw_src`, `nw_dst`
> - Actions can include `drop` or `output:port`
> - This page documents the `ovs-ofctl add-flow` command: <https://pica8-fs.atlassian.net/wiki/spaces/PicOS443sp/pages/10477970>

Document your solution or your attempts if unsuccessful.

## Part 2: Understanding SDN Controllers

### Task 3: Running the Ryu Controller

1. **Open a new terminal window** (use `tmux` or open another browser tab)

2. **In Terminal 1**, start the Ryu controller with a simple L2 learning switch:
   ```bash
   ryu-manager --verbose ryu.app.simple_switch_13
   ```
   
   Leave this running and observe the log messages.

3. **In Terminal 2**, start Mininet with a remote controller:
   ```bash
   sudo mn --custom topologies/basic.py --topo basic --switch user --controller remote,ip=127.0.0.1,port=6633
   ```

   > The Mininet server will listen for OpenFlow traffic on port `6633`. A controller can send commands to this port to direct Mininet what to do with traffic.

4. **Perform connectivity tests** and observe the controller terminal:
   ```
   mininet> h1 ping -c 3 h2
   ```
   
   **Document**: How many PACKET_IN events do you see in the controller log? Why?

5. **Run a complete connectivity test**:
   ```
   mininet> pingall
   ```
   
   **Document**: After pingall completes, check the flow table. How is it different from the default controller's approach?

### Task 4: Expanding the Network

1. **Exit Mininet** (keep Ryu running)

2. **Copy and modify the topology**:
   ```bash
   cp topologies/basic.py topologies/task4.py
   ```
   
   then open the `task4.py` file using your VS Code editor instance.

   Add a 4th host (h4) and a 2nd switch (s2). Connect them however you like, but ensure all hosts can potentially reach each other.

3. **Run your new topology**:
   ```bash
   sudo mn --custom topologies/task4.py --topo basic --switch user --controller remote,ip=127.0.0.1,port=6633
   ```

4. **Test and document**:
   - Draw your topology (hand-drawn is fine, take a photo)
   - Run pingall and note the results
   - How many flow entries were installed across both switches?

### Observation Exercise

Using the `tshark` tool, capture OpenFlow messages. In a third terminal (while Mininet and Ryu are running):

```bash
sudo tshark -i lo -f "tcp port 6633" -c 20 -Y openflow_v4
```

Then trigger some traffic in Mininet and observe the OpenFlow messages.

**Document**: Can you identify at least one PACKET_IN and one FLOW_MOD message? What information do they contain?

> [!TIP]
> `tshark` is a command line version of Wireshark, a popular packet analysis and capture tool. You can also write your capture to a file and then download and open that file in the full graphical Wireshark application. This is left as an exercise to you, but as a hint, you can use the VS Code interface to download the capture file to your PC.

## Deliverables

Your team should maintain a sprint journal containing:

### Technical Artifacts

1. **Screenshot Collection** showing:
   - Successful environment verification
   - Flow tables at different stages
   - Controller log output with your modifications
   - Your custom topology working

2. **Code Submissions**:
   - Your modified topology file (`task4.py`)
   - Comments explaining your changes

3. **Network Documentation**:
   - Diagram of your custom topology (photo of hand-drawn is acceptable, or use draw.io - free online diagramming tool - to make a nice electronic version)

You will not submit anything until the end of the project, but please keep your deliverables in order and collected in one place!

## Tips and Troubleshooting

### Common Issues

**"Connection refused" when starting Mininet:**
- Ensure Ryu is running first
- Check the controller IP and port match

**"Cannot find module" errors:**
```bash
pip3 install ryu mininet
```

**Mininet won't exit cleanly:**
```bash
sudo mn -c  # Cleanup command
```

**Need to see packet contents:**
```bash
# In Mininet:
mininet> h1 tcpdump -i h1-eth0 -w capture.pcap
# Then in another window:
tcpdump -r capture.pcap -nn
```

### Useful Commands Reference

```bash
# Check flows on switch
ovs-ofctl dump-flows s1

# Clear all flows
ovs-ofctl del-flows s1

# Watch flows in real-time
watch -n 1 ovs-ofctl dump-flows s1

# See OpenFlow version
ovs-ofctl --version

# Check controller connection
ovs-vsctl show
```

## Looking Ahead

In Phase 2, you will:

- Modify the switch configuration in Ryu to add custom functionality
- Work with multiple switches and redundant paths
- Implement custom routing algorithms
- Explore network slicing concepts
- Choose a real-world context for your SDN application

Make sure you understand the concepts from Phase 1, as they form the foundation for the upcoming work.

---
