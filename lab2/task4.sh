#!/bin/bash

shopt -s nullglob

total_bytes=0
total_lines=0
count=0


echo "Files *.txt in $HOME:"

for file in "$HOME"/*.txt; do
	[[ -f "$file" ]] || continue

	bytes=$(stat -c %s "$file")
	lines=$(wc -l < "$file")

	echo " $file ($bytes bytes, $lines lines)"

	total_bytes=$((total_bytes + bytes))
	total_lines=$((total_lines + lines))
	count=$((count + 1))
done

if ((count==0)); then
	echo "txt-files weren't found"
	exit 0
fi

echo "All files: $count"
echo "Size of files: $total_bytes bytes"
echo "Lines: $total_lines"


