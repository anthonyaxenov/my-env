#!/bin/bash
set -e
for script in "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/install/*.sh
do
    . "$script"
done
