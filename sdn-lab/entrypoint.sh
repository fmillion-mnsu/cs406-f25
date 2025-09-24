#!/bin/bash

echo 
echo "============================"
echo " Starting SDN Lab Container "
echo "============================"
echo

# set password
echo "* setting student password to '${STUDENT_PWD}'"
echo -n "student:${STUDENT_PWD}" | chpasswd

if [ ! -f "/home/student/.configured" ]; then
    echo "* copying data"
    cp -a /src/. /home/student/
    touch /home/student/.configured
else
    echo "* data already copied, skipping."
fi

echo "* starting Open vSwitch services..."

# Create necessary directories
sudo mkdir -p /var/run/openvswitch
sudo mkdir -p /var/log/openvswitch

# Start ovsdb-server
if ! pgrep ovsdb-server > /dev/null; then
    sudo ovsdb-tool create /etc/openvswitch/conf.db \
        /usr/share/openvswitch/vswitch.ovsschema 2>/dev/null || true
    
    sudo ovsdb-server --remote=punix:/var/run/openvswitch/db.sock \
        --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
        --pidfile --detach --log-file
    
    sleep 2
fi

# Initialize database
echo "* initialize Open vSwitch database..."
sudo ovs-vsctl --no-wait init 2>/dev/null || true

# Start ovs-vswitchd
echo "* starting ovs-vswitchd..."
if ! pgrep ovs-vswitchd > /dev/null; then
    sudo ovs-vswitchd --pidfile --detach --log-file
    echo "Started ovs-vswitchd"
    sleep 1
fi

# Verify
echo -n "* checking Open vSwitch status... "
if sudo ovs-vsctl show > /dev/null 2>&1; then
    echo "✓ Open vSwitch is running"
else
    echo "✗ Failed to start Open vSwitch"
    exit 1
fi

echo "* starting ttyd."
exec ttyd -p 7681 -W login
