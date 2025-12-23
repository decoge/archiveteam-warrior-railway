# Use the official pre-built Warrior image
FROM atdr.meo.ws/archiveteam/warrior-dockerfile

# Switch to root temporarily to create the wrapper script
USER root

# Create the startup wrapper that fixes permissions on every container start
RUN echo '#!/bin/bash\n\
# Fix ownership and permissions on the data directory\n\
mkdir -p /home/warrior/data\n\
chown -R warrior:warrior /home/warrior/data\n\
chmod -R 755 /home/warrior/data\n\
\n\
# Run the original Warrior entrypoint as the warrior user\n\
exec su-exec warrior /usr/local/bin/run-warrior3 "$@"' > /fix-permissions.sh && \
    chmod +x /fix-permissions.sh

# Switch back to the warrior user (safe default)
USER warrior

# Use our wrapper as entrypoint
ENTRYPOINT ["/fix-permissions.sh"]

# Default command (inherited from base image)
CMD []

EXPOSE 8001
