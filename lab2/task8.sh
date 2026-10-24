#!/bin/bash

usage() {
    cat <<EOF
Usage: $0 [-h] [-v] [-o file] -a|-s|-m|-d|-p num1 num2 [num ...]

Options:
  -h        show this help
  -v        verbose output
  -o file   write result to file
Operation (exactly one):
  -a  addition
  -s  subtraction
  -m  multiplication
  -d  division
  -p  power
EOF
}

verbose=0
outfile=""
op=""

log() {
    if (( verbose )); then
        echo "[v] $*" >&2
    fi
}

set_op() {
    if [[ -n "$op" && "$op" != "$1" ]]; then
        echo "Error: only one operation allowed" >&2
        exit 1
    fi
    op="$1"
}

while getopts ":hvo:asmdp" opt; do
    case "$opt" in
        h) usage; exit 0 ;;
        v) verbose=1 ;;
        o) outfile="$OPTARG" ;;
        a) set_op add ;;
        s) set_op sub ;;
        m) set_op mul ;;
        d) set_op div ;;
        p) set_op pow ;;
        :) echo "Error: option -$OPTARG requires an argument" >&2; exit 1 ;;
        \?) echo "Error: unknown option -$OPTARG" >&2; usage >&2; exit 1 ;;
    esac
done

shift $(( OPTIND - 1 ))

if [[ -z "$op" ]]; then
    echo "Error: no operation specified (-a, -s, -m, -d, -p)" >&2
    exit 1
fi

if (( $# < 2 )); then
    echo "Error: at least two numbers required" >&2
    exit 1
fi

for n in "$@"; do
    if [[ ! "$n" =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
        echo "Error: '$n' is not a number" >&2
        exit 1
    fi
done

log "operation: $op"
log "numbers: $*"

result=$(awk -v op="$op" 'BEGIN {
    r = ARGV[1] + 0
    for (i = 2; i < ARGC; i++) {
        x = ARGV[i] + 0
        if      (op == "add") r += x
        else if (op == "sub") r -= x
        else if (op == "mul") r *= x
        else if (op == "pow") r = r ^ x
        else if (op == "div") {
            if (x == 0) { print "Error: division by zero" > "/dev/stderr"; exit 2 }
            r /= x
        }
    }
    printf "%.15g\n", r
}' "$@")

status=$?
if (( status != 0 )); then
    exit "$status"
fi

log "result: $result"

if [[ -n "$outfile" ]]; then
    echo "$result" > "$outfile"
    log "result written to $outfile"
else
    echo "$result"
fi
