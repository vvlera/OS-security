#!/bin/bash

usage() {
    echo "Usage: $0 [-f txt|csv] [-g] [-h] file.csv" >&2
}

format="txt"
gen_sql=0

while getopts ":f:gh" opt; do
    case "$opt" in
        f) format="$OPTARG" ;;
        g) gen_sql=1 ;;
        h) usage; exit 0 ;;
        :) echo "Error: option -$OPTARG needs an argument" >&2; exit 1 ;;
        \?) echo "Error: unknown option -$OPTARG" >&2; usage; exit 1 ;;
    esac
done
shift $(( OPTIND - 1 ))

if [[ "$format" != "txt" && "$format" != "csv" ]]; then
    echo "Error: format should be txt or csv" >&2
    exit 1
fi

(( gen_sql )) && format="csv"

if (( $# != 1 )); then
    usage
    exit 1
fi

file="$1"
if [[ ! -r "$file" ]]; then
    echo "Error: cannot read '$file'" >&2
    exit 1
fi

IFS=$'\t' read -r count total avg max max_product < <(
    awk -F, '
    NR > 1 {
        sub(/\r$/, "")
        if (NF < 4) next
        amount = $3 * $4
        total += amount
        count++
        if (count == 1 || amount > max) { max = amount; prod = $2 }
    }
    END {
        if (count == 0) exit 1
        printf "%d\t%.2f\t%.2f\t%.2f\t%s\n", count, total, total / count, max, prod
    }' "$file"
)

if [[ -z "$count" ]]; then
    echo "Error: no data about sales in file" >&2
    exit 1
fi

if [[ "$format" == "txt" ]]; then
    {
        printf "Number of sales:      %s\n" "$count"
        printf "Sum of sales:     %s\n" "$total"
        printf "Middle cost:      %s\n" "$avg"
        printf "The most expensive sale:  %s (%s)\n" "$max" "$max_product"
    } | tee sales_report.txt
else
    {
        echo "sales_count,total_sales,average_sale,max_sale,max_sale_product"
        echo "$count,$total,$avg,$max,$max_product"
    } | tee sales_report.csv
fi

if (( gen_sql )); then
    {
        echo "-- Import data from  sales_report.csv in PostgreSQL"
        echo "CREATE TABLE IF NOT EXISTS sales_report ("
        echo "    id               SERIAL PRIMARY KEY,"
        echo "    sales_count      INTEGER,"
        echo "    total_sales      NUMERIC(14,2),"
        echo "    average_sale     NUMERIC(14,2),"
        echo "    max_sale         NUMERIC(14,2),"
        echo "    max_sale_product TEXT,"
        echo "    created_at       TIMESTAMP DEFAULT now()"
        echo ");"
        echo
        awk -F, 'NR > 1 {
            gsub(/\047/, "\047\047", $5)       
            printf "INSERT INTO sales_report (sales_count, total_sales, average_sale, max_sale, max_sale_product)\n"
            printf "VALUES (%s, %s, %s, %s, \047%s\047);\n", $1, $2, $3, $4, $5
        }' sales_report.csv
        echo
        echo "-- Alternative INSERT"
        echo "-- \\copy sales_report(sales_count, total_sales, average_sale, max_sale, max_sale_product) FROM 'sales_report.csv' WITH (FORMAT csv, HEADER true)"
    } > sales_report.sql
fi
