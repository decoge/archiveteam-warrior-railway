FROM debian:bookworm-slim

# Install all build and runtime dependencies
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
    texinfo \
    gperf \
    automake \
    autoconf \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and setuptools to avoid install_layout errors
RUN python3 -m pip install --upgrade pip setuptools wheel

# Create warrior user
RUN useradd -m -s /bin/bash warrior

WORKDIR /home/warrior

# Clone and install seesaw-kit (use pip for dependencies)
RUN git clone https://github.com/ArchiveTeam/seesaw-kit.git && \
    cd seesaw-kit && \
    pip3 install -r requirements.txt && \
    python3 setup.py install

# Clone warrior projects
RUN git clone https://github.com/ArchiveTeam/warrior-code2.git projects && \
    chown -R warrior:warrior projects

# Build wget-at locally (ArchiveTeam's modified wget with Lua support)
RUN git clone https://github.com/ArchiveTeam/wget-lua.git && \
    cd wget-lua && \
    git checkout v1.20.3-at && \
    ./bootstrap && \
    ./configure --with-ssl=gnutls --with-lib PSL && \
    make && \
    cp src/wget /usr/local/bin/wget-at && \
    cd .. && \
    rm -rf wget-lua

# Copy supporting scripts (add these files to your repo root!)
COPY warrior.sh /home/warrior/
COPY start.py /home/warrior/
COPY env-to-json.sh /home/warrior/

RUN chmod +x warrior.sh start.py env-to-json.sh

EXPOSE 8001

USER warrior

CMD ["/home/warrior/start.py"]
