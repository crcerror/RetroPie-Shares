#!/bin/bash
#
# Background Music Box (BMB)
#
# Shows current song, and let you select serveral songs
# you need lsof tool to detect current song playing
# install with: sudo apt install lsof
#
# This script provides some functions how a graphical player CAN look like
# Plesae dear community, feel free to improve this script ;)
#
# by cyperghost for https://retropie.org.uk/


# ---- Set variables ----

BGM_PATH="/home/pi/BGM"
BGM_PLAYER="mpg123"
BGM_TYPE=".*\.\(mp3\|ogg\)"
PLAYER_PID="$(pgrep -f $BGM_PLAYER)"
PLAYER_INSTANCE="$(pgrep -c -f $BGM_PLAYER)"
PLAYER_SHUFFLE="$BGM_PLAYER -q -Z $BGM_PATH/*.mp3"
# ---- function calls ----

# Rebuild Filenames, if $i starts with "./" an new filename is found

function build_find_array() {

    local i;local ii
    local filefind="$1"

    for i in $filefind; do
        if [[ ${i:0:2} == "./" ]]; then
            array+=("${ii:2}")
            ii=
            ii="$i"
         else
            ii="$ii $i"
         fi
    done

    array+=("${ii:2}")
    unset array[0]
}

# Dialog Error
# Display dialog --msgbox with text parsed with by function call

function dialog_error() {
    dialog --title " Error! " --msgbox "$1" 0 0
}

# ---- Script Start ----

! [[ -d $BGM_PATH ]] && dialog_error "Directory $BGM_PATH not found! Exit!" && exit
  [[ $PLAYER_INSTANCE -eq 0 ]] && dialog_error "$BGM_PLAYER not found! Exit!" && exit
! [[ $PLAYER_INSTANCE -eq 1 ]] && dialog_error "There are $PLAYER_INSTANCE instances of $BGM_PLAYER running! Only 1 instance supported!" && exit

# Build file array
cd "$BGM_PATH"
build_find_array "$(find . -maxdepth 1 -iregex $BGM_TYPE -type f | sort)"

# Get current song
songname=$(lsof -c $BGM_PLAYER -F | grep "$BGM_PATH")
songname="${songname##*/}"

# Build dialog
while true; do
    cmd=(dialog --backtitle "Currently Playing: $songname" \
                --extra-button --extra-label " PlayList " \
                --title " The Background Music Box " \
                --ok-label " Select " --cancel-label " Cancel " \
                --help-button --help-label " Shuffle " \
                --stdout --no-items --default-item "$file" \
                --menu "Currently ${#array[@]} music files found in $BGM_PATH\n${#farray[@]} songs stored in Playlist!" 16 68 12)
    file=$("${cmd[@]}" "${array[@]}")
    button=$?

    # Do actions
    case $button in
        0) #Select/Okay Button
            kill $PLAYER_PID
            sleep 0.5
            farray+=("$file")
            $BGM_PLAYER -q "${farray[@]}" &
            exit
        ;;

        1) #Cancel Button
            exit
        ;;

        2) #HELP/SHUFFLE Button
            kill $PLAYER_PID
            sleep 0.5
            $PLAYER_SHUFFLE &
            exit
        ;;

        3) #EXTRA/PLAYLIST Button
           farray+=("$file")
       ;;
     esac
done
