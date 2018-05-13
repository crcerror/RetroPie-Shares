#!/bin/bash
# Working example!
# How to find files maybe usefull for custom collections
# by cyperghost
# Without using IFS or other bad tricks!

search="Tetris"
extension=".*\(gb\|smc\)"
rombase="/home/pi/RetroPie/roms"

cd $rombase
filearray=$(find -name "$search*" -iregex "$extension")

# Rebuild Filenames, if $i starts with "./" an new filename is found
# Array postion 1 is always empty, we may can use that later
for i in ${filearray[@]}; do
    if [[ ${i:0:2} == "./" ]]; then
        array+=("${ii:1}")
        ii=
    fi

    ii="$ii $i"

done
unset filearray

# Array done
# will show first entry as example
echo "${array[0]}" # This is first array entry! It's empty!
echo "${array[1]}" # This is second array entry!
