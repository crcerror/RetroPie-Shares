#!/bin/bash
#
# Background Music Box (BMB)
#
# 02/09/2019
#
# Shows current song, and let you select serveral songs in playlist
# you need (again) lsof tool to detect current song playing
# you need also mp3info to obtain play length of current song
# Type `sudo apt install lsof mp3info` to install
#
# This script provides some functions how a graphical player CAN look like
# Plesae dear community, feel free to improve this script ;)
#
# by cyperghost for https://retropie.org.uk/
# https://retropie.org.uk/forum/topic/21029

# ---- Set variables ----
BGM_PATH="$HOME/RetroPie/bgm"
BGM_PLAYER="mpg123"
BGM_PATH="$(realpath $BGM_PATH)"
BGM_TYPE=".*\.\(mp3\|ogg\)"
PLAYER_PID="$(pgrep -f $BGM_PLAYER)"
PLAYER_INSTANCE="$(pgrep -c -f $BGM_PLAYER)"
PLAYER_SHUFFLE="$BGM_PLAYER -q -Z $BGM_PATH/*.mp3 > /dev/null"

# ---- function calls ----
# Dialogs - dialog_error parse test, dialog_yesno parse text and dialogtitle
# Display dialog --msgbox with text parsed with by function call

function dialog_error() {
    dialog --title " Error! " --msgbox "$1" 7 45
}

function dialog_yesno() {
    dialog --title " $2 " --yesno "$1" 10 55
}

# ---- Script Start ----

! [[ -d $BGM_PATH ]] && dialog_error "Directory $BGM_PATH not found! Exit!" && exit

if [[ $PLAYER_INSTANCE -eq 0 ]]; then
    dialog_yesno "$BGM_PLAYER not running!\nShould I try to start it using shuffle mode?\n\nShuffle command: $PLAYER_SHUFFLE"
    [[ $? -eq 0 ]] || exit
    $PLAYER_SHUFFLE &
    exit
fi

  [[ $PLAYER_INSTANCE -eq 0 ]] && dialog_error "$BGM_PLAYER not found! Exit!" && exit
! [[ $PLAYER_INSTANCE -eq 1 ]] && dialog_error "There are $PLAYER_INSTANCE instances of $BGM_PLAYER running! Only 1 instance supported!" && exit

# Build file array
cd "$BGM_PATH"
readarray -t array < <(find -maxdepth 1 -iregex $BGM_TYPE -type f | sort)

# Get current song and number of song
songindir="$(ps aux | grep $BGM_PLAYER | grep -o $BGM_PATH | wc -l)"
songname=$(lsof -c $BGM_PLAYER -F | grep "$BGM_PATH")
songname="${songname##*/}"
mp3length=$(mp3info "$songname" -p %m:%s)

# Build dialog
while true; do
    cmd=(dialog --backtitle "Currently Playing: $songname - $mp3length"\
                --extra-button --extra-label " PlayList " \
                --title " The Background Music Box " \
                --ok-label " Let's play " --cancel-label " Cancel " \
                --help-button --help-label " Shuffle " \
                --stdout --no-items --default-item "$file" \
                --menu "Currently ${#array[@]} music files found in $BGM_PATH\n$songindir tracks are active in current Playlist!\n${#farray[@]} tracks stored to new Playlist!" 16 68 12)
    file=$("${cmd[@]}" "${array[@]#*/}")
    button=$?

    # Do actions
    case $button in
        0) #Select/Okay Button
            kill $PLAYER_PID >/dev/null 2>&1
            sleep 0.5
            [[ ${#farray[@]} -eq 0 || "${farray[-1]}" != "$BGM_PATH/$file" ]] && farray+=("$BGM_PATH/$file")
            $BGM_PLAYER -q "${farray[@]}" > /dev/null &
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
           farray+=("$BGM_PATH/$file")
       ;;
     esac
done
