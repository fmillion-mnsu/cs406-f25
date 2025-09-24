#!/bin/bash

echo
echo "SDN Lab Environment Check"
echo "========================="
echo

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check Mininet
echo -n "Checking Mininet installation... "
if command -v mn &> /dev/null; then
    echo -e "${GREEN}✓${NC} $(mn --version 2>&1)"
else
    echo -e "${RED}✗${NC} Mininet not found"
fi

# Check Open vSwitch
echo -n "Checking Open vSwitch...         "
if command -v ovs-vsctl &> /dev/null; then
    echo -e "${GREEN}✓${NC} $(ovs-vsctl --version | head -1)"
else
    echo -e "${RED}✗${NC} Open vSwitch not found"
fi

# Check Python 3
echo -n "Checking Python 3...             "
if command -v python3 &> /dev/null; then
    echo -e "${GREEN}✓${NC} $(python3 --version)"
else
    echo -e "${RED}✗${NC} Python 3 not found"
fi

# Check Ryu
echo -n "Checking Ryu SDN Framework...    "
if python3 -c "import ryu" 2>/dev/null; then
    RYU_VERSION=$(ryu-manager --version 2>&1 | head -1)
    echo -e "${GREEN}✓${NC} Ryu $RYU_VERSION"
else
    echo -e "${RED}✗${NC} Ryu not installed"
fi

# Check for tshark
echo -n "Checking packet capture tools... "
if command -v tshark &> /dev/null; then
    echo -e "${GREEN}✓${NC} tshark available"
elif command -v tcpdump &> /dev/null; then
    echo -e "${GREEN}✓${NC} tcpdump available"
else
    echo -e "${RED}✗${NC} No packet capture tools found"
fi

# Check tmux
echo -n "Checking tmux...                 "
if command -v tmux &> /dev/null; then
    echo -e "${GREEN}✓${NC} tmux available"
else
    echo -e "${RED}✗${NC} tmux not found (optional but recommended)"
fi

# Test Mininet basic functionality
# echo -n "Testing Mininet functionality... "
# if sudo mn --test none &> /dev/null; then
#     echo -e "${GREEN}✓${NC} Mininet working"
# else
#     echo -e "${RED}✗${NC} Mininet test failed"
# fi

echo ""
echo "Setup check complete!"
echo "If any components show ✗, please contact instructor for help."
echo