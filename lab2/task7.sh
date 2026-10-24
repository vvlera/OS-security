#!/bin/bash

if (( $# == 0 )); then
	exit 1
fi

: > even.txt
: > odd.txt

processed=0
skipped=0

for n in "$@"; do
	if [[ ! "$n" =~ ^-?[0-9]+$ ]]; then
		echo "Skip '$n': it's not an integer" >&2
		continue
	fi
	processed=$(( processed + 1))

	if (( n % 3 == 0)); then
		skipped=$(( skipped +1))
		continue
	fi

	if ((n % 2 == 0)); then
		echo "$n" >> even.txt
	else
		echo "$n" >> odd.txt
	fi
done

echo "The number of prccessed numbers: $processed"
