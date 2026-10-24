#!/bin/bash

if (( $# != 1 )); then
    echo "Usage: $0 file.csv" >&2
    exit 1
fi

file="$1"
if [[ ! -r "$file" ]]; then                  
    echo "Error: cannot read '$file'" >&2
    exit 1
fi

{
    awk -F, '
    NR > 1 {
        sub(/\r$/, "")
        if (NF < 4) next
        amount = $3 * $4
        total += amount
        count++
        if (count == 1 || amount > max) { max = amount; max_line = $0 }
    }
    END {
        if (count == 0) { print "No data about sales"; exit 1 }
        printf "Number of sales:      %d\n", count
        printf "Sum of sales:     %.2f\n", total
        printf "Middle cost:      %.2f\n", total / count
        printf "The most expensive sale:  %.2f (%s)\n", max, max_line
    }' "$file"
} | tee sales_report.txt
