#! /bin/bash

set -e
source "$(dirname "$0")/../scripts/utils.sh"

if ! command realpath -v realpath >/dev/null 2>&1; then
    info 'building realpath as it does not exist in path'
    make
fi
