FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    mininet \
    openvswitch-switch \
    openvswitch-testcontroller \
    python3-pip \
    net-tools \
    iputils-ping \
    iproute2 \
    tcpdump \
    tshark \
    tmux \
    nano \
    vim \
    curl \
    kmod \
    socat \
    netcat \
    iperf \
    iperf3 \
    sudo && \
    rm -rf /var/lib/apt/lists/*

# Install Ryu and dependencies
RUN pip3 install --no-cache-dir ryu eventlet routes webob paramiko

# Install switch
RUN cd /tmp && \
    apt-get update && \
    apt-get install -y git make gcc && \
    git clone https://github.com/mininet/mininet.git && \
    cd mininet && \
    util/install.sh -a && \
    cd / && \
    rm -rf /tmp/mininet && \
    apt-get remove -y git make gcc && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Install ttyd for web terminal
RUN curl -L https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 \
    -o /usr/bin/ttyd && chmod +x /usr/bin/ttyd

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Create student user
RUN useradd -m -s /bin/bash student && \
    echo 'student ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN mkdir -p /src && cp -av /home/student/. /src/

# Setup course materials
USER student
WORKDIR /home/student
COPY --chown=student:student materials/ /src/

# default password - change this per container in compose file
ENV STUDENT_PWD=password
USER root
EXPOSE 7681
ENTRYPOINT ["/entrypoint.sh"]
