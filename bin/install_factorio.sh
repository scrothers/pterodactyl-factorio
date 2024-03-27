#!/usr/bin/bash

# Include the bash libraries for the script.
source $(dirname "${BASH_SOURCE[0]}")/../lib/_common.sh
source $(dirname "${BASH_SOURCE[0]}")/../lib/_game.sh

# The download URL to use to fetch the install.
DOWNLOAD_URL="https://www.factorio.com/get-download/${FACTORIO_VERSION}/${FACTORIO_BUILD}/${FACTORIO_DISTRO}"

echo "[+] Downloading Factorio..."
/usr/bin/curl -C -L -o /tmp/factorio.tar.xz ${DOWNLOAD_URL}

echo "[+] Extracting Factorio..."
/usr/bin/tar xf \
    /tmp/factorio.tar.xz \
    -C /home/container/ \
    --strip-components=1

echo "[+] Removing temporary download file..."
rm -f /tmp/factorio.tar.xz

echo "[+] Creating required folders..."
mkdir -p /home/container/{config,data,mods,saves,temp,worlds}