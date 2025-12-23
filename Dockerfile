FROM debian:bookworm-slim

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
    libzstd-dev \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install compatible old Tornado
RUN python3 -m pip install --upgrade pip setuptools wheel --break-system-packages && \
    pip3 install "tornado<5" sockjs-tornado==1.0.7 --break-system-packages

RUN useradd -m -s /bin/bash warrior

WORKDIR /home/warrior

# Install seesaw-kit
RUN git clone https://github.com/ArchiveTeam/seesaw-kit.git && \
    cd seesaw-kit && \
    pip3 install -r requirements.txt --break-system-packages && \
    pip3 install . --break-system-packages && \
    cp run-pipeline3 run-warrior3 /usr/local/bin/ && \
    cd .. && \
    rm -rf seesaw-kit

RUN git clone https://github.com/ArchiveTeam/warrior-code2.git projects && \
    chown -R warrior:warrior projects

RUN git clone https://github.com/ArchiveTeam/wget-lua.git && \
    cd wget-lua && \
    git checkout v1.20.3-at && \
    ./bootstrap --skip-po && \
    ./configure --with-ssl=gnutls && \
    make && \
    cp src/wget /usr/local/bin/wget-at && \
    cd .. && \
    rm -rf wget-lua

COPY warrior.sh /home/warrior/
COPY start.py /home/warrior/
COPY env-to-json.sh /home/warrior/

RUN sed -i 's/\r$//' /home/warrior/warrior.sh \
                     /home/warrior/start.py \
                     /home/warrior/env-to-json.sh && \
    chmod +x /home/warrior/warrior.sh \
             /home/warrior/start.py \
             /home/warrior/env-to-json.sh

EXPOSE 8001

USER warrior

CMD ["python3", "/home/warrior/start.py"]
