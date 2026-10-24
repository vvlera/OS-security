#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

bash "$SCRIPT_DIR/task1.sh"

less /tmp/run.log
