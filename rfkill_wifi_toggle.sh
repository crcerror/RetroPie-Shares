#!/bin/sh
wlanstat=$(rfkill list wlan | grep -c ": no")
if [ $wlanstat -lt 2 ]; then
    echo "I will unblock Wifi"
    sleep 5
    sudo rfkill unblock wifi
else
   echo "I will block Wifi"
   sleep 5
   sudo rfkill block wifi
fi
