#!/usr/bin/bash

export MODS_LOCATION="/Users/crothers/Downloads/factorio/ir3/mods"

function hasMods {
    if [ -f "${MODS_LOCATION}/mod-list.json" ]; then
        if [[ -z "${FACTORIO_USERNAME}" || -z "${FACTORIO_TOKEN}" ]]; then
            echo "[X] The environment variables FACTORIO_USERNAME and FACTORIO_TOKEN are not both set, mod install/update functionality is disabled." >&2
            return 1
        else
            return 0
        fi
    else
        echo "[-] Mods are not installed." >&2
        return 1
    fi
}

function getMods {
    if hasMods; then
        jq -r ".mods|map(select(.enabled))|.[].name" "${MODS_LOCATION}/mod-list.json" | while read -r FACTORIO_MOD; do
            if [[ "${FACTORIO_MOD}" != "base" ]]; then
                echo ${FACTORIO_MOD}
            fi
        done
    fi
}

function getLatestMod {
    MOD_NAME="${1}"
    MOD_NAME_ENCODED="${1// /%20}"
    MOD_INFO_URL="https://mods.factorio.com/api/mods/${MOD_NAME_ENCODED}"
    MOD_INFO_JSON=$(curl --silent "${MOD_INFO_URL}")

    if ! echo "${MOD_INFO_JSON}" | jq -e .name >/dev/null; then
        echo "[X] Unable to locate mod: ${MOD_NAME}"
        return 0
    fi
    
    LATEST_VERSION_JSON=$(echo ${MOD_INFO_JSON} | jq '.releases | sort_by(.released_at) | reverse[0]')
    LATEST_VERSION=$(echo ${LATEST_VERSION_JSON} | jq -r '.version')
    LATEST_VERSION_SHA1=$(echo ${LATEST_VERSION_JSON} | jq -r '.sha1')
    CURRENT_VERSION=$(basename $(ls ${MODS_LOCATION}/${MOD_NAME}_*.zip) .zip | awk -F_ '{print $NF}')
    CURRENT_SHA1=$(sha1sum ${MODS_LOCATION}/${MOD_NAME}_*.zip | awk '{print $1}')

    echo " |- Current Version: ${CURRENT_VERSION} (${CURRENT_SHA1})"
    echo " |- Latest version: ${LATEST_VERSION} (${LATEST_VERSION_SHA1})"

    if [ ${CURRENT_VERSION} == ${LATEST_VERSION} ]; then
        echo " |- Latest version installed."
    else
        echo " |- Mod requires update, performing upgrade..."
    fi
    
    if [ ${LATEST_VERSION_SHA1} == ${CURRENT_SHA1} ]; then
        echo " |- Checksum matches upstream."
    else
        echo " |- Mod appears corrupted, replacing from mod server..."
    fi

    return 0
}

function downloadMod {
    
}