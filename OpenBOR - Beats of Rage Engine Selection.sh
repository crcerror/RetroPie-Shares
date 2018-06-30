#!/bin/bash
# Graphical Menu to select OpenBOR custom files
# Thank to darknior for working on OpenBOR
# Follow hin @chrono
# For setup read more here
# https://retropie.org.uk/forum/topic/13784
#
# I'm using @darkniors file nameing convention so every game episode uses
# gameepisode.bor/data directory structure
#
# The purposes? To make use of runcommand.sh for better compatibility to RetroPie setups
# coded by cyperghost
# For https://retropie.org.uk/

###### --------------------- INIT ---------------------
readonly VERSION="0.9_063018"
readonly TITLE="OpenBOR - cyperghosts Episode selector"
readonly BORBASE_DIR="/home/pi/RetroPie/roms/ports/openbor"
readonly ROOTDIR="/opt/retropie"
###### --------------------- INIT ---------------------



###### --------------------- JOY00 ---------------------

function start_joy(){

   ### >>>> RIPPED OUT OF RUNCOMMAND.SH ---- Please improve!

        # call joy2key.py: arguments are curses capability names or hex values starting with '0x'
        # see: http://pubs.opengroup.org/onlinepubs/7908799/xcurses/terminfo.html
        "$ROOTDIR/supplementary/runcommand/joy2key.py" "/dev/input/js0" kcub1 kcuf1 kcuu1 kcud1 0x0a 0x09 &
        JOY2KEY_PID=$!

}

function end_joy(){

   ### >>>> RIPPED OUT OF RUNCOMMAND.SH ---- Please improve!


    if [[ -n "$JOY2KEY_PID" ]]; then
        kill -INT "$JOY2KEY_PID"
    fi

    sleep 1
}

###### --------------- Dialog Functions ---------------

# Dialog Error
# Display dialog --msgbox with text parsed with by function call

function dialog_error() {
    dialog --title " Error " --backtitle " $TITLE - $VERSION " --infobox "$1" 0 0
}

# This builds dialog for OpenBOR directories
# We need to create valid array (dialog_array) before
# I disabled tags, so selections are showen exactly as in ROMs

function dialog_selectBOR() {

    # Create array for dialog
    local dialog_array
    local i
    for i in "${array[@]}"; do
        dialog_array+=("$i" "${i:2:-4}")
    done

    # old file array isn't needed anymore!
    unset array

    # -- Begin Dialog
    local cmd=(dialog --backtitle "$TITLE - $VERSION " \
                      --title " Select your Beats of Rage Episode " \
                      --ok-label " Select " \
                      --cancel-label " Exit to ES " \
                      --no-tags --stdout \
                      --menu "There are $((${#dialog_array[@]}/2)) games available\nWhich you want to play:" 16 70 16)
    local choices=$("${cmd[@]}" "${dialog_array[@]}")
    echo "$choices"
    # -- End Dialog
}

###### --------------- Dialog Functions ---------------




###### --------------- Array Functions ---------------

# Rebuild Filenames, if $i starts with "./" an new filename is found
# Array postion 1 is always empty, we can use that later

function build_find_array() {

    local i;local ii
    local filefind="$1"

    for i in $filefind; do
        if [[ ${i:0:2} == "./" ]]; then
            array+=("$ii")
            ii=
            ii="$i"
         else
            ii="$ii $i"
         fi
    done
    array[0]="$ii"

}

###### --------------- Array Functions ---------------




###### -------------- M A I N B U I L D --------------

# Get OpenBOR-directories and build valid array, make precheck

if [[ -d $BORBASE_DIR ]]; then
    cd "$BORBASE_DIR"
    bor_files=$(find -maxdepth 1 -iname "*.bor" -type d 2>/dev/null)
else
    dialog_error "No $BORBASE_DIR found!"
    sleep 3
    exit
fi

# Are there any BOR Directories available?

if [[ -z $bor_files ]]; then
    dialog_error "No BOR directories found in location:\n$BORBASE_DIR"
    sleep 3
    exit
fi

# Start Selection Dialog

start_joy

build_find_array "$bor_files"
BOR_file=$("dialog_selectBOR")

end_joy

if [[ -z $BOR_file ]]; then
    dialog_error "No Selection made ... going back to ES!"
    sleep 1
    exit
fi

# Finally using RUNCOMMAND.SH to initiate prober start of games

BOR_file="$BORBASE_DIR${BOR_file#.*}"
"/opt/retropie/supplementary/runcommand/runcommand.sh" 0 _PORT_ "openbor" "$BOR_file"