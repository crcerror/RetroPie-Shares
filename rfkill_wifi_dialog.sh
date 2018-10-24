#!/bin/bash
# Activate/Deactivate Wifi connection with rfkill
# by cyperghost

MYIP=$(ip a s|sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')
WLANSTAT=$(rfkill list wlan | grep -c ": no")

ip_text="Your IP adress is:\n\n$MYIP\n\n"

if [ $WLANSTAT -lt 2 ]; then
    ip_text="${ip_text}\nYour WIFI adapter seems to be blocked or is not available.\n\n\
             Select ENABLE WIFI to activate or unblock WIFI\n             Select CANCEL to abort any action!"
    action="sudo rfkill unblock wifi"
    button="Enable WIFI"
else
    ip_text="${ip_text}\nYour WIFI adapter seems to be functional.\n\n\
             Select BLOCK WIFI to disable or block WIFI\n             Select CANCEL to abort any action!"
    action="sudo rfkill block wifi"
    button="Block WiFi"
fi

dialog --title "Change WIFI status" --defaultno \
       --backtitle "RFKILL dialog - enable/disable WIFI adapters" \
       --yes-button "$button" --no-button "Cancel" \
       --yesno "$ip_text" 0 0

[[ $? -eq 0 ]] && $action
