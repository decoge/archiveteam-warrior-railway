FROM debian:bookworm-slim

# Install all required system packages
# Added 'autopoint' to fix previous bootstrap issue
# Using '--skip-po' in bootstrap below, so 'wget' package is no longer needed
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    rsync \
    screen \
    curl \
    lua5.1 \
    liblua5.1-0-dev \
    libgnutls28-dev \
    flex \
    gettext \
    libtool \
    autopoint \
    texinfo \
    gperf \
    automake \
    autoconf \
    autogen \
    shtool \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip, setuptools, and wheel
RUN python3 -m pip install --upgrade pip setuptools wheel --break-system-packages

# Create warrior user
RUN useradd -m -s /bin/bash warrior

# Set working directory to warrior's home
WORKDIR /home/warrior

# Install seesaw-kit and make its scripts available system-wide
RUN git clone https://github.com/ArchiveTeam/seesaw-kit.git && \
    cd seesaw-kit && \
    pip3 install -r requirements.txt --break-system-packages && \
    cp -r seesaw /usr/local/lib/python3.11/site-packages/ && \
    cp run-pipeline3 run-warrior3 /usr/local/bin/ && \
    cd .. && \
    rm -rf seesaw-kit

# Clone warrior projects
RUN git clone https://github.com/ArchiveTeam/warrior-code2.git projects && \
    chown -R warrior:warrior projects

# Build custom wget-at (wget-lua) with --skip-po to avoid needing the 'wget' package
RUN git clone https://github.com/ArchiveTeam/wget-lua.git && \
    cd wget-lua && \
    git checkout v1.20.3-at && \
    ./bootstrap --skip-po && \
    ./configure --with-ssl=gnutls && \
    make && \
    cp src/wget /usr/local/bin/wget-at && \
    cd .. && \
    rm -rf wget-lua

# Copy additional scripts (adjust paths/names if your local files differ)
COPY warrior.sh /home/warrior/
COPY start.py /home/warrior/
COPY env-to-json.sh /home/warrior/

# Make scripts executable
RUN chmod +x warrior.sh start.py env-to-json.sh

# Expose the Warrior web interface port
EXPOSE 8001

# Switch to warrior user
USER warrior

# Default command (adjust if your entrypoint differs)
CMD ["/home/warrior/start.py"]
