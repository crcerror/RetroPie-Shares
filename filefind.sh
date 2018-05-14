#!/bin/bash
# Working example!
# by cyperghost
# Without using IFS or other bad tricks!
search="Tetris"
extension=".*\(gb\|smc\)"
rombase="/home/pi/RetroPie/roms"

cd $rombase
filearray=$(find -iname "$search*" -iregex "$extension")


# Rebuild Filenames, if $i starts with "./" an new filename is found
# Array postion 1 is always empty, we may can use that later
for i in $filearray; do
#    [[ ${i:0:2} == "./" ]] && array+=("$ii") && ii= && ii="$i"
#    [[ ${i:0:2} != "./" ]] && ii="$ii $i"

    if [[ ${i:0:2} == "./" ]]; then
        array+=("$ii")
        ii=
        ii="$i"
    fi

    ii="$ii $i"

done

unset filearray

# Array done
# will show first entry as example
echo "${array[0]}" # This is first array entry! It's empty!
echo "${array[1]}" # This is second array entry!
