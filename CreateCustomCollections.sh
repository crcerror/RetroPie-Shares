#!/bin/bash

# >> Create Custom Collection <<
# this creates custom-collections through collections.txt file
# Content of created files will never be altered!
# Now enter collections names, every single line will result in a new collection
#
# Remember you need ES 2.6.0 at least to use that features
# v1.1, v1.2 Avoid empty entries and truncate CR char from windows files
# v1.3 RegEx handling and code cleanup

# As always ;) Thx @meleu and @pjft // cyperghost

txtfile="$HOME/RetroPie/roms/collections.txt"
colpath="/opt/retropie/configs/all/emulationstation/collections"

mkdir -p "$colpath"

while read line; do
    if [[ "$line" =~ ^[][()\ \'_A-Za-z0-9-]+$ ]]; then
        file="$colpath/custom-$line.cfg"
        echo "Creating \"$file\"."
        touch "$file"
    else
        echo "Ignoring \"$line\": invalid filename." >&2
    fi
done < <(tr -d '\r' < "$txtfile")
