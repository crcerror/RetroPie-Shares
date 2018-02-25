#!/bin/bash
# SaveStateFix
#
# A small tool to fix savelocation of some emulators
#
# Nothing awesome, just a bit of cosmetics
#
# 25/02/18 - Initial version
#
#
# What is needed for init? MANDOTARY!!!
# Emulatorname for case selection - Parameter 1 > $2
# ROM itself for copying files - Parameter 2 > $3
#
# Parameter 3: Optinal system $1 or all, to select place of retroarch.cfg
# if Parameter 3 is missing then 'all' is set as standard config
#

#[ -z "$1" ] && echo "SavePathFix Check: Please parse '$2' for emulator usage! Error!" >&2 && exit 1
#[ -z "$2" ] && echo "SavePathFix Check: Please parse '$3' for status !" >&2 && exit 1
#[ "${1:0:1}" = "/" ] && echo "SavePathFix Check: You likely entered a path location! Please parse '$3'! Error!" >&2 && exit 1
#[ "${2:0:1}" != "/" ] && echo "SavePath Fix Check: You like did not parse '$3' - This is needed!" >&2 && exit 1 

EMULATOR="$1"
ROM="$2"
SYSTEM="$3"

[ -z "$SYSTEM" ] && SYSTEM="all"

ROM_NAME="$(basename "$ROM")"
ROM_PATH="$(dirname "$ROM")"
ROM_NO_EXT="${ROM_NAME%.*}"

CONFIG_DIR="/opt/retropie/configs/$SYSTEM"
CONFIG_FILE="$config_dir/retroarch.cfg"

# This will determine of savestate directory = config
# This is part of hiuilits Boilerplate script, with small modification
# if '~' is detected then expand full homepath
function get_config() {
    local config
    config="$(grep -Po "(?<=^$1 = ).*" "$CONFIG_FILE")"
    config="${config%\"}"
    config="${config#\"}"
    [ "${config:0:1}" = "~" ] && config="${config#??}" && config=~/"$config"
}

# This will determine which script is curently running
# Is it 'runcommand-onend.sh' or 'runcommand-onstart.sh' 
function get_runcommand() {
   local i
   local file_array=("runcommand-onend.sh" "runcommand-onstart.sh" "mpg123")
   for i in "${file_array[@]}"
   do
      [[ $(pgrep -f "$i") ]] && echo "$i" 
   done
}

# Determining file ages
function file_age() {

    local files
        for file in "${files[@]}"; do
            [[ -f "$file" ]] && fage=$(date +%s -r "$file") && \
            fage=$(($fage - $now)) && \
            [[ ${fage#-} -gt "15" ]] && sudo rm -f "$file"
        done
}

case "$EMULATOR"
