#!/bin/bash

# RetroAchievements - automatic v1.0 by cyperghost aka crcerror
# Synopsis!
# This script enables the RetroAchievement flag from games that are stored in
# a dedicated custom-collection. This custom collection must be added to the
# array_cheevos variable. So this script enables in default mode the connection
# to the RA server and closes it if the game is not "marked" as Achievement.

# Settings mode
# 0 = disable this script
# 1 = set cheevos_enable flag true if game is in Achievements-Collection
#     and sets chevos_enalbe flag to false if it is not! (DEFAULT!)
# 2 = set cheevos_enable flag true if game is in Achievements-Collection
#     but does nothing if annother game is not in Achievements-Collection
# 3 = enable achivments at every run, there is no disabeling!
# 4 = disable achivments at every run, there is no enabling!

script_mode=1

# Array of location to Achievements-Collection
# As the collection files are usual text files we can just cross check
# existane of ROM files in collection
# Please enter full path and filename to collection - they are case sensitive!

array_cheevos=("/opt/retropie/configs/all/emulationstation/collections/custom-RA - Battle Bugs.cfg" \
               "/opt/retropie/configs/all/emulationstation/collections/custom-RetroAchievements.cfg")

### DEBUG (this is runcommand $3 in callingscript)
es_rom="$1"
### DEBUG (this is runcommand $1 in callingscript)
# --> build path /opt/retropie/configs/$1/retroarch.cfg
# If no parameter pathed use /opt/retropie/configs/all/retroarch.cfg
es_sys="/opt/retropie/configs/$2/retroarch.cfg"
[[ -z "$2" ]] && es_sys="/opt/retropie/configs/all/retroarch.cfg"
# -- F U N C T I O N S --

# function determinating the cheevos-flag from retroarch.cfg for called sys
# function calls are on/off for enabling/disableling cheevos function
# status for checking if cheevos are enabled/disabled out of $/$sys/retroarch.cfg
# personally that's my first RegEx lesson

func_cheevos()
{
case "${1^^}" in

    "OFF")
        sed -i -e "s|^cheevos_enable\ *=\ *\"*true\"*|cheevos_enable = \"false\"|" \
        "$es_sys" &> /dev/null
    ;;

    "ON")
        sed -i -e "s|^cheevos_enable\ *=\ *\"*false\"*|cheevos_enable = \"true\"|" \
        "$es_sys" &> /dev/null
    ;;

    "STATUS")
        grep "cheevos_enable\ *=\ *\"*true\"*" &> /dev/null \
        "$es_sys" && ra_cheevos=1
    ;;
esac
}

# -- M A I N --

# Ask for status of cheevos of current system (/opt/retropie/config/$sys/retroarch.cfg)
func_cheevos status

# Open array and search collections entries for started ROM
# While loop reads entries line by line
# There is a check performed that checks collection-file existance!
# Annother approch could be \for a in ${array_cheevos[@]}\ but like idx's

while [[ "$idx" -lt "${#array_cheevos[@]}" ]]
 do
    ! [[ -f "${array_cheevos[$idx]}" ]] \
    && echo "RetroAchievements.sh: Collection file ${array_cheevos[$idx]} not found" >&2 \
    && exit 1

    while read line
        do
            [[ "$line" == "$es_rom" ]] && col_cheevos=1 #<-- Found ROM in Collection
        done < "${array_cheevos[$idx]}"

    idx=$(( $idx + 1 ))
 done

# Use Cases
case "$script_mode" in
    0)
        echo "0:RetroAchievements.sh: script_mode is setted to 0 - Exit" >&2
    ;;
    1)
        echo "1:RetroAchievements.sh: (0$ra_cheevos): retroarch.cfg - (0$col_cheevos):" \
             "cheevo found for $es_rom" >&2
        [[ "$col_cheevos" ]] && [[ -z "$ra_cheevos" ]] && func_cheevos on
        [[ -z "$col_cheevos" ]] && [[ "$ra_cheevos" ]] && func_cheevos off
    ;;
    2)
        echo "2:RetroAchievements.sh: (0$ra_cheevos): retroarch.cfg - (0$col_cheevos):" \
             "cheevo found for $es_rom" >&2
        [[ "$col_cheevos" ]] && [[ -z "$ra_cheevos" ]] && func_cheevos on
    ;;
    3)  echo "3:RetroAchievements.sh: Enable RetroAchievments for system: $es_sys" >&2
        [[ -z "$ra_cheevos" ]] && func_cheevos on
    ;;
    4)  echo "4:RetroAchievements.sh: Disable RetroAchievments for system: $es_sys" >&2
        [[ "$ra_cheevos" ]] && func_cheevos off
    ;;
esac
