#!/usr/bin/bash

# Include the bash libraries for the script.
source $(dirname "${BASH_SOURCE[0]}")/../lib/_common.sh
source $(dirname "${BASH_SOURCE[0]}")/../lib/_mods.sh

MOD_LIST=$(getMods)

echo "[+] Detecting mods from mod-list.json..."
for MOD in ${MOD_LIST[@]}; do
    echo "[*] Detected mod: ${MOD}"
    getLatestMod ${MOD}
done