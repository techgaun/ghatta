#!/bin/bash

# Author: Samar Acharya <samar@techgaun.com>
# A helper for using generator-nm in more personalized way

GHATTA_PATH="${HOME}/.ghatta"
declare -A CONFIG_FILES
CONFIG_FILES[EDITORCONF]="${GHATTA_PATH}/.editorconfig"
CONFIG_FILES[GITATTR]="${GHATTA_PATH}/.gitattributes"
CONFIG_FILES[GITIGNORE]="${GHATTA_PATH}/.gitignore"
CONFIG_FILES[NPMIGNORE]="${GHATTA_PATH}/.npmignore"

if [[ ! -d "${GHATTA_PATH}" ]]; then
    echo "Ghatta being run for the first time"
    echo "Initializing the default setup"
    echo "Configure default configs in ${GHATTA_PATH}"
    mkdir -p "${GHATTA_PATH}"
    for i in "${!CONFIG_FILES[@]}"; do
        wget "https://raw.githubusercontent.com/techgaun/ghatta/master/configs/${CONFIG_FILES[$i]##*/}" -O "${CONFIG_FILES[$i]}" > /dev/null 2>&1
    done
    echo "Completed the initialization..."
fi

npm -v > /dev/null 2>&1 || { echo "NPM not installed or not in any entries in PATH envvar"; exit 1; }
yo --help > /dev/null 2>&1 || npm install -g yo
npm install generator-nm
yo nm

if [[ ! -f "package.json" ]]; then
    echo "No package.json found... Is it a correct path?"
    exit 1
fi

shopt -s dotglob
for i in "${GHATTA_PATH}/"*; do
    cp -f "${i}" . # > /dev/null 2>&1
done

git init > /dev/null 2>&1 && echo "git init done..."
echo "Setup of node module development using generator-nm done..."
