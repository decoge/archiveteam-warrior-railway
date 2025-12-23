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
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash warrior

WORKDIR /home/warrior

RUN git clone https://github.com/ArchiveTeam/seesaw-kit.git && \
    cd seesaw-kit && \
    python3 setup.py install

RUN git clone https://github.com/ArchiveTeam/warrior-code2.git projects && \
    chown -R warrior:warrior projects

# Copy wget-at (modified wget) from base image equivalent
# (This replicates the multi-stage build in the official Dockerfile)
COPY --from=atdr.meo.ws/archiveteam/grab-base:gnutls /usr/local/bin/wget-at /usr/local/bin/wget-at

COPY warrior.sh /home/warrior/
COPY start.py /home/warrior/
COPY env-to-json.sh /home/warrior/

RUN chmod +x warrior.sh start.py env-to-json.sh

VOLUME /home/warrior/data

EXPOSE 8001

USER warrior

CMD ["/home/warrior/start.py"]
