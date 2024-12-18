#! /bin/bash

set -x

### Basic Packages
apt -qq update
apt -qq -yy install equivs git devscripts lintian --no-install-recommends

### Remove these files and directories fomr upstream source.
files=(
    "Apache-2"
    "Dockerfile"
    "GPL-2"
    "GPL-3"
    "README.md"
    "README"
    "ChangeLog"
    "*.asc"
    "*.asm"
    "*.c"
    "*.cmake"
    "*.codespell.cfg"
    "*.diff"
    "*.editorconfig"
    "*.h"
    "*.py"
    "*.sh"
    "*.yaml"
    "*.yml"
    ".directory"
    ".gitignore"
    "*Makefile*"
    "*LICENSE*"
    "*Notice*"
    "*WHENCE*"
    "*iwlwifi-*"
)

directories=(
    "lib/firmware/amd"
    "lib/firmware/amd-ucode"
    "lib/firmware/amdgpu"
    "lib/firmware/amdnpu"
    "lib/firmware/amdtee"
    "lib/firmware/ar3k"
    "lib/firmware/brcm"
    "lib/firmware/carl9170fw"
    "lib/firmware/cirrus"
    "lib/firmware/nvidia"
    "lib/firmware/r128"
    "lib/firmware/radeon"
)

echo "Removing files..."
for file in "${files[@]}"; do
    find . -type f -name "$file" -exec rm -f {} \; 2>/dev/null
done

echo "Removing directories..."
for dir in "${directories[@]}"; do
    rm -rf "$dir" 2>/dev/null
done

echo "Cleanup complete."

### Install Dependencies
mk-build-deps -i -t "apt-get --yes" -r

### Build Deb
debuild -b -uc -us

### Move Deb to current directory because debuild decided
### that it was a GREAT IDEA TO PUT THE FILE ONE LEVEL ABOVE
mv ../*.deb .
