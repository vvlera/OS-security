#!/bin/bash

LOG="/tmp/run.log"

if [[ -f "$LOG" ]]; then
	count=$(wc -l < "$LOG")
else
	count=0
fi

date '+%Y-%m-%d %H:%M:%S' >> "$LOG"

echo "Hello, world!"

echo "The number of previous launches: $count" >&2
