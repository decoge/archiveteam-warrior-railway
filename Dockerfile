# Use the official pre-built Warrior image
FROM atdr.meo.ws/archiveteam/warrior-dockerfile

# Create a startup script to fix permissions
RUN echo '#!/bin/bash\n\
# Fix ownership and permissions on the data directory\n\
chown -R warrior:warrior /home/warrior/data 2>/dev/null || true\n\
chmod -R 755 /home/warrior/data 2>/dev/null || true\n\
\n\
# Run the original Warrior entrypoint\n\
exec /usr/local/bin/run-warrior3 "$@"' > /fix-permissions.sh && \
    chmod +x /fix-permissions.sh

# Use our wrapper as entrypoint
ENTRYPOINT ["/fix-permissions.sh"]

# Default command (inherited)
CMD []

EXPOSE 8001
