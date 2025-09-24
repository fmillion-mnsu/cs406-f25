#!/usr/bin/env python3
"""
Basic SDN Topology - Creates a simple network with 3 hosts and 1 switch
You can run Mininet with this topology file:
sudo mn --custom sdn-lab/materials/topologies/basic.py --topo basic --
"""

from mininet.topo import Topo

class BasicTopo(Topo):
    """Basic topology with 3 hosts and 1 switch"""
    
    def build(self):
        # Add hosts
        h1 = self.addHost('h1', ip='10.0.0.1/24')
        h2 = self.addHost('h2', ip='10.0.0.2/24')
        h3 = self.addHost('h3', ip='10.0.0.3/24')
        
        # Add switch
        s1 = self.addSwitch('s1')
        
        # Add links
        self.addLink(h1, s1)
        self.addLink(h2, s1)
        self.addLink(h3, s1)

# Make it executable
topos = {'basic': BasicTopo}