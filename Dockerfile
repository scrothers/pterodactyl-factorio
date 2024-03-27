FROM --platform=linux/x86_64 rockylinux:9

# Default build environments for the container.
ENV FACTORIO_BUILD="headless"
ENV FACTORIO_DISTRO="linux64"
ENV FACTORIO_VERSION="stable"

# Metadata labels for the container.
LABEL org.opencontainers.image.authors="factorio@scrothers.com"
LABEL description="Factorio game server container designed for the Pterodactyl control panel."
LABEL com.factorio.build="${FACTORIO_BUILD}"
LABEL com.factorio.distro="${FACTORIO_DISTRO}"
LABEL com.factorio.version="${FACTORIO_VERSION}"

# Default environment variables from Pterodactyl.
ENV TZ="UTC"
ENV STARTUP="/docker-entrypoint.sh"
ENV SERVER_IP="127.0.0.1"
ENV SERVER_MEMORY="512"
ENV P_SERVER_LOCATION="Pterodactyl"
ENV P_SERVER_UUID="00000000-0000-0000-0000-000000000000"
ENV P_SERVER_ALLOCATION_LIMIT="0"

# Egg provided environment variables.
ENV SERVER_NAME="Pterodactyl Factorio Server"
ENV SERVER_DESCRIPTION="Server hosted by Pterodactyl game server control panel."
ENV SAVE_INTERVAL="30"
ENV SAVE_SLOTS="10"
ENV AFK_AUTO_KICK="0"
ENV SAVE_NAME="world"
ENV SERVER_SLOTS="20"
ENV SERVER_PASSWORD=""
ENV FACTORIO_USERNAME=""
ENV FACTORIO_TOKEN=""

# Prepare the container to run the Factorio server.
RUN dnf install -y \
    jq \
    xz

# Install the various scripts and tools to the container.
ADD bin/ /usr/local/bin/
ADD lib/ /usr/local/lib/
RUN chmod +x /usr/local/bin/*

# Create the user that Pterodactyl will need to run the gameserver.
RUN     adduser -d /home/container -c "Factorio Server" -m -s /sbin/nologin container
#USER    container
WORKDIR /home/container