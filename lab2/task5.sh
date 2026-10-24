#!/bin/bash

dir="${1:-.}"

if [[ ! -d "$dir" ]]; then
	echo "Error: '$dir' is not a directory" >&2
	exit 1
fi

find "$dir" -type f -exec md5sum {} + 2>/dev/null | awk '
{
	hash = $1
	name = substr($0, 35)
	cnt[hash]++
	files[hash] = files[hash] " " name "\n"
}
END{
	for (h in cnt)
		if (cnt[h] > 1)
			printf "%d\n%s", cnt[h], files[h]
}'
